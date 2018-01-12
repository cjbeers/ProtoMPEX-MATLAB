function FIT=Full(PARA,PARA_BACK,DATA,OPT)

%****************
%Assign the input
%****************
PS=PARA.FP.PS;
NDPS=PARA.FP.NDPS;
ND=PARA.FP.ND;
NS=PARA.FP.NS;
NI=PARA.FP.NI;

NSPF=PARA.NP.NSPF;

if isempty(PARA_BACK)==0
    PS_B=PARA_BACK.FP.PS;
    PSB_B=PARA_BACK.FP.PSB;
    NDPS_B=PARA_BACK.FP.NDPS;
    ND_B=PARA_BACK.FP.ND;
else
    ND_B=0;
end

PSF_B=DATA.BACK.PSF_B;                 

%******************
%Max discritization
%******************
NDPSM=max(NDPS);

%************************************
%Calc indices for parallel processing
%************************************
[JOB,NPSS,NPSP,NPSPP,NAP_FIT,BLOG]=Parallel(PARA,OPT);

%**************************************************************************
%****************************  Start Search  ******************************
%**************************************************************************

%***************
%Allocate memory 
%***************
CHI_P=cell(1,NAP_FIT);
PSF_P=cell(1,NAP_FIT);
PSF_B_IND_P=cell(1,NAP_FIT);
CHI_F=cell(NI,NS);
PSF_F=cell(NI,NS);
PSF_B_IND_F=cell(NI,NS);
PSF_B_F=cell(NI,NS);
CHI_M=cell(1,NI);
PSF_M=cell(1,NI);
PSF_B_M=cell(1,NI);

NS_IND(1:NS)=0;
IGB_CON=cell(1,NSPF);
IGB_VAR=cell(1,NSPF);

CHI_F(1:NI,1:NS)={ones(1,NPSP*NPSS)*Inf};
PSF_F(1:NI,1:NS)={zeros(NPSP*NPSS,ND)};
PSF_B_IND_F(1:NI,1:NS)={zeros(1,NPSP*NPSS)};
PSF_B_F(1:NI,1:NS)={zeros(NPSP*NPSS,ND_B)};

CHI_M(1:NI)={ones(1,NS)*Inf};
PSF_M(1:NI)={zeros(NS,ND)};
PSF_B_IND_M=zeros(1,NS);
PSF_B_M(1:NI)={zeros(NS,ND_B)};

CHI_T(1:NPSP*NPSS*NS)=Inf;
PSF_T(1:NPSP*NPSS*NS,1:ND)=0;
PSF_B_IND_T(1:NPSP*NPSS*NS)=0;

PS_P(1:NS,1:ND,1:NDPSM)=0;
PARA_P(1:NS)={PARA};
PARA_BACK_P=cell(1,NS);
DATA_P=cell(1,NS);

for ii=1:NI  
    if ii==1
        fprintf('\nFit Iteration Number: %1i of %1i --- %2i Fit Points\n',ii,NI,NPSPP(1)*NPSS)
        
        %****************
        %Calc. reduce chi
        %****************
        if BLOG==0
            parfor jj=1:NAP_FIT
                [CHI_P{jj},PSF_P{jj},PSF_B_IND_P{jj},~]=Fun_2(PARA,DATA,OPT,JOB{jj},NAP_FIT,jj,1); 
            end
        else
            for jj=1:NAP_FIT
                [CHI_P{jj},PSF_P{jj},PSF_B_IND_P{jj},~]=Fun_2(PARA,DATA,OPT,JOB{jj},NAP_FIT,jj,1); 
            end
        end
        
        %***********************************
        %Assign reduce chi and fit variables
        %***********************************
        for jj=1:NAP_FIT
            N1=1+sum(NPSPP(1:jj-1))*NPSS;
            N2=sum(NPSPP(1:jj))*NPSS;
            
            CHI_F{ii,1}(N1:N2)=CHI_P{jj};
            PSF_F{ii,1}(N1:N2,1:ND)=PSF_P{jj};
            PSF_B_IND_F{ii,1}(N1:N2)=PSF_B_IND_P{jj};
            PSF_B_F{ii,1}(N1:N2,1:ND_B)=PSF_B(PSF_B_IND_P{jj},1:ND_B);
        end
        
        %****************************************
        %Assign temp reduce chi and fit variables
        %****************************************
        CHI_T(1:NPSP*NPSS)=CHI_F{ii,1};
        PSF_T(1:NPSP*NPSS,1:ND)=PSF_F{ii,1};
        PSF_B_IND_T(1:NPSP*NPSS)=PSF_B_IND_F{ii,1};
        
        for jj=1:NS
            %********************
            %Find min reduced chi
            %********************
            [CHI_M{ii}(jj),N1]=min(CHI_T(1:NPSP*NPSS));

            %********************
            %Assign fit variables
            %********************
            PSF_M{ii}(jj,1:ND)=PSF_T(N1,1:ND);
            PSF_B_IND_M(jj)=PSF_B_IND_T(N1);
            PSF_B_M{ii}(jj,1:ND_B)=PSF_B(PSF_B_IND_M(jj),1:ND_B);
            
            %***********************
            %Update temp reduced chi
            %***********************
            CHI_T(N1)=Inf;
        end
    else
        %************************************************
        %Select min reduced chi points in parameter space
        %************************************************
        for jj=1:NS
            fprintf('\nFit Iteration Number: %1i of %1i --- Tracking Point: %2i of %2i --- %2i Fit Points\n',ii,NI,jj,NS,NPSPP(1)*NPSS)
            
            %*************************************
            %Assign worker specific PARA structure
            %*************************************
            TEMP1=PARA_P{jj};
            
            %*************************************
            %Assign worker specific DATA structure
            %*************************************
            TEMP2=DATA_P{jj};
            
            %****************
            %Calc. reduce chi
            %****************
            if BLOG==0
                parfor kk=1:NAP_FIT
                    [CHI_P{kk},PSF_P{kk},PSF_B_IND_P{kk},~]=Fun_2(TEMP1,TEMP2,OPT,JOB{kk},NAP_FIT,kk,1);
                end
            else
                for kk=1:NAP_FIT
                    [CHI_P{kk},PSF_P{kk},PSF_B_IND_P{kk},~]=Fun_2(TEMP1,TEMP2,OPT,JOB{kk},NAP_FIT,kk,1);
                end
            end
            
            %***********************************
            %Assign reduce chi and fit variables
            %***********************************
            for kk=1:NAP_FIT
                N1=1+sum(NPSPP(1:kk-1))*NPSS;
                N2=sum(NPSPP(1:kk))*NPSS;
                
                CHI_F{ii,jj}(N1:N2)=CHI_P{kk};
                PSF_F{ii,jj}(N1:N2,1:ND)=PSF_P{kk};
                PSF_B_IND_F{ii,jj}(N1:N2)=PSF_B_IND_P{kk};
                PSF_B_F{ii,jj}(N1:N2,1:ND_B)=DATA_P{jj}.BACK.PSF_B(PSF_B_IND_P{kk},1:ND_B);
            end
        end
        
        %****************************************
        %Assign temp reduce chi and fit variables
        %****************************************
        for jj=1:NS
            CHI_T(1+(jj-1)*NPSP*NPSS:jj*NPSP*NPSS)=CHI_F{ii,jj};
            PSF_T(1+(jj-1)*NPSP*NPSS:jj*NPSP*NPSS,1:ND)=PSF_F{ii,jj};
            PSF_B_IND_T(1+(jj-1)*NPSP*NPSS:jj*NPSP*NPSS)=PSF_B_IND_F{ii,jj};
        end
                 
        for jj=1:NS
            %********************
            %Find min reduced chi
            %********************
            [CHI_M{ii}(jj),N1]=min(CHI_T(1:NPSP*NPSS*NS));
            
            NS_IND(jj)=ceil(N1/(NPSP*NPSS));
            
            %********************
            %Assign fit variables
            %********************
            PSF_M{ii}(jj,1:ND)=PSF_T(N1,1:ND);
            PSF_B_IND_M(jj)=PSF_B_IND_T(N1);
            PSF_B_M{ii}(jj,1:ND_B)=DATA_P{NS_IND(jj)}.BACK.PSF_B(PSF_B_IND_M(jj),1:ND_B);

            %***********************
            %Update temp reduced chi 
            %***********************
            CHI_T(N1)=Inf;
        end        
    end
    
    if ii<NI
        for jj=1:NS
            for kk=1:ND
                %*********************
                %Assign temp variables
                %*********************
                T1=PSF_M{ii}(jj,kk);
                if ii==1
                    T2=PS(kk,2)-PS(kk,1);
                else
                    T2=PS_P(jj,kk,2)-PS_P(jj,kk,1);
                end

                %*************************
                %Calc. new parameter space
                %*************************    
                if T1==PS(kk,1)
                    PS_P(jj,kk,1:NDPS(kk))=linspace(T1,T1+T2,NDPS(kk));               
                elseif T1==PS(kk,NDPS(kk))
                    PS_P(jj,kk,1:NDPS(kk))=linspace(T1-T2,T1,NDPS(kk)); 
                else
                    PS_P(jj,kk,1:NDPS(kk))=linspace(T1-T2,T1+T2,NDPS(kk));
                end
            end

            %**************************
            %Assign new parameter space
            %**************************
            PARA_P{jj}.FP.PS(1:ND,1:NDPSM)=PS_P(jj,1:ND,1:NDPSM);
            
            %*********************************
            %Assign background parameter space
            %*********************************
            if ii>1 && isempty(PARA_BACK)==0
                PS_B=PARA_BACK_P{jj}.FP.PS;
            end
            
            for kk=1:ND_B
                %*********************
                %Assign temp variables
                %*********************
                T1=PSF_B_M{ii}(jj,kk);
                T2=PS_B(kk,2)-PS_B(kk,1);
                
                %*************************
                %Calc. new parameter space
                %*************************    
                if T1==PS_B(kk,1)
                    PSB_B(kk,1:2)=[T1,T1+T2];               
                elseif T1==PS_B(kk,NDPS_B(kk))
                    PSB_B(kk,1:2)=[T1-T2,T1]; 
                else
                    PSB_B(kk,1:2)=[T1-T2,T1+T2];
                end
            end
            
            if isempty(PARA_BACK)==0
                %***********************************
                %Turn off background parameter print
                %***********************************
                OPT.PRINT.PARA_BACK{2}=0;
                
                %********************************************
                %Assign background parameter space boundaries
                %********************************************
                OPT.PARA_BACK{2}.PSB=PSB_B;

                %************************
                %Calc. background spectra
                %************************
                [PARA_BACK_P{jj},DATA_P{jj}]=MAIN_BACK(DATA,NSPF,OPT,2);
            else
                %*************************************************
                %Assign 'no background' worker specific sturctures
                %*************************************************
                PARA_BACK_P{jj}=[];
                DATA_P{jj}=DATA;
            end
        end
    elseif ii==NI
        for uu=1:NSPF
            %**********************************
            %Assign spectra specific parameters
            %**********************************
            NG=DATA.GRID{uu}.NG;
            
            %*****************************
            %Assign fit background spectra
            %*****************************
            IGB_CON{uu}(jj,1:NG)=DATA.BACK.IGB_CON{uu}(1,1:NG);

            IGB_VAR{uu}=zeros(NS,NG);
            if ii==1
                for jj=1:NS
                    IGB_VAR{uu}(jj,1:NG)=DATA.BACK.IGB_VAR{uu}(PSF_B_IND_M(jj),1:NG);
                end
            else
                for jj=1:NS
                    IGB_VAR{uu}(jj,1:NG)=DATA_P{NS_IND(jj)}.BACK.IGB_VAR{uu}(PSF_B_IND_M(jj),1:NG);
                end
            end
        end
    end
end

%******************************
%Assign permanent FIT sturcture
%******************************
FIT.FULL.CHI=CHI_F;
FIT.FULL.PSF=PSF_F;
FIT.FULL.PSF_B=PSF_B_F;
FIT.MIN.CHI=CHI_M;
FIT.MIN.PSF=PSF_M;
FIT.MIN.PSF_B=PSF_B_M;

%******************************
%Assign temporary FIT sturcture
%******************************
FIT.IGB_CON=IGB_CON;
FIT.IGB_VAR=IGB_VAR;

end
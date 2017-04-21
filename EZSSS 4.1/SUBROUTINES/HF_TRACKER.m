function [EV_track IND_track NB_track]=FH_EVal_Track(TRACKER,ss,FH,H,H_PARA,F_PARA)

%**************************************************************************
%If the following criteria are upheld then the eigenvalues are independent
%of frequency and a simplictic tracking algorithum is utilized.
%
%IF the fine structure is NOT considered.
%
%IF the static electric field, dynamic electric field, and magnetic field 
%vectors are parallel.
%
%IF the dynamic field is linearly polarized.
%
%NOTE:  Due to the fact the problem is defined such that the magnetic field
%vector has only a z-component the static and dynamic electric field must 
%only have a z-component if a magnetic field is present for this 
%simplicitic tracking alogrithum to be utilized.
%**************************************************************************

%**************************************************************************
%                                 CONTROLS
%**************************************************************************
%M_NG - Multipliers associated with the calculation of the estimate and 
%       exact frequency in which the eigenvalues are 'naturally grouped'. 
%       Note these multipliers should not be less then unity.  A larger
%       multiplier gives rise to a more conservative estimated naturally
%       grouped frequency.
%
%                       M_NG(1) -- Multiplier associated with estimated  
%                                  frequency for naturally grouping.
%
%                       M_NG(2) -- Multiplier associated with exact  
%                                  frequency for naturally grouping.
%
M_NG=[1.05 1.03];
%
%M_IN - The initial fractional frequency step size.  --- dnu = M_IN*nu --- 
%
M_IN=0.0002;
%
%ND - Maximum number of derivatives used in the tracking alogrithum.
%
ND=2;
%
%If the eigenvalues have a relative difference less than eps_deg they are
%consider degenerate.
eps_DEG=1e-8;
eps_EV=1e-5;
eps_LC=1e-2;
%
%Max value of relative error between predicted and actual eigenvalue
eps_EV_DM=[.01 .06 .1 .2];
eps_EV_DM_PO=[.015 .15 .2];
%
%Minimum value of second derivate that can be used in convergence and
%tracking tests
eps_EV_PL(:,1)=[1e-10 1e-10 1e-5];
eps_EV_PL(:,2)=[1e-10 1e-10 1e-7];
for ii=1:ND
    for jj=1:2
        eps_EV_PL(ii,jj)=eps_EV_PL(ii,jj)*1e-9^(ii);
    end
end
%
%Maximum allowed steps in approach towards solution
TI_max=14000;
%
%Number of non-degenerate eigenvalues to search through above and below
%preivous eigenvalue indicies
NSEV=3;
%
NPLC=3;
%
NPDN=2;
%
NDLC=2;
%Determines how the Floquet blocks are rounded
MODE=2;
%**************************************************************************
%                                 CONTROLS
%**************************************************************************

%**************************************************************************
%                           Universal Constants
%**************************************************************************
hbar=1.054571628e-34;
q=1.602176487e-19;

%*******************
%Assigning the input
%*******************
NS=H_PARA{2}{1}(ss);
NB_MAX=H_PARA{3}{1}(ss);
NBS_MAX=H_PARA{3}{2}(ss);

nu_o=F_PARA{5};

%************************************
%Energy of photon with frequency nu_o
%************************************
FE=2*pi*hbar*nu_o/q;

%*******************************
%Calling the maximum value of NB 
%*******************************
[~,~,NB_CEIL]=NB_Round(MODE,NB_MAX);
NBS_CEIL=NS*(2*NB_CEIL+1);

%**************************************************************
%Removing the shw terms from the diagonal of the Floquet matrix
%**************************************************************
for jj=1:2*NB_MAX+1
    N1=1+NS*(jj-1);
    N2=NS*jj;
    N3=-NB_MAX+(jj-1);
    FH(N1:N2,N1:N2)=FH(N1:N2,N1:N2)+eye(NS)*N3*FE;
end

%***********************************************
%Calc. the estimated naturally grouped frequency
%***********************************************
[~,~,EV_del_max]=Floquet_Blocks(ss,H,H_PARA,F_PARA);
nu_NG=M_NG(1)*EV_del_max*q/(2*pi*hbar);

if (nu_o>=nu_NG)
    EV_track=0;
    IND_track(1:NS)=NS*NB_MAX+1:NS*NB_MAX+NS;
    NB_track=NB_MAX;
    
    return
end

%**********************************************************
%Calc. the EVs at the estimated naturally grouped frequency
%**********************************************************
NB_NG=EV_del_max/(FE*nu_NG/nu_o);
[NB_NG,~,~]=NB_Round(MODE,NB_NG);
NBS_NG=NS*(2*NB_NG+1);

N1=NS*(NB_MAX-NB_NG)+1;
N2=NBS_MAX-NS*(NB_MAX-NB_NG);
FH_temp=FH(N1:N2,N1:N2);
for jj=1:2*NB_NG+1
    N1=1+NS*(jj-1);
    N2=NS*jj;
    N3=-NB_NG+(jj-1);
    FH_temp(N1:N2,N1:N2)=FH_temp(N1:N2,N1:N2)-eye(NS)*N3*FE*nu_NG/nu_o;
end

EV_temp(1:NBS_NG)=eig(FH_temp);

EV_NG(1:NS)=EV_temp(NS*NB_NG+1:NS*(NB_NG+1));
EV_NG_del_max=EV_NG(NS)-EV_NG(1);

%*******************************************
%Calc. the exact naturally grouped frequency
%*******************************************
nu_NG=M_NG(2)*EV_NG_del_max*q/(2*pi*hbar);

if (nu_o>=nu_NG)
    EV_track=0;
    IND_track(1:NS)=NS*NB_MAX+1:NS*NB_MAX+NS;
    NB_track=NB_MAX;
    
    return
end

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%                        EVs INDEPENDENT OF FREQUENCY
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

if (TRACKER==2)
    %*********************
    %Calc. the EVs at nu_o
    %*********************
    FH_temp=FH;
    for jj=1:2*NB_MAX+1
        N1=1+NS*(jj-1);
        N2=NS*jj;
        N3=-NB_MAX+(jj-1);
        FH_temp(N1:N2,N1:N2)=FH_temp(N1:N2,N1:N2)-eye(NS)*N3*FE;
    end

    E_temp(1:NBS_MAX)=eig(FH_temp);
    clear FH_temp
    
    %*****************************************
    %Calc. the indicies of the EVs of interest
    %*****************************************
    hit(1:NBS_MAX)=0;
    EV_del(1:NS,1:NBS_MAX)=0;
    IND_min(1:NS)=0;
    for jj=1:NS       
        for kk=1:NBS_MAX
            EV_del(jj,kk)=abs(EV_NG(jj)-E_temp(kk));
        end    

        for kk=1:NBS_MAX
            if (hit(kk)==0)
                temp=EV_del(jj,kk);
                mm=kk;
                break
            end
        end

        for ww=1:NBS_MAX
            if (hit(ww)==0)
                if (temp>EV_del(jj,ww))
                    temp=EV_del(jj,ww);
                    mm=ww;
                end
            end
        end
        IND_min(jj)=mm;
        hit(mm)=1;       
    end
    
    %********************
    %Assigning the output
    %********************
    EV_track=E_temp;
    IND_track(1:NS)=IND_min(1:NS);
    NB_track=NB_MAX;
      
    return
end

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%                     EVs NOT INDEPENDENT OF FREQUENCY
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%*************************************
%Determining the degeneracy of the EVs
%*************************************
ll=0;
HIT_S(1:NS)=0;
DEG(1:NS)=0;
NS_DEG(1:NS)=0;
for jj=1:NS
    if (HIT_S(jj)==0)
        ll=ll+1;
    end
    
    for kk=1:NS
        if (abs(EV_NG(jj)-EV_NG(kk))<=abs(EV_NG(jj))*eps_DEG)
            DEG(jj)=DEG(jj)+1;
            
            if (HIT_S(kk)==0)
                NS_DEG(kk)=ll;
                
                HIT_S(kk)=1;
            end
        end
    end
end
DEG_max=max(DEG);

%*********************************
%Calc. the inital order of the EVs
%*********************************
EV_IO(1:NS,1:NS)=0;
for jj=1:NS
    for kk=1:jj-1
        if (NS_DEG(jj)~=NS_DEG(kk))
            if (EV_NG(jj)-EV_NG(kk)>0)
                EV_IO(jj,kk)=1;
            elseif (EV_NG(jj)-EV_NG(kk)<0)
                EV_IO(jj,kk)=-1;
            end
        end
    end
end

%***************************************
%Determining the number of EVs to search 
%***************************************
NSEV=DEG+NSEV*DEG_max;
for ii=1:NS
    if (NSEV(ii)>NS)
        NSEV(ii)=NS;
    end
end
NSEV_max=2*max(NSEV)+1;

%*******************************************
%Allocating memory to the tracking variables 
%*******************************************
TI=0;

EV_PL(1:NS,1:TI_max,1:ND)=0;
EV_PO(1:NS,1:TI_max)=1;
EV_POM(1:TI_max)=ND+1;

EV_SO(1:NS,1:TI_max)=0;
EV_SL(1:2,1:TI_max)=0;

EV_LC(1:NS,1:NS)=0;

EV_DM(1:NS,1:TI_max)=0;

M_TI(1:TI_max)=0;
M_TI(1:ND+2)=M_IN;

NB(1:TI_max)=0;
NBS(1:TI_max)=0;

nu(1:TI_max,1:ND)=0;
EV(1:NS,1:TI_max,1:ND)=0;
EV_FULL(1:NBS_CEIL,1:TI_max)=0;
EV_IND(1:NS,1:TI_max)=0;

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%                CALC. ND+2 'NATURALLY SEPERATED' SETS OF EVs
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%*****************
%Calc. frequencies
%*****************
nu(ND+2,1)=nu_NG;
for ii=1:ND+1
    nu(ND+2-ii,1)=nu(ND+2-ii+1,1)+nu(ND+2,1)*M_IN;
end

%*********
%Calc. EVs
%*********
for ii=1:ND+2
    TI=TI+1;
    
    NB(TI)=EV_del_max/(FE*nu(TI,1)/nu_o);
    [NB(TI),~,~]=NB_Round(MODE,NB(TI));
    NBS(TI)=NS*(2*NB(TI)+1);
    
    N1=NS*(NB_MAX-NB(TI))+1;
    N2=NBS_MAX-NS*(NB_MAX-NB(TI));
    FH_temp=FH(N1:N2,N1:N2);
    for jj=1:2*NB(TI)+1
        N1=1+NS*(jj-1);
        N2=NS*jj;
        N3=-NB(TI)+(jj-1);
        FH_temp(N1:N2,N1:N2)=FH_temp(N1:N2,N1:N2)-eye(NS)*N3*FE*nu(TI,1)/nu_o;
    end

    EV_FULL(1:NBS(TI),TI)=eig(FH_temp);
    clear FH_temp
    
    EV_IND(1:NS,TI)=NS*NB(TI)+1:NS*(NB(TI)+1);
    EV(1:NS,TI,1)=EV_FULL(NS*NB(TI)+1:NS*(NB(TI)+1),TI);
end

%*****************
%Calc. derivatives 
%*****************
for ii=1:NS
    for jj=1:ND
        for kk=TI:-1:jj+1
            EV(ii,kk,jj+1)=(EV(ii,kk,jj)-EV(ii,kk-1,jj))/(nu(kk,jj)-nu(kk-1,jj));
            if (ii==1)
                nu(kk,jj+1)=(nu(kk,jj)+nu(kk-1,jj))/2;
            end
        end
    end
end

%**************************
%Calc. order of EV tracking
%************************** 
HIT_S(1:NS)=0;
for ii=1:NS
    for jj=1:NS
        if (HIT_S(jj)==0)
            MIN=abs(EV(jj,TI,3));
            kk=jj;
            break
        end
    end
    
    for jj=1:NS
        if (HIT_S(jj)==0) && (MIN>abs(EV(jj,TI,3)))
            MIN=abs(EV(jj,TI,3));
            kk=jj;
        end
    end
    HIT_S(kk)=1;
    EV_SO(kk,TI+1)=ii;
end

%*******************
%Set predictor logic
%*******************
for ii=1:NS
    for jj=1:ND
        for kk=jj+1:TI
            if (abs(EV(ii,kk,jj+1))<eps_EV_PL(jj,1)) || (abs(EV(ii,kk,jj+1)-EV(ii,kk-1,jj+1))<eps_EV_PL(jj,2))
                EV_PL(ii,kk,jj)=1;
            end
        end
    end
   
    for jj=1:ND
        if (EV_PL(ii,TI,jj)==0) && (EV_PL(ii,TI-1,jj)==0)
            EV_PO(ii,TI)=1+jj;
        else
            break
        end
    end
end

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%                             FIRST TRACKING STEP
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   

%*****************
%Calc. frequencies
%*****************
nu(TI+1,1)=nu(TI,1)*(1-M_TI(TI));
if (nu(TI+1,1)<nu_o)
    nu(TI+1,1)=nu_o;
end

for ii=1:ND
    nu(TI+1,ii+1)=(nu(TI+1,ii)+nu(TI,ii))/2;
end

%********
%Calc. NB 
%********
NB(TI+1)=EV_del_max/(FE*nu(TI+1,1)/nu_o);
[NB(TI+1),~,~]=NB_Round(MODE,NB(TI+1));
NBS(TI+1)=NS*(2*NB(TI+1)+1);
        
%**********************
%Linearly extrapolating
%**********************
EV_P(1:NS,1:ND+1)=0;
for ii=1:NS
    for jj=1:EV_PO(ii,TI)
        T1=TI-1;
        T2=TI;
        T3=TI+1;
        EV_P(ii,jj)=Lin_Extrap(nu(T3,jj),nu(T1:T2,jj),EV(ii,T1:T2,jj));
    end
end

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%                               TRACKING LOOP
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

TI_NB=0;
TI_HOLD=0;
FAIL=0;
PASS=0;

IND_T1(1:NS,1:NSEV_max)=0;
IND_T2(1:2)=0;

NLS(1:NS)=0;
NUS(1:NS)=0;

EV_T(1:NS,1:NSEV_max)=0;
EV_D(1:NS,1:NSEV_max+2*NPLC+1)=0;
EV_R(1:NS,1:2*NPLC+1)=0;

HIT_G(1:NBS_CEIL)=0;
HIT_S(1:NBS_CEIL)=0;

nu_ST(1:NBS_CEIL,1:ND+1)=0;
EV_ST(1:NS,1:NBS_CEIL,1:ND+1)=0;
NPST=floor((ND+2)/2);

for ii=1:TI_max-TI      
            
    fprintf('TI: %4i -- NB: %5i -- nu: %12.8f -- PO: %2i\n',TI+1,NB(TI+1),nu(TI+1,1)/1e9,EV_POM(TI))
   
    if (PASS==0)
        %*********
        %Calc. EVs
        %********* 
        N1=NS*(NB_MAX-NB(TI+1))+1;
        N2=NBS_MAX-NS*(NB_MAX-NB(TI+1));

        FE_T=FE*nu(TI+1,1)/nu_o;
        
        FH_temp=FH(N1:N2,N1:N2);
        for jj=1:2*NB(TI+1)+1
            N1=1+NS*(jj-1);
            N2=NS*jj;
            N3=-NB(TI+1)+(jj-1);
            FH_temp(N1:N2,N1:N2)=FH_temp(N1:N2,N1:N2)-eye(NS)*N3*FE_T;
        end

        EV_FULL(1:NBS(TI+1),TI+1)=eig(FH_temp);
        
        for jj=1:NS
            %***************************************************
            %Calc. the derivatives for the selected range of EVs
            %***************************************************            
            for kk=1:2*NSEV(jj)+1
                for ll=1:EV_PO(jj,TI)            
                    if (ll==1)
                        IND_T1(jj,kk)=NS*(NB(TI+1)-NB(TI))+EV_IND(jj,TI)-NSEV(jj)+(kk-1);
                        EV_T(jj,kk)=EV_FULL(IND_T1(jj,kk),TI+1);
                    else
                        EV_T(jj,kk)=(EV_T(jj,kk)-EV(jj,TI,ll-1))/(nu(TI+1,ll-1)-nu(TI,ll-1)); 
                    end
                end
                EV_D(jj,kk)=abs((EV_T(jj,kk)-EV_P(jj,ll))/EV_P(jj,ll));
            end
            
            %**************************
            %Calc. the EV search limits 
            %**************************           
            if (jj==1)
                MIN=IND_T1(jj,1);
                MAX=IND_T1(jj,2*NSEV(jj)+1);
            else
                if (IND_T1(jj,1)<MIN)
                    MIN=IND_T1(jj,1);
                end

                if (IND_T1(jj,2*NSEV(jj)+1)>MAX)
                    MAX=IND_T1(jj,2*NSEV(jj)+1);
                end
            end
        end
        EV_SL(1,TI+1)=MIN;
        EV_SL(2,TI+1)=MAX;
        
        %*********************************
        %Calc. the number of redundant EVs 
        %*********************************         
        for jj=1:NS
            NLS(jj)=floor((EV_P(jj,1)-EV_FULL(jj,MIN))/FE_T);
            NUS(jj)=floor((EV_FULL(jj,MAX)-EV_P(jj,1))/FE_T);
        end
                   
        HIT_G(1:NBS(TI+1))=0;    
        for jj=1:NS        
            kk=EV_SO(jj,TI+1);
            
            %*****************
            %Selecting the EVs 
            %*****************
            for ll=1:2*NSEV(kk)+1
                if (HIT_G(IND_T1(kk,ll))==0)
                    MIN=EV_D(kk,ll);
                    mm=ll;
                    break
                end
            end

            for ll=1:2*NSEV(kk)+1
                if (HIT_G(IND_T1(kk,ll))==0)
                    if (MIN>EV_D(kk,ll))
                        MIN=EV_D(kk,ll);
                        mm=ll;
                    end
                end
            end                
            HIT_G(IND_T1(kk,mm))=1;
                                   
            %********************
            %Checking degenerency
            %********************
            if (TI>TI_HOLD)
                SUM=0;
                
                N1=IND_T1(kk,mm);
                N2=IND_T1(kk,mm)-DEG(kk);
                N3=IND_T1(kk,mm)+DEG(kk);
                for ll=N2:N3
                    if (abs(EV_FULL(ll,TI+1)-EV_FULL(N1,TI+1))<abs(EV_FULL(N1,TI+1))*eps_DEG)
                        SUM=SUM+1;
                    end
                end
                
                if (SUM~=DEG(kk))
                    FAIL=1;
                    break
                end
            end
            
            %**********************
            %Removing redundant EVs
            %**********************
            N1=EV_SL(1,TI+1);
            N2=EV_SL(2,TI+1);
            for ll=1:NLS(kk)+NUS(kk)
                N3=-NLS(kk)+ll-1;
                if (N3==0)
                    N1=IND_T1(kk,mm)+1;
                    N3=N3+1;
                elseif (N3>0)
                    N3=N3+1;
                end

                for nn=N1:N2
                    if (HIT_G(nn)==0) && abs((EV_FULL(nn,TI+1)-EV_FULL(IND_T1(kk,mm),TI+1))/FE_T-N3)<eps_EV
                        HIT_G(nn)=1;
                        N1=nn+1;
                        break
                    end
                end
            end
            
            %**********************
            %Saving predictor error
            %**********************            
            SUM=0;
            for ll=1:2*NSEV(kk)+1
                if (HIT_G(IND_T1(kk,ll))==1)
                    SUM=SUM+1;
                end
            end
            
            if (SUM==2*NSEV(kk))
                EV_DM(kk,TI+1)=0;
            else
                EV_DM(kk,TI+1)=EV_D(kk,mm);
            end
            
            %*****************
            %Saving EVs indice
            %*****************
            EV_IND(kk,TI+1)=IND_T1(kk,mm);                       
        end
    
        if (FAIL==0)
            %*************************
            %Tracking step conditional
            %*************************
            for jj=1:NS
                if (EV_DM(jj,TI+1)>eps_EV_DM(EV_PO(jj,TI))) && (EV_POM(TI)>1)
                    FAIL=1;
                    break
                end
            end
           
            if (FAIL==0)
                for jj=1:NS            
                    %********************
                    %Calc. EV derivatives 
                    %******************** 
                    EV(jj,TI+1,1)=EV_FULL(EV_IND(jj,TI+1),TI+1);                
                    for kk=1:ND
                        EV(jj,TI+1,kk+1)=(EV(jj,TI+1,kk)-EV(jj,TI,kk))/(nu(TI+1,kk)-nu(TI,kk));
                    end
                end
            end
            
            %*************************
            %Tracking step conditional
            %*************************
            if (TI_HOLD>TI) 
                if (FAIL==1)                    
                    PASS=0;
                    FAIL=0;
                    
                    for jj=1:NS
                        if (EV_DM(jj,TI+1)>eps_EV_DM(EV_PO(jj,TI))) 
                            if (EV_PO(jj,TI)>1)                              
%                                 N1=TI;
%                                 N2=TI-1;
%                                 N3=TI-2;
%                                 N4=TI-3;
% 
%                                 T1=(EV(jj,N1,EV_PO(jj,TI))-EV(jj,N2,EV_PO(jj,TI)))*(EV(jj,N3,EV_PO(jj,TI))-EV(jj,N4,EV_PO(jj,TI)));
%                                 T2=(EV(jj,N1,EV_PO(jj,TI))-EV(jj,N2,EV_PO(jj,TI)))*(EV(jj,N2,EV_PO(jj,TI))-EV(jj,N3,EV_PO(jj,TI)));
%                                 if (T1>=0) && (T2<=0)
                                     EV_PO(jj,TI)=EV_PO(jj,TI)-1;
%                                 else
%                                     FAIL=1;
%                                     break
%                                 end
                            else
                                FAIL=1;
                                break
                            end
                        end
                    end
                    
                    if (FAIL==0)
                        TI=TI-1;    
                    end
                else
                    PASS=1;
                end
            end                       
        end
    else
        %***********************
        %Updating EV derivatives 
        %***********************
        for jj=1:NS
            for kk=1:ND
                EV(jj,TI+1,kk+1)=(EV(jj,TI+1,kk)-EV(jj,TI,kk))/(nu(TI+1,kk)-nu(TI,kk));
            end
        end
        
        PASS=0;
    end
    
    if (FAIL==0)
        TI=TI+1;
                      
        if (TI>=TI_HOLD)
            
            if (TI>TI_HOLD)
                M_TI(TI)=(1-nu(TI,1)/nu(TI-1,1))*1.05;
            else
                M_TI(TI)=(1-nu(TI,1)/nu(TI-1,1));
            end            
            
            %*********************
            %Exiting tracking loop 
            %*********************
            if (nu(TI,1)==nu_o)
                break
            end            
                       
            %***************
            %Calc. frequency 
            %***************
            nu(TI+1,1)=nu(TI,1)*(1-M_TI(TI));    
            if (nu(TI+1,1)<nu_o)
                nu(TI+1,1)=nu_o;
            end
            for jj=1:ND
                nu(TI+1,jj+1)=(nu(TI+1,jj)+nu(TI,jj))/2;
            end

            %******************************
            %Calc. number of Floquet blocks
            %******************************
            NB(TI+1)=EV_del_max/(FE*nu(TI+1,1)/nu_o);
            [NB(TI+1),~,~]=NB_Round(MODE,NB(TI+1));
            NBS(TI+1)=NS*(2*NB(TI+1)+1);
            
            if (NB(TI+1)~=NB(TI)) 
                TI_NB=TI+1;
            end
                
            HIT_S(1:NS)=0;
            for jj=1:NS
                %***************************
                %Calc. the EV tracking order
                %***************************                
                for kk=1:NS
                    if (HIT_S(kk)==0)
                        MIN=abs(EV(kk,TI,3));
                        ll=kk;
                        break
                    end
                end

                for kk=1:NS
                    if (HIT_S(kk)==0) && (abs(EV(kk,TI,3))<MIN)
                        MIN=abs(EV(jj,TI,3));
                        ll=kk;
                    end
                end
                HIT_S(ll)=1;
                EV_SO(ll,TI+1)=jj;
                
                %***********************
                %Setting predictor logic
                %***********************
                EV_PO(jj,TI)=1;
                for kk=1:ND
                    if (abs(EV(jj,TI,kk+1))<eps_EV_PL(kk,1)) || (abs(EV(jj,TI,kk+1)-EV(jj,TI-1,kk+1))<eps_EV_PL(kk,2))
                        EV_PL(jj,TI,kk)=1;
                    end

                    if (EV_PL(jj,TI,kk)==0) && (EV_PL(jj,TI-1,kk)==0)
                        EV_PO(jj,TI)=1+kk;
                    else
                        EV_PL(jj,TI,kk+1:ND)=1;
                        break
                    end
                end

                %**********************
                %Linearly extrapolating
                %**********************
                for kk=1:EV_PO(jj,TI)
                    EV_P(jj,kk)=Lin_Extrap(nu(TI+1,kk),nu(TI-1:TI,kk),EV(jj,TI-1:TI,kk));
                end        
            end
        elseif (PASS==0)
            %************************************
            %Linearly extrapolating
            %**********************
            for jj=1:NS
                for kk=1:EV_PO(jj,TI)
                    EV_P(jj,kk)=Lin_Extrap(nu(TI+1,kk),nu(TI-1:TI,kk),EV(jj,TI-1:TI,kk));
                end
            end
        end
    else
        %***********************************
        %Multiplier for consecitive failures
        %***********************************
        if (TI<=TI_HOLD)
            FAIL_CT=FAIL_CT+1;
        else
            FAIL_CT=1;
        end
        
        %******************************************
        %Decreasing frequency step size by one half
        %******************************************  
        kk=0;
        ll=0;
        
        N1=NPST*FAIL_CT;
        N2=TI-NPST*FAIL_CT;
        N3=TI+NPST*FAIL_CT;
                
        nu_ST(1:N1+1,1:ND+1)=nu(N2:TI,1:ND+1);
        EV_ST(1:NS,1:N1+1,1:ND+1)=EV(1:NS,N2:TI,1:ND+1);
        for jj=N3:-1:N2
            NB(jj)=NB(TI-ll);
            NBS(jj)=NBS(TI-ll);

            EV_PL(1:NS,jj,1:ND)=EV_PL(1:NS,TI-ll,1:ND);
            EV_PO(1:NS,jj)=EV_PO(1:NS,TI-ll);
            EV_SO(1:NS,jj)=EV_SO(1:NS,TI-ll);
            
            if (kk==0)               
                nu(jj,1)=nu(TI-ll,1);
                
                EV(1:NS,jj,1)=EV(1:NS,TI-ll,1);
                EV_IND(1:NS,jj)=EV_IND(1:NS,TI-ll);
                EV_FULL(1:NBS(TI-ll),jj)=EV_FULL(1:NBS(TI-ll),TI-ll);
                
                EV_DM(1:NS,jj)=EV_DM(1:NS,TI-ll);
                
                if (TI_NB==TI-ll)
                    TI_NB=jj;
                end
                
                kk=1;
                ll=ll+1;
            elseif (kk==1)           
                nu(jj,1)=(nu(TI-ll,1)+nu(TI-ll+1,1))/2;                
                          
                kk=0;              
            end
        end

        for jj=1:ND
            for kk=N2:N3
                nu(kk,jj+1)=(nu(kk,jj)+nu(kk-1,jj))/2;
            end
        end          

        TI=TI-N1-1;
        
        PASS=1;
        TI_HOLD=TI+2*N1+1;
    end
        
    if (FAIL==0)
        %**************************************
        %Limiting predictor logic if NB changes
        %**************************************
        if (TI_NB==TI+1) 
            EV_POM(TI)=0;
            EV_PO(1:NS,TI)=1;
        elseif (EV_POM(TI-1)<ND+1)
            EV_POM(TI)=EV_POM(TI-1);

            for jj=1:NS
                if (EV_POM(TI)==0)
                    EV_PO(1:NS,TI)=1;
                    break
                elseif (EV_POM(TI)<EV_PO(jj,TI))
                    EV_PO(jj,TI)=EV_POM(TI);
                end
            end

            EV_POM(TI)=EV_POM(TI)+1;
        end
        
        %***********************************************
        %Limiting predictor logic if derivative is noisy
        %***********************************************
        for jj=1:NS
            oo=0;
            for kk=1:ND
                N1=kk+1;
                for ll=1:NPDN
                    mm=ll-1;
                    if (TI-4-mm>0)
                        N2=TI-mm;
                        N3=TI-1-mm;
                        N4=TI-2-mm;
                        N5=TI-3-mm;

                        T1=(EV(jj,N2,N1)-EV(jj,N3,N1))*(EV(jj,N4,N1)-EV(jj,N5,N1));
                        T2=(EV(jj,N2,N1)-EV(jj,N3,N1))*(EV(jj,N4,N1)-EV(jj,N5,N1));
                        if (T1>=0) && (T2<=0)
                            if (EV_PO(jj,TI)>kk)
                                for nn=1:3
                                    N6=TI-nn-mm-1;
                                    N7=TI-nn-mm;
                                    N8=TI-nn-mm+1;
                                    
                                    T3=Lin_Extrap(nu(N8,N1),nu(N6:N7,N1),EV(jj,N6:N7,N1));
                                    T4=abs((T3-EV(jj,N8,N1))/T3);
                                    if (T4>eps_EV_DM_PO(kk)) 
                                        EV_PO(jj,TI)=kk;
                                        oo=1;
                                        break
                                    end
                                end
                                
                                if (oo==1)
                                    break
                                end
                            end
                        end
                    end
                end
                
                if (oo==1)
                    break
                end
            end
        end
        
        %***************************************
        %Calc. the interaction matrix - crossing
        %***************************************
        FE_T=FE*nu(TI,1)/nu_o;
        for jj=1:NS
            for kk=1:jj-1
                if (EV_LC(jj,kk)==0) && (NS_DEG(jj)~=NS_DEG(kk))
                    T1=EV(jj,TI,1)-EV(kk,TI,1);
                    if (EV_IO(jj,kk)==1)
                        if (T1<0)
                            EV_LC(jj,kk)=1;
                        elseif (T1>FE_T)
                            EV_LC(jj,kk)=1;
                        end
                    elseif (EV_IO(jj,kk)==-1)
                        if (T1>0)
                            EV_LC(jj,kk)=1;
                        elseif (-T1>FE_T)
                            EV_LC(jj,kk)=1;
                        end   
                    end
                    
                    if (EV_LC(jj,kk)==1)
                        for ll=1:NS
                            for mm=1:ll-1
                                if (NS_DEG(ll)~=NS_DEG(mm))
                                    if (jj==ll && NS_DEG(kk)==NS_DEG(mm)) || (kk==mm && NS_DEG(jj)==NS_DEG(ll)) || (NS_DEG(jj)==NS_DEG(ll) && NS_DEG(kk)==NS_DEG(mm))
                                        EV_LC(ll,mm)=1;
                                    end
                                end
                            end
                        end    
                    end
                end
            end
        end
        
        %*******************************************
        %Calc. the interaction matrix - anticrossing
        %*******************************************         
        N1=TI-NPLC-1;
        N2=TI-NPLC;
        N3=TI-NPLC+1;
        N4=TI-2*NPLC-1;

        N5=2*NPLC+1;
        N6=NDLC+1;

        HIT_S(1:NS)=0;
        for jj=1:NS
            for kk=TI:-1:TI-N5+1
                if (EV_PO(jj,kk)<N6)
                    HIT_S(jj)=1;
                    break
                end
            end

            if (HIT_S(jj)==0)
                T1=(EV(jj,N3,N6)-EV(jj,N2,N6))*(EV(jj,N2,N6)-EV(jj,N1,N6));
                if (T1<0)
                    for kk=1:NPLC
                       T1=abs(EV(jj,N4+kk,N6));
                       T2=abs(EV(jj,N4+kk+1,N6));
                       T3=abs(EV(jj,N1+kk,N6));
                       T4=abs(EV(jj,N1+kk+1,N6));
                       if (T2<=T1) || (T4>=T3)
                           HIT_S(jj)=1;
                           break
                       end
                    end
                else
                    HIT_S(jj)=1;
                end
            end
        end
        
        for jj=1:NS
            if (HIT_S(jj)==0)
                for kk=1:jj-1
                    if (HIT_S(kk)==0) && (EV_LC(jj,kk)==0) && (NS_DEG(jj)~=NS_DEG(kk))
                        mm=0;
                        AVG=0;
                        for ll=1:N5;
                            EV_R(ll)=EV(jj,N4+ll,N6)/EV(kk,N4+ll,N6);
                            if (EV_R(ll)<0)
                                AVG=AVG+EV_R(ll)/N5;
                            else
                                AVG=0;
                                break
                            end
                        end

                        if (AVG<0)
                            for ll=1:N5;
                                if (abs((EV_R(ll)-AVG)/AVG)>eps_LC)
                                    mm=1;
                                    break
                                end
                            end

                            if (mm==0)
                                EV_LC(jj,kk)=2;
                            end
                        end
                        
                        if (EV_LC(jj,kk)==2)
                            for ll=1:NS
                                for mm=1:ll-1
                                    if (NS_DEG(ll)~=NS_DEG(mm))
                                        if (jj==ll && NS_DEG(kk)==NS_DEG(mm)) || (kk==mm && NS_DEG(jj)==NS_DEG(ll)) || (NS_DEG(jj)==NS_DEG(ll) && NS_DEG(kk)==NS_DEG(mm))
                                            EV_LC(ll,mm)=2;
                                            %fprintf('freq=%5.3f - ll %2i - mm %2i\n',nu(N2,1)/1e9,ll,mm)
                                        end
                                    end
                                end
                            end    
                        end
                    end
                end
            end
        end
    else
        FAIL=0;
    end
end

temp2(1:TI)=0;
temp3(1:TI)=0;
temp4(1:TI)=0;
temp5(1:TI)=0;
for ii=1:NS
    temp1(1:TI)=EV(ii,1:TI,3);
    temp2(1:TI)=temp2+temp1;
    temp3(1:TI)=temp3+abs(temp1);
end
temp2=log10(abs(temp2));
temp3=log10(temp3);

for ii=1:TI
    jj=ii-5;
    if jj<=0
        jj=1;
    end
    temp4(ii)=sum(temp2(jj:ii))/6;
    temp5(ii)=sum(temp3(jj:ii))/6;
end

figure
hold on
plot(nu(1:TI,1)/1e9,temp2,'-k','LineWidth',2)
plot(nu(1:TI,1)/1e9,temp4,'-r','LineWidth',2)
hold off

figure
hold on
plot(nu(1:TI,1)/1e9,temp3,'-k','LineWidth',2)
plot(nu(1:TI,1)/1e9,temp5,'-r','LineWidth',2)
hold off

%******
%Output
%******
EV_track(1:NBS(TI))=EV_FULL(1:NBS(TI),TI);
IND_track(1:NS)=EV_IND(1:NS,TI);    
NB_track=NB(TI);

DATA{1}=nu;
DATA{2}={EV,EV_FULL,EV_IND};
DATA{3}={EV_PO,EV_DM,EV_LC};
DATA{4}={ND,NB,NBS,TI,M_TI,DEG,NS_DEG};

FH_EVal_Plot(DATA,ss,H_PARA,F_PARA,FH)
end
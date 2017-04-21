function [Phi,E]=FH_EV_EV_Solver(ss,FH,H,Ho,H_PARA,F_PARA)

%**************************************************************************
%Sorting the eigenvalue/eigenvector pairs into 2*NB+1 sets and selecting
%one of those sets to output.
%**************************************************************************
print_group=0;
print_check=0;
print_sort=1;
eig_plot=1;

%**************************************************************************
%                           Universal Constants
%**************************************************************************
hbar=1.054571628e-34;
q=1.602176487e-19;
%
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
%**************************************************************************
%Setting the convergence criteria to find 'same set' solutions 
%**************************************************************************
eps1=1e-6;
eps2=1e-6;
eps3=1e-6;


%*******************
%Assigning the input
%*******************
NS=H_PARA{2}{1}(ss);
NB=H_PARA{3}{1}(ss);
NBS=H_PARA{3}{2}(ss);

nu=F_PARA{5};

%************************************
%Energy of photon with frequency nu_o
%************************************
FE=2*pi*hbar*nu/q;

%**********************************
%Calc. the eigenvalues/eigenvectors
%**********************************
[EVec,EVal]=eig(FH);

%***********************************************
%Calc. the estimated naturally grouped frequency
%***********************************************
[~,~,dEV]=Floquet_Blocks(ss,H,H_PARA,F_PARA);
nu_NG=M_NG(1)*dEV*q/(2*pi*hbar);

if (nu>=nu_NG)
    E(1:NS)=0;
    Phi(1:NBS,1:NS)=0;
    for ii=1:NS
        jj=NS*NB+ii;
        E(ii)=EVal(jj)+Ho(ii,ii,ss);
        Phi(1:NBS,ii)=EVec(1:NBS,jj);
    end
    
    return
end

%**************************************************************************
%Sorting the eigenvalues that have the same eigenvalues +/- nhw where n
%spans from 0 to NB
%**************************************************************************
kk=0;
hit(1:CN)=0;
EVG1(1:CN,1:CN)=0;
N1(1:CN)=0;
for ll=1:CN
    if (hit(ll)==0)
        zz=0;
        kk=kk+1;
        for jj=1:CN
            if (hit(jj)==0)
                for mm=-NB:1:NB

                    dE=E(jj)-E(ll);
                    if (abs(dE-mm*FE)/FE<eps1)
                        zz=zz+1;
                        EVG1(kk,zz)=jj;
                        N1(kk)=zz;                     
                        hit(jj)=1;
                        break
                    end

                end
            end
        end
    end
end
NG1=kk;

if (NG1>NS)
    
    fprintf('********************************WARNING****************************************\n')
    fprintf('Truncation error to large need to increase the number of Floquet Blocks\n')
    fprintf('********************************WARNING****************************************\n\n')
    
elseif (NG1==NS)
    
    EVG=EVG1(1:NG1,1:max(N1));
    NG=N1(1:NG1);
    
elseif (NG1<NS)
    
    clear hit
    hit(1:max(N1))=0;
    EVG2(1:NG1,1:CN,1:CN)=0;
    N2(1:NG1,1:CN)=0;
    N3(1:NG1)=0;
    for ll=1:NG1
        hit(1:max(N1))=0;
        kk=0;
        for ii=1:N1(ll)
            if (hit(ii)==0)
                zz=0;
                kk=kk+1;
                for jj=1:N1(ll)
                    if (hit(jj)==0)

                        dE=E(EVG1(ll,jj))-E(EVG1(ll,ii));
                        if (abs(dE/FE)<eps2)
                            zz=zz+1;
                            EVG2(ll,kk,zz)=EVG1(ll,jj);
                            N2(ll,kk)=zz;
                            N3(ll)=kk;
                            hit(jj)=1;
                        end

                    end
                end
            end
        end
    end
    
    MX(1:NG1)=0;
    IMX(1:NG1)=0;
    for ll=1:NG1
        [MX(ll) IMX(ll)]=max(N2(ll,:));
    end
    
    kk=0;
    EVG3(1:NS)=0;
    for ll=1:NG1
        for jj=1:MX(ll)
            kk=kk+1;
            EVG3(kk)=EVG2(ll,IMX(ll),jj);
        end
    end
    NG2=kk;
    if (NG2>NS) || (NG2<NS)
        fprintf('********************************WARNING****************************************\n')
        fprintf('Truncation error to large need to increase the number of Floquet Blocks\n')
        fprintf('********************************WARNING****************************************\n\n')
    end
    
    
    DP(1:max(MX))=0;
    ERR(1:max(MX))=0;
    EVG4(1:NG2,1:CN)=0;
    N4(1:NG2)=0;
    for ll=1:NG1
        for kk=1:N3(ll)
            for zz=1:N2(ll,kk)
                DP(1:MX(ll))=0;
                ERR(1:MX(ll))=0;
                for jj=1:MX(ll)
                    
                    IN1=sum(MX(1:ll))-(MX(ll)-jj);
                    FBS=round((E(EVG2(ll,kk,zz))-E(EVG3(IN1)))/FE);                  
                    if (FBS==0)
                        DP(jj)=real(Phi(1:NS*(2*NB+1),EVG3(IN1))'*Phi(1:NS*(2*NB+1),EVG2(ll,kk,zz)));
                    elseif (FBS>0)
                        DP(jj)=real(Phi(FBS*NS+1:NS*(2*NB+1),EVG3(IN1))'*Phi(1:NS*(2*NB+1-FBS),EVG2(ll,kk,zz)));
                    elseif (FBS<0)
                        DP(jj)=real(Phi(1:NS*(2*NB+1-abs(FBS)),EVG3(IN1))'*Phi(abs(FBS)*NS+1:NS*(2*NB+1),EVG2(ll,kk,zz)));
                    end
                    ERR(jj)=abs(abs(DP(jj))-1)/1;
                
                end
                [MI IMI]=min(ERR);
                IN2=sum(MX(1:ll))-(MX(ll)-IMI);
                N4(IN2)=N4(IN2)+1;
                EVG4(IN2,N4(IN2))=EVG2(ll,kk,zz);
                
                if (print_group==1)
                    fprintf('****************************************\n')
                    fprintf('%10.6f\n\n',MI)
                    for jj=1:MX(ll)
                        fprintf('%10.6f \n',ERR(jj))
                    end
                    fprintf('***************************************\n\n')
                end
            end
        end
    end
    EVG=EVG4(1:NG2,1:max(N4));
    NG=N4(1:NG2);

end
clear EVG1 EVG2 EVG3 EVG4 N1 N2 N3 N4 hit ERR DP

%**************************************************************************
%Verifing the eigenvalues are sorted in ascending order in there individual
%groups
%**************************************************************************
ED(1:NS,2*NB+1)=0;
for ii=1:NS
    for jj=1:NG(ii)
        ED(ii,jj)=(E(EVG(ii,jj))-E(EVG(ii,1)))/FE;
    end
end

stop=0;
for ii=1:NS
    for jj=1:NG(ii)-1
        if(abs(ED(ii,jj+1)-ED(ii,jj)-1)>eps3)
            fprintf('**************************************************************************\n')
            fprintf('Eigenvalues are not sorted in ascending order\n')
            fprintf('**************************************************************************\n\n')
            print_check=1;
            stop=1;
            break
        end
    end
    if (stop==1)
        break
    end
end

for ii=1:NS
    if (abs(NG(ii)-NE1)>0)
        fprintf('*********************************************************************************\n')
        fprintf('Groups of similiar solutions do not contain the same amount of eigenvalues\n')
        fprintf('*********************************************************************************\n\n')
        print_check=1;
        stop=1;
    end
    if (stop==1)
        break
    end
end

if (print_check==1)
    fprintf('**********************************************************************************\n')
    for ii=1:NS
        for jj=1:NG(ii)
            fprintf('%12.8f  ',ED(ii,jj))
        end
        fprintf('\n')
    end
    fprintf('**********************************************************************************\n\n')
end

if (stop==0)
    ED=round(ED);
end

%**************************************************************************
%Putting sorted solutions into a matrix with dimensions NS x NE
%**************************************************************************
E_SORT(1:NS,1:NE1)=0;
COL_IN(1:NS,1:NE1)=0;
for jj=1:NE1
    for ii=1:NS
        E_SORT(ii,jj)=E(EVG(ii,jj));
        COL_IN(ii,jj)=ii;
    end
end

%**************************************************************************
%Listing sorted solutions into ascending order - array length NS*NE
%**************************************************************************
E_LIST(1:CN)=0;
COL_LIST(1:CN)=0;
hit(1:NS,1:CN)=0;
for zz=1:CN
    stop=0;
    for ii=1:NS
        for jj=1:NE1
            if (hit(ii,jj)==0)
                E_min=E_SORT(ii,jj);
                mm=ii;
                nn=jj;
                stop=1;
                break
            end
        end
        if (stop==1)
            break
        end
    end
    
    for ww=1:NS
        for yy=1:NE1
            if (hit(ww,yy)==0)
                if (E_min>E_SORT(ww,yy))
                    E_min=E_SORT(ww,yy);
                    mm=ww;
                    nn=yy;
                end
            end
        end
    end
    E_LIST(zz)=E_SORT(mm,nn);
    COL_LIST(zz)=COL_IN(mm,nn);
    hit(mm,nn)=1;
end
clear hit

%**************************************************************************
%Plotting sorted solutions
%**************************************************************************
if (eig_plot==1)
    shape={'o','o','o','o','o','o','d','d','d','d','d','d','s','s','s','s','s','s'};
    color={'k','r','b','m','c','y','k','r','b','m','c','y','k','r','b','m','c','y'};

    figure
    hold on
    for jj=1:NE1
        if (jj<=length(shape))
            plot(1:NS,E_SORT(1:NS,jj),shape{jj},'MarkerEdgeColor',color{jj},'MarkerFaceColor',color{jj})
        end
    end
    hold off

    figure
    hold on
    for kk=1:CN
        if (COL_LIST(kk)<=length(shape))
            scatter(kk,E_LIST(kk),60,'Marker',shape{COL_LIST(kk)},'MarkerEdgeColor',color{COL_LIST(kk)},'MarkerFaceColor',color{COL_LIST(kk)})
        end
    end
    hold off
end

%**************************************************************************
%Sorting the remaining eigenvalues in the the 'same solution' groups by
%directly comparing the eigenvalues.
%**************************************************************************
NU(1:LN)=0;
NG5(1:NS)=0;
kk=0;
for ii=1:NS
    for jj=1:NE2
        dE=(E_FULL(LN+CN+NS*(jj-1)+ii)-E_SORT(ii,NE1))/(jj*FE);
        if (abs(dE-1)<eps3)
            NG5(ii)=NG5(ii)+1;
            ED(ii,NE1+NG5(ii))=NE1-1+jj;
        else
            kk=kk+1;
            NU(kk)=LN+CN+NS*(jj-1)+ii;
        end
    end
end
NUT=kk;

NL(1:LN)=0;
NG6(1:NS)=0;
kk=0;
for ii=1:NS
    for jj=1:NE2
        dE=(E_SORT(ii,1)-E_FULL(LN-NS*jj+ii))/(jj*FE);
        if (abs(dE-1)<eps3)
            NG6(ii)=NG6(ii)+1;
            ED(ii,NE1+NG5(ii)+NG6(ii))=-jj;
        else
            kk=kk+1;
            NL(kk)=LN-NS*jj+ii;
        end
    end
end
NLT=kk;

%**************************************************************************
%Sorting the remaining eigenvalues in the the 'same solution' groups by
%miniminzing the differences in comparing eigenvalues and eigenvectors
%**************************************************************************
dEU(1:NS,1:NUT)=0;
for ii=1:NS
    for jj=1:NUT
        dE_temp=(E_FULL(NU(jj))-E_SORT(ii,NE1))/FE;
        dEU(ii,jj)=abs(dE_temp-round(dE_temp))/dE_temp;
    end
end

dEL(1:NS,1:NLT)=0;
for ii=1:NS
    for jj=1:NLT
        dE_temp=(E_SORT(ii,1)-E_FULL(NL(jj)))/FE;
        dEL(ii,jj)=abs(dE_temp-round(dE_temp))/dE_temp;
    end
end

NI=1;
SHI=0;

FBS(1:NE1)=0;
FBSU_temp(1:NI)=0;
FBSU(1:NS,1:NUT)=0;
DP_temp(1:NE1)=0;
DPU_temp(1:NI)=0;
DPU(1:NS,1:NUT)=0;
for ii=1:NS
    for jj=1:NUT
        
        DPU_temp(1:NI)=0;
        FBSU_temp(1:NI)=0;
        for ss=1:NI
            DP_temp(1:NE1)=0;
            dE(1:NE1)=0;
            for kk=1:NE1
                dE=round((E_FULL(NU(jj))-E_SORT(ii,kk))/FE)+SHI(ss);
                DP=real(Phi(dE*NS+1:NS*(2*NB+1),EVG(ii,kk))'*Phi_FULL(1:NS*(2*NB+1-dE),NU(jj)));
                DP_temp(kk)=abs(abs(DP)-1)/1;
                FBS(kk)=round((E_FULL(NU(jj))-E_SORT(ii,1))/FE)+SHI(ss);
            end
            
            ww=1;
            min_DP=DP_temp(1);
            for kk=1:NE1
                if (min_DP>DP_temp(kk))
                    min_DP=DP_temp(kk);
                    ww=ww+1;
                end
            end
            DPU_temp(ss)=min_DP;
            FBSU_temp(ss)=FBS(ww);
            
        end
        [DPU(ii,jj) ww]=min(DPU_temp);
        FBSU(ii,jj)=FBSU_temp(ww);
        
    end
end
clear FBS FBSU_temp DP_temp DPU_temp

FBS(1:NE1)=0;
FBSL_temp(1:NI)=0;
FBSL(1:NS,1:NUT)=0;
DP_temp(1:NE1)=0;
DPL_temp(1:NI)=0;
DPL(1:NS,1:NUT)=0;
for ii=1:NS
    for jj=1:NLT
        
        DPL_temp(1:NI)=0;
        FBSL_temp(1:NI)=0;
        for ss=1:NI
            DP_temp(1:NE1)=0;
            dE(1:NE1)=0;
            for kk=1:NE1
                dE=round((E_FULL(NL(jj))-E_SORT(ii,kk))/FE)+SHI(ss);
                DP=real(Phi(1:NS*(2*NB+1-abs(dE)),EVG(ii,kk))'*Phi_FULL(abs(dE)*NS+1:NS*(2*NB+1),NL(jj)));
                DP_temp(kk)=abs(abs(DP)-1)/1;
                FBS(kk)=round((E_FULL(NL(jj))-E_SORT(ii,1))/FE)+SHI(ss);
            end
            
            ww=1;
            min_DP=DP_temp(1);
            for kk=1:NE1
                if (min_DP>DP_temp(kk))
                    min_DP=DP_temp(kk);
                    ww=ww+1;
                end
            end
            DPL_temp(ss)=min_DP;
            FBSL_temp(ss)=FBS(ww);
            
        end
        [DPL(ii,jj) ww]=min(DPL_temp);
        FBSL(ii,jj)=FBSL_temp(ww);
        
    end
end
clear FBS FBSL_temp DP_temp DPL_temp

if (NI==1)
    ERRU=dEU+DPU;
    ERRL=dEL+DPL;
else
    ERRU=DPU;
    ERRL=DPL;
end

NG7(1:NS)=0;
ERRU_min(1:NUT)=0;
ERRU_ind(1:NUT)=0;
for jj=1:NUT
    [ERRU_min(jj) ERRU_ind(jj)]=min(ERRU(:,jj));
    NG7(ERRU_ind(jj))=NG7(ERRU_ind(jj))+1;
    ED(ERRU_ind(jj),NE1+NG5(ERRU_ind(jj))+NG6(ERRU_ind(jj))+NG7(ERRU_ind(jj)))=FBSU(ERRU_ind(jj),jj);
end

NG8(1:NS)=0;
ERRL_min(1:NLT)=0;
ERRL_ind(1:NLT)=0;
for jj=1:NLT
    [ERRL_min(jj) ERRL_ind(jj)]=min(ERRL(:,jj));
    NG8(ERRL_ind(jj))=NG8(ERRL_ind(jj))+1;
    ED(ERRL_ind(jj),NE1+NG5(ERRL_ind(jj))+NG6(ERRL_ind(jj))+NG7(ERRL_ind(jj))+NG8(ERRL_ind(jj)))=FBSL(ERRL_ind(jj),jj);
end



if (abs((2*NB+1)-length(ED(1,:)))>0)
    fprintf('************************************WARNING***************************************\n')
    fprintf('Eigenvalue/Eigenvector pairs not sorted corrected - truncation error to large,\n')
    fprintf('increasing the number of floquet blocks\n')
    fprintf('************************************WARNING***************************************\nn')
    print_sort=1;
end

if (print_sort==1)
    fprintf('**********************************************************************************\n')
    for ii=1:NS
        for jj=1:length(ED(1,:))
            fprintf('%3i  ',ED(ii,jj))
        end
        fprintf('\n')
    end
    fprintf('**********************************************************************************\n\n')
end


FE(1:NS)=0;
for ii=1:NS
    FE(ii)=sum(ED(ii,1:2*NB+1))/(2*NB+1);
end
FE'

end
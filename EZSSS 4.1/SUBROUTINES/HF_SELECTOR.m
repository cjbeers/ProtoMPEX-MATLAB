function FH_EVal_Selector(ss,FH,H,H_PARA,F_PARA)


M_NG=[1.05 1.03];

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

%**********************************************************
%Calc. the EVs at the estimated naturally grouped frequency
%**********************************************************
[~,~,dEV]=Floquet_Blocks(ss,H,H_PARA,F_PARA);
for ii=1:2
    nu_NG=M_NG(ii)*dEV*q/(2*pi*hbar);
    
    FH_temp=FH;
    for jj=1:2*NB+1
        N1=1+NS*(jj-1);
        N2=NS*jj;
        N3=-NB+(jj-1);
        FH_temp(N1:N2,N1:N2)=FH_temp(N1:N2,N1:N2)-eye(NS)*N3*FE*(nu_NG/nu-1);
    end

    EV=eig(FH_temp);

    EV_LIM(1)=EV(NS*NB+1);
    EV_LIM(2)=EV(NS*(NB+1));
    
    dEV=EV_LIM(2)-EV_LIM(1);
end

EV=eig(FH);

for ii=1:NBS
    if (EV(ii)>=EV_LIM(1))
        T1=ii;
        break
    end
end

for ii=NBS:-1:1
    if (EV(ii)<=EV_LIM(2))
        T2=ii;
        break
    end
end 

HIT_G(1:NBS)=0;
EV_S(1:NS,1:2*NB+1,1:NB)=0;
MP(1:NS,1:NB)=0;
for ii=1:NS
    HIT_S(1:NBS)=0;
    
    for jj=T1:T2
        if (HIT(jj)==0)
            kk=1;
            EV_S(ii,kk,1)=EV(jj);

            T3=1;
            T4=1;
            for ll=1:NI
                for mm=T3:T4
                    for nn=1:2*NB
                        T5=EV_S(ii,mm)-nn*FE;
                        T6=EV_S(ii,mm)+nn*FE;
                        T7=EV_S(ii,mm);
                        T8=nn*FE;
                        
                        if (T5<EV(T1) && T5>=EV(1)) || T6<EV(T1)
                            for oo=1:T1-1 
                                if (HIT_S(oo)==0) && (abs(abs(EV(oo)-T7)-T8)<=eps)
                                    kk=kk+1;

                                    HIT_S(oo)=1;
                                    EV_S(ii,kk,1)=EV(oo);

                                    break
                                end
                            end
                        end
                        
                        if (T5>=EV(T1) && T5<=EV(T2)) || (T6>=EV(T1) && T6<=EV(T2))
                            for oo=T1:T2
                                if (HIT_G(oo)==0) && (abs(abs(EV(oo)-T7)-T8)<=eps)
                                    kk=kk+1;

                                    HIT_G(oo)=1;
                                    EV_S(ii,kk,1)=EV(oo);

                                    break
                                end
                            end
                        end
                        
                        if T5>EV(T2) || (T6>EV(T2) && T6<=EV(NBS))
                            for oo=T1+1:T2
                                if (HIT_S(oo)==0) && (abs(abs(EV(oo)-T7)-T8)<=eps)
                                    kk=kk+1;

                                    HIT_S(oo)=1;
                                    EV_S(ii,kk,1)=EV(oo);

                                    break
                                end
                            end
                        end
                    end
                end
                
                if (kk==T4)
                    break
                end
                
                T3=T4+1;
                T4=kk;
            end
        end
    end
    
    MP(ii,1)=kk;
end

    





end
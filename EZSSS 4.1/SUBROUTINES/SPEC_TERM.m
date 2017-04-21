function TERM=SPEC_TERM(QN,NS)

%****************
%Allocate memory
%***************
TERM=cell(NS,1);

%*************************
%Assign the spectral terms
%*************************
L={'S','P','D','F','G','H','J'};
for ii=1:NS
    S=num2str(QN{ii}(2)*2+1);

    if floor(QN{ii}(4))~=QN{ii}(4)
        if QN{ii}(4)==.5
            J='1/2';
        elseif QN{ii}(4)==1.5
            J='3/2';
        elseif QN{ii}(4)==2.5
            J='5/2';
        elseif QN{ii}(4)==3.5
            J='7/2';
        elseif QN{ii}(4)==4.5
            J='9/2';
        elseif QN{ii}(4)==5.5
            J='11/2';
        elseif QN{ii}(4)==6.5
            J='13/2';
        end
    else
        J=num2str(QN{ii}(4));
    end

    if floor(QN{ii}(5))~=QN{ii}(5)
        if abs(QN{ii}(5))==.5
            if QN{ii}(5)<0
                MJ='-1/2';
            else
                MJ='1/2';
            end
        elseif abs(QN{ii}(5))==1.5
            if QN{ii}(5)<0
                MJ='-3/2';
            else
                MJ='3/2';
            end
        elseif abs(QN{ii}(5))==2.5
            if QN{ii}(5)<0
                MJ='-5/2';
            else
                MJ='5/2';
            end
        elseif abs(QN{ii}(5))==3.5
            if QN{ii}(5)<0
                MJ='-7/2';
            else
                MJ='7/2';
            end
        elseif abs(QN{ii}(5))==4.5
            if QN{ii}(5)<0
                MJ='-9/2';
            else
                MJ='9/2';
            end
        elseif abs(QN{ii}(5))==5.5
            if QN{ii}(5)<0
                MJ='-11/2';
            else
                MJ='11/2';
            end
        elseif abs(QN{ii}(5))==6.5
            if QN{ii}(5)<0
                MJ='-13/2';
            else
                MJ='13/2';
            end
        end
    else
        MJ=num2str(QN{ii}(5));
    end

    TERM{ii}=['^' S L{QN{ii}(3)+1} '_{' J '}^{' MJ '}'];
end
    
end
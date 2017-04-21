function OPT=SET_OPT(OPT,OPT_DEF,OPT_NAMES)

%******************
%Option input logic
%******************
OPT_LOG=isempty(OPT);

%********************************
%Assign option names and subnames
%********************************
OPT_NAME=OPT_NAMES.OPT_NAME;
OPT_SUBNAME=OPT_NAMES.OPT_SUBNAME;
OPT_SUBSUBNAME=OPT_NAMES.OPT_SUBSUBNAME;

for ii=1:length(OPT_NAME)
    %**************************************
    %Set defualt options if root is missing
    %**************************************
    if OPT_LOG==1 || isfield(OPT,OPT_NAME{ii})==0
        for jj=1:length(OPT_SUBNAME{ii})
            OPT.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj})=OPT_DEF.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj});
        end
    else
        %*****************************************
        %Set defualt options if subroot is missing
        %*****************************************
        for jj=1:length(OPT_SUBNAME{ii})
            if isfield(OPT.(OPT_NAME{ii}),OPT_SUBNAME{ii}{jj})==0
                OPT.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj})=OPT_DEF.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj});
            else
                %********************************************
                %Set defualt options if subsubroot is missing
                %********************************************
                for kk=1:length(OPT_SUBSUBNAME{ii}{jj})
                    if isempty(OPT_SUBSUBNAME{ii}{jj}{kk})==0
                        if isfield(OPT.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj}),OPT_SUBSUBNAME{ii}{jj}{kk})==0
                            OPT.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj}).(OPT_SUBSUBNAME{ii}{jj}{kk})=OPT_DEF.(OPT_NAME{ii}).(OPT_SUBNAME{ii}{jj}).(OPT_SUBSUBNAME{ii}{jj}{kk});
                        end
                    end
                end
            end
        end        
    end
end

end
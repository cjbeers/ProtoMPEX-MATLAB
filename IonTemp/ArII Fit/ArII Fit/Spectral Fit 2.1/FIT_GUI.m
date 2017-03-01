 function varargout=FIT_GUI(varargin)

          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %%%%%%%%        CODE INITIALIZATION         %%%%%%%%
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FIT_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FIT_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %%%%%%%%        CODE INITIALIZATION         %%%%%%%%
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%        GUI INITIALIZATION          %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FIT_GUI_OpeningFcn(hObject,eventdata,handles,varargin)

%warning('off')

%***********************
%List of available atoms
%***********************
RAD={'H','D','T','HeI','HeII'};

%*****************************
%List of available text4 states
%*****************************
S.H={.5};
S.D={.5};
S.T={.5};
S.HeI={0,1};
S.HeII={0.5};

%*****************************
%List of available transitions
%*****************************
PQN.H={1,2,3,4,5,6};
PQN.D={1,2,3,4,5,6};
PQN.T={1,2,3};
PQN.HeI={1,2,3,4,5,6};
PQN.HeII={1,2,3,4,5,6,7,8,9,10,11};

          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %%%%%%%%      DEFAULT FIT PARAMETERS        %%%%%%%%
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
%************************
%Number of fit iterations
%************************
NI=1;

%*******************************
%Number of instrument iterations
%*******************************
NI_INS=3;
          
%*********************
%Number tracked points
%*********************
NS=1;

%********************
%Number of processors
%********************
NAP=8;

%***********************
%Main atomic transition
%**********************
LINE={'HeI',1,[2,5]};

%****************************
%Background atomic transition
%****************************
LINE_BK={'HeI',1,[2,5]};

%*********************
%Parameter space logic
%*********************
PSL.PHI=1;
PSL.THETA=1;
PSL.SIGMA=1;
PSL.T1=1;
PSL.T2=1;
PSL.B_Z=1;
PSL.EDC_X=1;
PSL.ERF_X=1;
PSL.EDC_Y=1;
PSL.ERF_Y=1;
PSL.EDC_Z=1;
PSL.ERF_Z=1;
PSL.I_1_GAU=1;
PSL.X_1_GAU=1;
PSL.KT_1_GAU=1;
PSL.I_2_GAU=1;
PSL.X_2_GAU=1;
PSL.KT_2_GAU=1;
PSL.I_LOR=1;
PSL.X_LOR=1;
PSL.GAM_LOR=1;
PSL.IB=0;
PSL.PHI_BK=1;
PSL.THETA_BK=1;
PSL.SIGMA_BK=1;
PSL.T1_BK=1;
PSL.T2_BK=1;
PSL.B_Z_BK=1;
PSL.I_1_GAU_BK=1;
PSL.X_1_GAU_BK=1;
PSL.KT_1_GAU_BK=1;
PSL.I_2_GAU_BK=1;
PSL.X_2_GAU_BK=1;
PSL.KT_2_GAU_BK=1;
PSL.I_LOR_BK=1;
PSL.X_LOR_BK=1;
PSL.GAM_LOR_BK=1;

%**********************
%Parameter space values
%**********************
PSV.PHI=60;
PSV.THETA=90;
PSV.SIGMA=0;
PSV.T1=.5;
PSV.T2=.5;
PSV.B_Z=1.5;
PSV.EDC_X=0;
PSV.ERF_X=0;
PSV.EDC_Y=0;
PSV.ERF_Y=0;
PSV.EDC_Z=0;
PSV.ERF_Z=0;
PSV.I_1_GAU=1;
PSV.X_1_GAU=0;
PSV.KT_1_GAU=0;
PSV.I_2_GAU=0;
PSV.X_2_GAU=0;
PSV.KT_2_GAU=0;
PSV.I_LOR=0;
PSV.X_LOR=0;
PSV.GAM_LOR=0;
PSV.IB=0.3;
PSV.PHI_BK=60;
PSV.THETA_BK=90;
PSV.SIGMA_BK=0;
PSV.T1_BK=.5;
PSV.T2_BK=.5;
PSV.B_Z_BK=1.5;
PSV.I_1_GAU_BK=1;
PSV.X_1_GAU_BK=0;
PSV.KT_1_GAU_BK=0;
PSV.I_2_GAU_BK=0;
PSV.X_2_GAU_BK=0;
PSV.KT_2_GAU_BK=0;
PSV.I_LOR_BK=0;
PSV.X_LOR_BK=0;
PSV.GAM_LOR_BK=0;

%**********************
%Parameter space values
%**********************
PSB.PHI=[30 54];
PSB.THETA=[0 10];
PSB.SIGMA=[0 10];
PSB.T1=[.25 .5];
PSB.T2=[.25 .5];
PSB.B_Z=[3.1,3.5];
PSB.EDC_X=[-1,0];
PSB.ERF_X=[0,3];
PSB.EDC_Y=[-1,0];
PSB.ERF_Y=[0,2];
PSB.EDC_Z=[-1,0];
PSB.ERF_Z=[0,2];
PSB.I_1_GAU=[0,1];
PSB.X_1_GAU=[0,0.5];
PSB.KT_1_GAU=[0 2];
PSB.I_2_GAU=[0,1];
PSB.X_2_GAU=[0,.5];
PSB.KT_2_GAU=[10,50];
PSB.I_LOR=[0,1];
PSB.X_LOR=[0,0.5];
PSB.GAM_LOR=[0.01,.1];
PSB.IB=[0.1,0.5];
PSB.PHI_BK=[30 54];
PSB.THETA_BK=[0 10];
PSB.SIGMA_BK=[0 10];
PSB.T1_BK=[.25 .5];
PSB.T2_BK=[.25 .5];
PSB.B_Z_BK=[5.6,6.8];
PSB.I_1_GAU_BK=[0,1];
PSB.X_1_GAU_BK=[0,0.5];
PSB.KT_1_GAU_BK=[0 2];
PSB.I_2_GAU_BK=[0,1];
PSB.X_2_GAU_BK=[0,.5];
PSB.KT_2_GAU_BK=[10,50];
PSB.I_LOR_BK=[0,1];
PSB.X_LOR_BK=[0,0.5];
PSB.GAM_LOR_BK=[0.01,.1];

%*********************************
%Instrument parameter space values
%*********************************
PSB_INS.VS=[0.95,1.1];
PSB_INS.HS=[-0.05,0.05];

%******************************
%Parameter space dicretizations
%******************************
NDPS.PHI=8;
NDPS.THETA=8;
NDPS.SIGMA=8;
NDPS.T1=8;
NDPS.T2=8;
NDPS.B_Z=8;
NDPS.EDC_X=8;
NDPS.ERF_X=8;
NDPS.EDC_Y=8;
NDPS.ERF_Y=8;
NDPS.EDC_Z=8;
NDPS.ERF_Z=8;
NDPS.I_1_GAU=8;
NDPS.X_1_GAU=8;
NDPS.KT_1_GAU=8;
NDPS.I_2_GAU=8;
NDPS.X_2_GAU=8;
NDPS.KT_2_GAU=8;
NDPS.I_LOR=8;
NDPS.X_LOR=8;
NDPS.GAM_LOR=8;
NDPS.IB=8;
NDPS.PHI_BK=8;
NDPS.THETA_BK=8;
NDPS.SIGMA_BK=8;
NDPS.T1_BK=8;
NDPS.T2_BK=8;
NDPS.B_Z_BK=8;
NDPS.I_1_GAU_BK=8;
NDPS.X_1_GAU_BK=8;
NDPS.KT_1_GAU_BK=8;
NDPS.I_2_GAU_BK=8;
NDPS.X_2_GAU_BK=8;
NDPS.KT_2_GAU_BK=8;
NDPS.I_LOR_BK=8;
NDPS.X_LOR_BK=8;
NDPS.GAM_LOR_BK=8;

%*****************************************
%Instrument parameter space dicretizations
%*****************************************
NDPS_INS.VS=8;
NDPS_INS.HS=8;

DATA.NI=NI;
DATA.NI_INS=NI_INS;
DATA.NS=NS;
DATA.NAP=NAP;
DATA.LINE=LINE;
DATA.LINE_BK=LINE_BK;
DATA.PSL=PSL;
DATA.PSV=PSV;
DATA.PSB=PSB;
DATA.NDPS=NDPS;
DATA.PSB_INS=PSB_INS;
DATA.NDPS_INS=NDPS_INS;

          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %%%%%%%%      DEFAULT FIT PARAMETERS        %%%%%%%%
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
%************************
%Update handles sturcture
%************************
handles.RAD=RAD;
handles.S=S;
handles.PQN=PQN;
handles.DATA=DATA;

%***********************
%Set command line output
%***********************
handles.output=hObject;

%************************
%Update handles structure
%************************
guidata(hObject,handles);

%*****************
%Initalize objects
%*****************
ATOM_CreateFcn(handles.ATOM,[],handles)
NF_CreateFcn(handles.NF,[],handles)
NI_CreateFcn(handles.NI,[],handles)
SPIN_CreateFcn(handles.SPIN,[],handles)
PHI_FIT_CreateFcn(handles.PHI_FIT,[],handles)
PHI_CON_CreateFcn(handles.PHI_CON,[],handles)
PHI_VAL_CreateFcn(handles.PHI_VAL,[],handles)
THETA_FIT_CreateFcn(handles.THETA_FIT,[],handles)
THETA_CON_CreateFcn(handles.THETA_CON,[],handles)
THETA_VAL_CreateFcn(handles.THETA_VAL,[],handles)
SIGMA_FIT_CreateFcn(handles.SIGMA_FIT,[],handles)
SIGMA_CON_CreateFcn(handles.SIGMA_CON,[],handles)
SIGMA_VAL_CreateFcn(handles.SIGMA_VAL,[],handles)
T1_FIT_CreateFcn(handles.T1_FIT,[],handles)
T1_CON_CreateFcn(handles.T1_CON,[],handles)
T1_VAL_CreateFcn(handles.T1_VAL,[],handles)
T2_FIT_CreateFcn(handles.T2_FIT,[],handles)
T2_CON_CreateFcn(handles.T2_CON,[],handles)
T2_VAL_CreateFcn(handles.T2_VAL,[],handles)
B_FIT_CreateFcn(handles.B_FIT,[],handles)
B_CON_CreateFcn(handles.B_CON,[],handles)
B_VAL_CreateFcn(handles.B_VAL,[],handles)
EDC_X_FIT_CreateFcn(handles.EDC_X_FIT,[],handles)
EDC_X_CON_CreateFcn(handles.EDC_X_CON,[],handles)
EDC_X_VAL_CreateFcn(handles.EDC_X_VAL,[],handles)
EDC_Y_FIT_CreateFcn(handles.EDC_Y_FIT,[],handles)
EDC_Y_CON_CreateFcn(handles.EDC_Y_CON,[],handles)
EDC_Y_VAL_CreateFcn(handles.EDC_Y_VAL,[],handles)
EDC_Z_FIT_CreateFcn(handles.EDC_Z_FIT,[],handles)
EDC_Z_CON_CreateFcn(handles.EDC_Z_CON,[],handles)
EDC_Z_VAL_CreateFcn(handles.EDC_Z_VAL,[],handles)
ERF_X_FIT_CreateFcn(handles.ERF_X_FIT,[],handles)
ERF_X_CON_CreateFcn(handles.ERF_X_CON,[],handles)
ERF_X_VAL_CreateFcn(handles.ERF_X_VAL,[],handles)
ERF_Y_FIT_CreateFcn(handles.ERF_Y_FIT,[],handles)
ERF_Y_CON_CreateFcn(handles.ERF_Y_CON,[],handles)
ERF_Y_VAL_CreateFcn(handles.ERF_Y_VAL,[],handles)
ERF_Z_FIT_CreateFcn(handles.ERF_Z_FIT,[],handles)
ERF_Z_CON_CreateFcn(handles.ERF_Z_CON,[],handles)
ERF_Z_VAL_CreateFcn(handles.ERF_Z_VAL,[],handles)
I_1_GAU_FIT_CreateFcn(handles.I_1_GAU_FIT,[],handles)
I_1_GAU_CON_CreateFcn(handles.I_1_GAU_CON,[],handles)
I_1_GAU_VAL_CreateFcn(handles.I_1_GAU_VAL,[],handles)
X_1_GAU_FIT_CreateFcn(handles.X_1_GAU_FIT,[],handles)
X_1_GAU_CON_CreateFcn(handles.X_1_GAU_CON,[],handles)
X_1_GAU_VAL_CreateFcn(handles.X_1_GAU_VAL,[],handles)
KT_1_GAU_FIT_CreateFcn(handles.KT_1_GAU_FIT,[],handles)
KT_1_GAU_CON_CreateFcn(handles.KT_1_GAU_CON,[],handles)
KT_1_GAU_VAL_CreateFcn(handles.KT_1_GAU_VAL,[],handles)
I_2_GAU_FIT_CreateFcn(handles.I_2_GAU_FIT,[],handles)
I_2_GAU_CON_CreateFcn(handles.I_2_GAU_CON,[],handles)
I_2_GAU_VAL_CreateFcn(handles.I_2_GAU_VAL,[],handles)
X_2_GAU_FIT_CreateFcn(handles.X_2_GAU_FIT,[],handles)
X_2_GAU_CON_CreateFcn(handles.X_2_GAU_CON,[],handles)
X_2_GAU_VAL_CreateFcn(handles.X_2_GAU_VAL,[],handles)
KT_2_GAU_FIT_CreateFcn(handles.KT_2_GAU_FIT,[],handles)
KT_2_GAU_CON_CreateFcn(handles.KT_2_GAU_CON,[],handles)
KT_2_GAU_VAL_CreateFcn(handles.KT_2_GAU_VAL,[],handles)
I_LOR_FIT_CreateFcn(handles.I_LOR_FIT,[],handles)
I_LOR_CON_CreateFcn(handles.I_LOR_CON,[],handles)
I_LOR_VAL_CreateFcn(handles.I_LOR_VAL,[],handles)
X_LOR_FIT_CreateFcn(handles.X_LOR_FIT,[],handles)
X_LOR_CON_CreateFcn(handles.X_LOR_CON,[],handles)
X_LOR_VAL_CreateFcn(handles.X_LOR_VAL,[],handles)
GAM_LOR_FIT_CreateFcn(handles.GAM_LOR_FIT,[],handles)
GAM_LOR_CON_CreateFcn(handles.GAM_LOR_CON,[],handles)
GAM_LOR_VAL_CreateFcn(handles.GAM_LOR_VAL,[],handles)
IB_FIT_CreateFcn(handles.IB_FIT,[],handles)
IB_CON_CreateFcn(handles.IB_CON,[],handles)
IB_VAL_CreateFcn(handles.IB_VAL,[],handles)
ATOM_BK_CreateFcn(handles.ATOM_BK,[],handles)
NF_BK_CreateFcn(handles.NF_BK,[],handles)
NI_BK_CreateFcn(handles.NI_BK,[],handles)
SPIN_BK_CreateFcn(handles.SPIN_BK,[],handles)
PHI_FIT_BK_CreateFcn(handles.PHI_FIT_BK,[],handles)
PHI_CON_BK_CreateFcn(handles.PHI_CON_BK,[],handles)
PHI_VAL_BK_CreateFcn(handles.PHI_VAL_BK,[],handles)
THETA_FIT_BK_CreateFcn(handles.THETA_FIT_BK,[],handles)
THETA_CON_BK_CreateFcn(handles.THETA_CON_BK,[],handles)
THETA_VAL_BK_CreateFcn(handles.THETA_VAL_BK,[],handles)
SIGMA_FIT_BK_CreateFcn(handles.SIGMA_FIT_BK,[],handles)
SIGMA_CON_BK_CreateFcn(handles.SIGMA_CON_BK,[],handles)
SIGMA_VAL_BK_CreateFcn(handles.SIGMA_VAL_BK,[],handles)
T1_FIT_BK_CreateFcn(handles.T1_FIT_BK,[],handles)
T1_CON_BK_CreateFcn(handles.T1_CON_BK,[],handles)
T1_VAL_BK_CreateFcn(handles.T1_VAL_BK,[],handles)
T2_FIT_BK_CreateFcn(handles.T2_FIT_BK,[],handles)
T2_CON_BK_CreateFcn(handles.T2_CON_BK,[],handles)
T2_VAL_BK_CreateFcn(handles.T2_VAL_BK,[],handles)
B_FIT_BK_CreateFcn(handles.B_FIT_BK,[],handles)
B_CON_BK_CreateFcn(handles.B_CON_BK,[],handles)
B_VAL_BK_CreateFcn(handles.B_VAL_BK,[],handles)
I_1_GAU_FIT_BK_CreateFcn(handles.I_1_GAU_FIT_BK,[],handles)
I_1_GAU_CON_BK_CreateFcn(handles.I_1_GAU_CON_BK,[],handles)
I_1_GAU_VAL_BK_CreateFcn(handles.I_1_GAU_VAL_BK,[],handles)
X_1_GAU_FIT_BK_CreateFcn(handles.X_1_GAU_FIT_BK,[],handles)
X_1_GAU_CON_BK_CreateFcn(handles.X_1_GAU_CON_BK,[],handles)
X_1_GAU_VAL_BK_CreateFcn(handles.X_1_GAU_VAL_BK,[],handles)
KT_1_GAU_FIT_BK_CreateFcn(handles.KT_1_GAU_FIT_BK,[],handles)
KT_1_GAU_CON_BK_CreateFcn(handles.KT_1_GAU_CON_BK,[],handles)
KT_1_GAU_VAL_BK_CreateFcn(handles.KT_1_GAU_VAL_BK,[],handles)
I_2_GAU_FIT_BK_CreateFcn(handles.I_2_GAU_FIT_BK,[],handles)
I_2_GAU_CON_BK_CreateFcn(handles.I_2_GAU_CON_BK,[],handles)
I_2_GAU_VAL_BK_CreateFcn(handles.I_2_GAU_VAL_BK,[],handles)
X_2_GAU_FIT_BK_CreateFcn(handles.X_2_GAU_FIT_BK,[],handles)
X_2_GAU_CON_BK_CreateFcn(handles.X_2_GAU_CON_BK,[],handles)
X_2_GAU_VAL_BK_CreateFcn(handles.X_2_GAU_VAL_BK,[],handles)
KT_2_GAU_FIT_BK_CreateFcn(handles.KT_2_GAU_FIT_BK,[],handles)
KT_2_GAU_CON_BK_CreateFcn(handles.KT_2_GAU_CON_BK,[],handles)
KT_2_GAU_VAL_BK_CreateFcn(handles.KT_2_GAU_VAL_BK,[],handles)
I_LOR_FIT_BK_CreateFcn(handles.I_LOR_FIT_BK,[],handles)
I_LOR_CON_BK_CreateFcn(handles.I_LOR_CON_BK,[],handles)
I_LOR_VAL_BK_CreateFcn(handles.I_LOR_VAL_BK,[],handles)
X_LOR_FIT_BK_CreateFcn(handles.X_LOR_FIT_BK,[],handles)
X_LOR_CON_BK_CreateFcn(handles.X_LOR_CON_BK,[],handles)
X_LOR_VAL_BK_CreateFcn(handles.X_LOR_VAL_BK,[],handles)
GAM_LOR_FIT_BK_CreateFcn(handles.GAM_LOR_FIT_BK,[],handles)
GAM_LOR_CON_BK_CreateFcn(handles.GAM_LOR_CON_BK,[],handles)
GAM_LOR_VAL_BK_CreateFcn(handles.GAM_LOR_VAL_BK,[],handles)
HS_CreateFcn(handles.HS,[],handles)
VS_CreateFcn(handles.VS,[],handles)
NI_FIT_CreateFcn(handles.NI_FIT,[],handles)
NI_INS_CreateFcn(handles.NI_INS,[],handles)
NS_CreateFcn(handles.NS,[],handles)
NAP_CreateFcn(handles.NAP,[],handles)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%        GUI INITIALIZATION          %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%             GUI OUTPUTS            %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout=FIT_GUI_OutputFcn(hObject,eventdata,handles) 

%**************************
%Assign command line output
%**************************
varargout{1}=handles.output;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%             GUI OUTPUTS            %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%     INITIALIZATION OF OBJECTS      %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ATOM_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    %*********************
    %Set object properties
    %*********************  
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************
    RAD=handles.RAD;
    DATA=handles.DATA;
    
    LINE=DATA.LINE;
    
    %*******************
    %Assign object value
    %*******************
    for ii=1:length(RAD)
        if strcmpi(RAD{ii},LINE{1})
            VALUE=ii;
            break
        end
    end
    
    %*********************
    %Set object properties
    %*********************  
    set(hObject,'String',RAD)
    set(hObject,'Value',VALUE)
end

end

function NF_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    %*********************
    %Set object properties
    %*********************      
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    PQN=handles.PQN;
    DATA=handles.DATA;
    
    LINE=DATA.LINE;
    LIST=PQN.(LINE{1});
    
    %*********************
    %Assign location of ni
    %*********************
    for ii=1:length(LIST)
        if (LINE{3}(1)==LIST{ii})
            VALUE=ii;
        end
    end
    
    %*********************
    %Set object properties
    %*********************  
    set(hObject,'String',LIST)
    set(hObject,'Value',VALUE)
end

end

function NI_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    %*********************
    %Set object properties
    %*********************       
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    PQN=handles.PQN;
    DATA=handles.DATA;
    
    LINE=DATA.LINE;
    LIST=PQN.(LINE{1});
    
    %*********************
    %Assign location of ni
    %*********************
    for ii=1:length(LIST)
        if (LINE{3}(2)==LIST{ii})
            VALUE=ii;
        end
    end
    
    %*********************
    %Set object properties
    %*********************  
    set(hObject,'String',LIST)
    set(hObject,'Value',VALUE)
end

end

function SPIN_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    %*********************
    %Set object properties
    %*********************       
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    S=handles.S;
    DATA=handles.DATA;
    
    LINE=DATA.LINE;
    LIST=S.(LINE{1});
    
    %********************
    %Assign location of S
    %********************
    for ii=1:length(LIST)
        if (LINE{2}==LIST{ii})
            VALUE=ii;
        end
    end
    
    %*********************
    %Set object properties
    %*********************  
    set(hObject,'String',LIST)
    set(hObject,'Value',VALUE)
end

end

function PHI_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_PHI=DATA.PSL.PHI;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_PHI==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function PHI_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_PHI=DATA.PSL.PHI;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_PHI==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function PHI_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_PHI=DATA.PSL.PHI;
    PSV_PHI=DATA.PSV.PHI;
    PSB_PHI=DATA.PSB.PHI;
    NDPS_PHI=DATA.NDPS.PHI;

    if (PSL_PHI==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_PHI);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_PHI(1)) ',' num2str(PSB_PHI(2)) ',' num2str(NDPS_PHI)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function THETA_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_THETA=DATA.PSL.THETA;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_THETA==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function THETA_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_THETA=DATA.PSL.THETA;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_THETA==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function THETA_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_THETA=DATA.PSL.THETA;
    PSV_THETA=DATA.PSV.THETA;
    PSB_THETA=DATA.PSB.THETA;
    NDPS_THETA=DATA.NDPS.THETA;

    if (PSL_THETA==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_THETA);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_THETA(1)) ',' num2str(PSB_THETA(2)) ',' num2str(NDPS_THETA)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function SIGMA_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_SIGMA=DATA.PSL.SIGMA;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_SIGMA==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function SIGMA_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_SIGMA=DATA.PSL.SIGMA;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_SIGMA==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function SIGMA_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_SIGMA=DATA.PSL.SIGMA;
    PSV_SIGMA=DATA.PSV.SIGMA;
    PSB_SIGMA=DATA.PSB.SIGMA;
    NDPS_SIGMA=DATA.NDPS.SIGMA;

    if (PSL_SIGMA==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_SIGMA);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_SIGMA(1)) ',' num2str(PSB_SIGMA(2)) ',' num2str(NDPS_SIGMA)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function T1_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_T1=DATA.PSL.T1;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_T1==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function T1_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_T1=DATA.PSL.T1;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_T1==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function T1_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_T1=DATA.PSL.T1;
    PSV_T1=DATA.PSV.T1;
    PSB_T1=DATA.PSB.T1;
    NDPS_T1=DATA.NDPS.T1;

    if (PSL_T1==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_T1);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_T1(1)) ',' num2str(PSB_T1(2)) ',' num2str(NDPS_T1)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function T2_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_T2=DATA.PSL.T2;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_T2==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function T2_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_T2=DATA.PSL.T2;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_T2==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function T2_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_T2=DATA.PSL.T2;
    PSV_T2=DATA.PSV.T2;
    PSB_T2=DATA.PSB.T2;
    NDPS_T2=DATA.NDPS.T2;

    if (PSL_T2==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_T2);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_T2(1)) ',' num2str(PSB_T2(2)) ',' num2str(NDPS_T2)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function B_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_B_Z=DATA.PSL.B_Z;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_B_Z==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function B_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_B_Z=DATA.PSL.B_Z;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_B_Z==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function B_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_B_Z=DATA.PSL.B_Z;
    PSV_B_Z=DATA.PSV.B_Z;
    PSB_B_Z=DATA.PSB.B_Z;
    NDPS_B_Z=DATA.NDPS.B_Z;

    if (PSL_B_Z==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_B_Z);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_B_Z(1)) ',' num2str(PSB_B_Z(2)) ',' num2str(NDPS_B_Z)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function EDC_X_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_EDC_X=DATA.PSL.EDC_X;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_EDC_X==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function EDC_X_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_EDC_X=DATA.PSL.EDC_X;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_EDC_X==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function EDC_X_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_EDC_X=DATA.PSL.EDC_X;
    PSV_EDC_X=DATA.PSV.EDC_X;
    PSB_EDC_X=DATA.PSB.EDC_X;
    NDPS_EDC_X=DATA.NDPS.EDC_X;

    if (PSL_EDC_X==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_EDC_X);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_EDC_X(1)) ',' num2str(PSB_EDC_X(2)) ',' num2str(NDPS_EDC_X)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function EDC_Y_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_EDC_Y=DATA.PSL.EDC_Y;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_EDC_Y==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function EDC_Y_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_EDC_Y=DATA.PSL.EDC_Y;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_EDC_Y==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function EDC_Y_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_EDC_Y=DATA.PSL.EDC_Y;
    PSV_EDC_Y=DATA.PSV.EDC_Y;
    PSB_EDC_Y=DATA.PSB.EDC_Y;
    NDPS_EDC_Y=DATA.NDPS.EDC_Y;

    if (PSL_EDC_Y==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_EDC_Y);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_EDC_Y(1)) ',' num2str(PSB_EDC_Y(2)) ',' num2str(NDPS_EDC_Y)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function EDC_Z_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_EDC_Z=DATA.PSL.EDC_Z;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_EDC_Z==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function EDC_Z_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_EDC_Z=DATA.PSL.EDC_Z;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_EDC_Z==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function EDC_Z_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_EDC_Z=DATA.PSL.EDC_Z;
    PSV_EDC_Z=DATA.PSV.EDC_Z;
    PSB_EDC_Z=DATA.PSB.EDC_Z;
    NDPS_EDC_Z=DATA.NDPS.EDC_Z;

    if (PSL_EDC_Z==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_EDC_Z);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_EDC_Z(1)) ',' num2str(PSB_EDC_Z(2)) ',' num2str(NDPS_EDC_Z)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function ERF_X_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_ERF_X=DATA.PSL.ERF_X;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_ERF_X==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function ERF_X_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_ERF_X=DATA.PSL.ERF_X;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_ERF_X==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function ERF_X_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_ERF_X=DATA.PSL.ERF_X;
    PSV_ERF_X=DATA.PSV.ERF_X;
    PSB_ERF_X=DATA.PSB.ERF_X;
    NDPS_ERF_X=DATA.NDPS.ERF_X;

    if (PSL_ERF_X==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_ERF_X);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_ERF_X(1)) ',' num2str(PSB_ERF_X(2)) ',' num2str(NDPS_ERF_X)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function ERF_Y_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_ERF_Y=DATA.PSL.ERF_Y;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_ERF_Y==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function ERF_Y_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_ERF_Y=DATA.PSL.ERF_Y;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_ERF_Y==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function ERF_Y_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_ERF_Y=DATA.PSL.ERF_Y;
    PSV_ERF_Y=DATA.PSV.ERF_Y;
    PSB_ERF_Y=DATA.PSB.ERF_Y;
    NDPS_ERF_Y=DATA.NDPS.ERF_Y;

    if (PSL_ERF_Y==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_ERF_Y);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_ERF_Y(1)) ',' num2str(PSB_ERF_Y(2)) ',' num2str(NDPS_ERF_Y)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function ERF_Z_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_ERF_Z=DATA.PSL.ERF_Z;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_ERF_Z==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function ERF_Z_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_ERF_Z=DATA.PSL.ERF_Z;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_ERF_Z==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function ERF_Z_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_ERF_Z=DATA.PSL.ERF_Z;
    PSV_ERF_Z=DATA.PSV.ERF_Z;
    PSB_ERF_Z=DATA.PSB.ERF_Z;
    NDPS_ERF_Z=DATA.NDPS.ERF_Z;

    if (PSL_ERF_Z==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_ERF_Z);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_ERF_Z(1)) ',' num2str(PSB_ERF_Z(2)) ',' num2str(NDPS_ERF_Z)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function I_1_GAU_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_1_GAU=DATA.PSL.I_1_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_1_GAU==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function I_1_GAU_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_1_GAU=DATA.PSL.I_1_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_1_GAU==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function I_1_GAU_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_I_1_GAU=DATA.PSL.I_1_GAU;
    PSV_I_1_GAU=DATA.PSV.I_1_GAU;
    PSB_I_1_GAU=DATA.PSB.I_1_GAU;
    NDPS_I_1_GAU=DATA.NDPS.I_1_GAU;

    if (PSL_I_1_GAU==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_I_1_GAU);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_I_1_GAU(1)) ',' num2str(PSB_I_1_GAU(2)) ',' num2str(NDPS_I_1_GAU)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function X_1_GAU_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_1_GAU=DATA.PSL.X_1_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_1_GAU==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function X_1_GAU_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_1_GAU=DATA.PSL.X_1_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_1_GAU==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function X_1_GAU_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_X_1_GAU=DATA.PSL.X_1_GAU;
    PSV_X_1_GAU=DATA.PSV.X_1_GAU;
    PSB_X_1_GAU=DATA.PSB.X_1_GAU;
    NDPS_X_1_GAU=DATA.NDPS.X_1_GAU;

    if (PSL_X_1_GAU==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_X_1_GAU);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_X_1_GAU(1)) ',' num2str(PSB_X_1_GAU(2)) ',' num2str(NDPS_X_1_GAU)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function KT_1_GAU_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_KT_1_GAU=DATA.PSL.KT_1_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_KT_1_GAU==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function KT_1_GAU_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_KT_1_GAU=DATA.PSL.KT_1_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_KT_1_GAU==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function KT_1_GAU_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_KT_1_GAU=DATA.PSL.KT_1_GAU;
    PSV_KT_1_GAU=DATA.PSV.KT_1_GAU;
    PSB_KT_1_GAU=DATA.PSB.KT_1_GAU;
    NDPS_KT_1_GAU=DATA.NDPS.KT_1_GAU;

    if (PSL_KT_1_GAU==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_KT_1_GAU);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_KT_1_GAU(1)) ',' num2str(PSB_KT_1_GAU(2)) ',' num2str(NDPS_KT_1_GAU)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function I_2_GAU_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_2_GAU=DATA.PSL.I_2_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_2_GAU==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function I_2_GAU_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_2_GAU=DATA.PSL.I_2_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_2_GAU==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function I_2_GAU_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_I_2_GAU=DATA.PSL.I_2_GAU;
    PSV_I_2_GAU=DATA.PSV.I_2_GAU;
    PSB_I_2_GAU=DATA.PSB.I_2_GAU;
    NDPS_I_2_GAU=DATA.NDPS.I_2_GAU;

    if (PSL_I_2_GAU==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_I_2_GAU);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_I_2_GAU(1)) ',' num2str(PSB_I_2_GAU(2)) ',' num2str(NDPS_I_2_GAU)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function X_2_GAU_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_2_GAU=DATA.PSL.X_2_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_2_GAU==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function X_2_GAU_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_2_GAU=DATA.PSL.X_2_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_2_GAU==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function X_2_GAU_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_X_2_GAU=DATA.PSL.X_2_GAU;
    PSV_X_2_GAU=DATA.PSV.X_2_GAU;
    PSB_X_2_GAU=DATA.PSB.X_2_GAU;
    NDPS_X_2_GAU=DATA.NDPS.X_2_GAU;

    if (PSL_X_2_GAU==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_X_2_GAU);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_X_2_GAU(1)) ',' num2str(PSB_X_2_GAU(2)) ',' num2str(NDPS_X_2_GAU)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function KT_2_GAU_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_KT_2_GAU=DATA.PSL.KT_2_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_KT_2_GAU==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function KT_2_GAU_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_KT_2_GAU=DATA.PSL.KT_2_GAU;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_KT_2_GAU==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function KT_2_GAU_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_KT_2_GAU=DATA.PSL.KT_2_GAU;
    PSV_KT_2_GAU=DATA.PSV.KT_2_GAU;
    PSB_KT_2_GAU=DATA.PSB.KT_2_GAU;
    NDPS_KT_2_GAU=DATA.NDPS.KT_2_GAU;

    if (PSL_KT_2_GAU==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_KT_2_GAU);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_KT_2_GAU(1)) ',' num2str(PSB_KT_2_GAU(2)) ',' num2str(NDPS_KT_2_GAU)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function I_LOR_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_LOR=DATA.PSL.I_LOR;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_LOR==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function I_LOR_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_LOR=DATA.PSL.I_LOR;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_LOR==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function I_LOR_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_I_LOR=DATA.PSL.I_LOR;
    PSV_I_LOR=DATA.PSV.I_LOR;
    PSB_I_LOR=DATA.PSB.I_LOR;
    NDPS_I_LOR=DATA.NDPS.I_LOR;

    if (PSL_I_LOR==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_I_LOR);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_I_LOR(1)) ',' num2str(PSB_I_LOR(2)) ',' num2str(NDPS_I_LOR)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function X_LOR_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_LOR=DATA.PSL.X_LOR;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_LOR==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function X_LOR_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_LOR=DATA.PSL.X_LOR;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_LOR==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function X_LOR_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_X_LOR=DATA.PSL.X_LOR;
    PSV_X_LOR=DATA.PSV.X_LOR;
    PSB_X_LOR=DATA.PSB.X_LOR;
    NDPS_X_LOR=DATA.NDPS.X_LOR;

    if (PSL_X_LOR==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_X_LOR);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_X_LOR(1)) ',' num2str(PSB_X_LOR(2)) ',' num2str(NDPS_X_LOR)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function GAM_LOR_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_GAM_LOR=DATA.PSL.GAM_LOR;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_GAM_LOR==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function GAM_LOR_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_GAM_LOR=DATA.PSL.GAM_LOR;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_GAM_LOR==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function GAM_LOR_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_GAM_LOR=DATA.PSL.GAM_LOR;
    PSV_GAM_LOR=DATA.PSV.GAM_LOR;
    PSB_GAM_LOR=DATA.PSB.GAM_LOR;
    NDPS_GAM_LOR=DATA.NDPS.GAM_LOR;

    if (PSL_GAM_LOR==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_GAM_LOR);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_GAM_LOR(1)) ',' num2str(PSB_GAM_LOR(2)) ',' num2str(NDPS_GAM_LOR)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function IB_FIT_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_IB=DATA.PSL.IB;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_IB==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function IB_CON_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_IB=DATA.PSL.IB;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_IB==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function IB_VAL_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_IB=DATA.PSL.IB;
    PSV_IB=DATA.PSV.IB;
    PSB_IB=DATA.PSB.IB;
    NDPS_IB=DATA.NDPS.IB;

    if (PSL_IB==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_IB);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_IB(1)) ',' num2str(PSB_IB(2)) ',' num2str(NDPS_IB)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function ATOM_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************
    RAD=handles.RAD;
    DATA=handles.DATA;
    
    LINE_BK=DATA.LINE_BK;
    
    %*******************
    %Assign object value
    %*******************
    for ii=1:length(RAD)
        if strcmpi(RAD{ii},LINE_BK{1})
            VALUE=ii;
            break
        end
    end
    
    %*********************
    %Set object properties
    %*********************  
    set(hObject,'String',RAD)
    set(hObject,'Value',VALUE)
end

end

function NF_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    PQN=handles.PQN;
    DATA=handles.DATA;
    
    LINE_BK=DATA.LINE_BK;
    LIST=PQN.(LINE_BK{1});
    
    %*********************
    %Assign location of ni
    %*********************
    for ii=1:length(LIST)
        if (LINE_BK{3}(1)==LIST{ii})
            VALUE=ii;
        end
    end
    
    %*********************
    %Set object properties
    %*********************  
    set(hObject,'String',LIST)
    set(hObject,'Value',VALUE)
end

end

function NI_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    PQN=handles.PQN;
    DATA=handles.DATA;
    
    LINE_BK=DATA.LINE_BK;
    LIST=PQN.(LINE_BK{1});
    
    %*********************
    %Assign location of ni
    %*********************
    for ii=1:length(LIST)
        if (LINE_BK{3}(2)==LIST{ii})
            VALUE=ii;
        end
    end
    
    %*********************
    %Set object properties
    %*********************  
    set(hObject,'String',LIST)
    set(hObject,'Value',VALUE)
end

end

function SPIN_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    S=handles.S;
    DATA=handles.DATA;
    
    LINE_BK=DATA.LINE_BK;
    LIST=S.(LINE_BK{1});
    
    %********************
    %Assign location of S
    %********************
    for ii=1:length(LIST)
        if (LINE_BK{2}==LIST{ii})
            VALUE=ii;
        end
    end
    
    %*********************
    %Set object properties
    %*********************  
    set(hObject,'String',LIST)
    set(hObject,'Value',VALUE)
end

end

function PHI_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_PHI_BK=DATA.PSL.PHI_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_PHI_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function PHI_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_PHI_BK=DATA.PSL.PHI_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_PHI_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function PHI_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_PHI_BK=DATA.PSL.PHI_BK;
    PSV_PHI_BK=DATA.PSV.PHI_BK;
    PSB_PHI_BK=DATA.PSB.PHI_BK;
    NDPS_PHI_BK=DATA.NDPS.PHI_BK;

    if (PSL_PHI_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_PHI_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_PHI_BK(1)) ',' num2str(PSB_PHI_BK(2)) ',' num2str(NDPS_PHI_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function THETA_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_THETA_BK=DATA.PSL.THETA_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_THETA_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function THETA_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_THETA_BK=DATA.PSL.THETA_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_THETA_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function THETA_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_THETA_BK=DATA.PSL.THETA_BK;
    PSV_THETA_BK=DATA.PSV.THETA_BK;
    PSB_THETA_BK=DATA.PSB.THETA_BK;
    NDPS_THETA_BK=DATA.NDPS.THETA_BK;

    if (PSL_THETA_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_THETA_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_THETA_BK(1)) ',' num2str(PSB_THETA_BK(2)) ',' num2str(NDPS_THETA_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function SIGMA_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_SIGMA_BK=DATA.PSL.SIGMA_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_SIGMA_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function SIGMA_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_SIGMA_BK=DATA.PSL.SIGMA_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_SIGMA_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function SIGMA_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_SIGMA_BK=DATA.PSL.SIGMA_BK;
    PSV_SIGMA_BK=DATA.PSV.SIGMA_BK;
    PSB_SIGMA_BK=DATA.PSB.SIGMA_BK;
    NDPS_SIGMA_BK=DATA.NDPS.SIGMA_BK;

    if (PSL_SIGMA_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_SIGMA_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_SIGMA_BK(1)) ',' num2str(PSB_SIGMA_BK(2)) ',' num2str(NDPS_SIGMA_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function T1_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_T1_BK=DATA.PSL.T1_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_T1_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function T1_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_T1_BK=DATA.PSL.T1_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_T1_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function T1_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_T1_BK=DATA.PSL.T1_BK;
    PSV_T1_BK=DATA.PSV.T1_BK;
    PSB_T1_BK=DATA.PSB.T1_BK;
    NDPS_T1_BK=DATA.NDPS.T1_BK;

    if (PSL_T1_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_T1_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_T1_BK(1)) ',' num2str(PSB_T1_BK(2)) ',' num2str(NDPS_T1_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function T2_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_T2_BK=DATA.PSL.T2_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_T2_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function T2_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_T2_BK=DATA.PSL.T2_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_T2_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function T2_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_T2_BK=DATA.PSL.T2_BK;
    PSV_T2_BK=DATA.PSV.T2_BK;
    PSB_T2_BK=DATA.PSB.T2_BK;
    NDPS_T2_BK=DATA.NDPS.T2_BK;

    if (PSL_T2_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_T2_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_T2_BK(1)) ',' num2str(PSB_T2_BK(2)) ',' num2str(NDPS_T2_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function B_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_B_Z_BK=DATA.PSL.B_Z_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_B_Z_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function B_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_B_Z_BK=DATA.PSL.B_Z_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_B_Z_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function B_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_B_Z_BK=DATA.PSL.B_Z_BK;
    PSV_B_Z_BK=DATA.PSV.B_Z_BK;
    PSB_B_Z_BK=DATA.PSB.B_Z_BK;
    NDPS_B_Z_BK=DATA.NDPS.B_Z_BK;

    if (PSL_B_Z_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_B_Z_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_B_Z_BK(1)) ',' num2str(PSB_B_Z_BK(2)) ',' num2str(NDPS_B_Z_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function I_1_GAU_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_1_GAU_BK=DATA.PSL.I_1_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_1_GAU_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function I_1_GAU_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_1_GAU_BK=DATA.PSL.I_1_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_1_GAU_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function I_1_GAU_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_I_1_GAU_BK=DATA.PSL.I_1_GAU_BK;
    PSV_I_1_GAU_BK=DATA.PSV.I_1_GAU_BK;
    PSB_I_1_GAU_BK=DATA.PSB.I_1_GAU_BK;
    NDPS_I_1_GAU_BK=DATA.NDPS.I_1_GAU_BK;

    if (PSL_I_1_GAU_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_I_1_GAU_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_I_1_GAU_BK(1)) ',' num2str(PSB_I_1_GAU_BK(2)) ',' num2str(NDPS_I_1_GAU_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function X_1_GAU_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_1_GAU_BK=DATA.PSL.X_1_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_1_GAU_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function X_1_GAU_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_1_GAU_BK=DATA.PSL.X_1_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_1_GAU_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function X_1_GAU_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_X_1_GAU_BK=DATA.PSL.X_1_GAU_BK;
    PSV_X_1_GAU_BK=DATA.PSV.X_1_GAU_BK;
    PSB_X_1_GAU_BK=DATA.PSB.X_1_GAU_BK;
    NDPS_X_1_GAU_BK=DATA.NDPS.X_1_GAU_BK;

    if (PSL_X_1_GAU_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_X_1_GAU_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_X_1_GAU_BK(1)) ',' num2str(PSB_X_1_GAU_BK(2)) ',' num2str(NDPS_X_1_GAU_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function KT_1_GAU_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_KT_1_GAU_BK=DATA.PSL.KT_1_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_KT_1_GAU_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function KT_1_GAU_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_KT_1_GAU_BK=DATA.PSL.KT_1_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_KT_1_GAU_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function KT_1_GAU_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_KT_1_GAU_BK=DATA.PSL.KT_1_GAU_BK;
    PSV_KT_1_GAU_BK=DATA.PSV.KT_1_GAU_BK;
    PSB_KT_1_GAU_BK=DATA.PSB.KT_1_GAU_BK;
    NDPS_KT_1_GAU_BK=DATA.NDPS.KT_1_GAU_BK;

    if (PSL_KT_1_GAU_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_KT_1_GAU_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_KT_1_GAU_BK(1)) ',' num2str(PSB_KT_1_GAU_BK(2)) ',' num2str(NDPS_KT_1_GAU_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function I_2_GAU_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_2_GAU_BK=DATA.PSL.I_2_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_2_GAU_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function I_2_GAU_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_2_GAU_BK=DATA.PSL.I_2_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_2_GAU_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function I_2_GAU_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_I_2_GAU_BK=DATA.PSL.I_2_GAU_BK;
    PSV_I_2_GAU_BK=DATA.PSV.I_2_GAU_BK;
    PSB_I_2_GAU_BK=DATA.PSB.I_2_GAU_BK;
    NDPS_I_2_GAU_BK=DATA.NDPS.I_2_GAU_BK;

    if (PSL_I_2_GAU_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_I_2_GAU_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_I_2_GAU_BK(1)) ',' num2str(PSB_I_2_GAU_BK(2)) ',' num2str(NDPS_I_2_GAU_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function X_2_GAU_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_2_GAU_BK=DATA.PSL.X_2_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_2_GAU_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function X_2_GAU_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_2_GAU_BK=DATA.PSL.X_2_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_2_GAU_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function X_2_GAU_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_X_2_GAU_BK=DATA.PSL.X_2_GAU_BK;
    PSV_X_2_GAU_BK=DATA.PSV.X_2_GAU_BK;
    PSB_X_2_GAU_BK=DATA.PSB.X_2_GAU_BK;
    NDPS_X_2_GAU_BK=DATA.NDPS.X_2_GAU_BK;

    if (PSL_X_2_GAU_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_X_2_GAU_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_X_2_GAU_BK(1)) ',' num2str(PSB_X_2_GAU_BK(2)) ',' num2str(NDPS_X_2_GAU_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function KT_2_GAU_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_KT_2_GAU_BK=DATA.PSL.KT_2_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_KT_2_GAU_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function KT_2_GAU_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_KT_2_GAU_BK=DATA.PSL.KT_2_GAU_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_KT_2_GAU_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function KT_2_GAU_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_KT_2_GAU_BK=DATA.PSL.KT_2_GAU_BK;
    PSV_KT_2_GAU_BK=DATA.PSV.KT_2_GAU_BK;
    PSB_KT_2_GAU_BK=DATA.PSB.KT_2_GAU_BK;
    NDPS_KT_2_GAU_BK=DATA.NDPS.KT_2_GAU_BK;

    if (PSL_KT_2_GAU_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_KT_2_GAU_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_KT_2_GAU_BK(1)) ',' num2str(PSB_KT_2_GAU_BK(2)) ',' num2str(NDPS_KT_2_GAU_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function I_LOR_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_LOR_BK=DATA.PSL.I_LOR_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_LOR_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function I_LOR_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_I_LOR_BK=DATA.PSL.I_LOR_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_I_LOR_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function I_LOR_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_I_LOR_BK=DATA.PSL.I_LOR_BK;
    PSV_I_LOR_BK=DATA.PSV.I_LOR_BK;
    PSB_I_LOR_BK=DATA.PSB.I_LOR_BK;
    NDPS_I_LOR_BK=DATA.NDPS.I_LOR_BK;

    if (PSL_I_LOR_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_I_LOR_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_I_LOR_BK(1)) ',' num2str(PSB_I_LOR_BK(2)) ',' num2str(NDPS_I_LOR_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function X_LOR_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_LOR_BK=DATA.PSL.X_LOR_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_LOR_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function X_LOR_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_X_LOR_BK=DATA.PSL.X_LOR_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_X_LOR_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function X_LOR_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_X_LOR_BK=DATA.PSL.X_LOR_BK;
    PSV_X_LOR_BK=DATA.PSV.X_LOR_BK;
    PSB_X_LOR_BK=DATA.PSB.X_LOR_BK;
    NDPS_X_LOR_BK=DATA.NDPS.X_LOR_BK;

    if (PSL_X_LOR_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_X_LOR_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_X_LOR_BK(1)) ',' num2str(PSB_X_LOR_BK(2)) ',' num2str(NDPS_X_LOR_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function GAM_LOR_FIT_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_GAM_LOR_BK=DATA.PSL.GAM_LOR_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_GAM_LOR_BK==0
        set(hObject,'Value',1)
    else
        set(hObject,'Value',0)
    end
end

end

function GAM_LOR_CON_BK_CreateFcn(hObject,eventdata,handles)

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    PSL_GAM_LOR_BK=DATA.PSL.GAM_LOR_BK;
    
    %*********************
    %Set object properties
    %********************* 
    if PSL_GAM_LOR_BK==0
        set(hObject,'Value',0)
    else
        set(hObject,'Value',1)
    end
end

end

function GAM_LOR_VAL_BK_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSL_GAM_LOR_BK=DATA.PSL.GAM_LOR_BK;
    PSV_GAM_LOR_BK=DATA.PSV.GAM_LOR_BK;
    PSB_GAM_LOR_BK=DATA.PSB.GAM_LOR_BK;
    NDPS_GAM_LOR_BK=DATA.NDPS.GAM_LOR_BK;

    if (PSL_GAM_LOR_BK==1)    
        %****************
        %Set object value
        %****************
        set(hObject,'String',PSV_GAM_LOR_BK);
    else
        %*******************
        %Assign object value
        %*******************
        VALUE=[num2str(PSB_GAM_LOR_BK(1)) ',' num2str(PSB_GAM_LOR_BK(2)) ',' num2str(NDPS_GAM_LOR_BK)];
        
        %****************
        %Set object value
        %****************
        set(hObject,'String',VALUE);  
    end
end

end

function HS_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSB_INS_HS=DATA.PSB_INS.HS;
    NDPS_INS_HS=DATA.NDPS_INS.HS;

    %*******************
    %Assign object value
    %*******************
    VALUE=[num2str(PSB_INS_HS(1)) ',' num2str(PSB_INS_HS(2)) ',' num2str(NDPS_INS_HS)];

    %****************
    %Set object value
    %****************
    set(hObject,'String',VALUE);  
end

end

function VS_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (isempty(handles)==0)
    %************
    %Assign input
    %************
    DATA=handles.DATA;

    PSB_INS_VS=DATA.PSB_INS.VS;
    NDPS_INS_VS=DATA.NDPS_INS.VS;

    %*******************
    %Assign object value
    %*******************
    VALUE=[num2str(PSB_INS_VS(1)) ',' num2str(PSB_INS_VS(2)) ',' num2str(NDPS_INS_VS)];

    %****************
    %Set object value
    %****************
    set(hObject,'String',VALUE);  
end

end

function NI_FIT_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    NI=DATA.NI;
    
    %*********************
    %Set object properties
    %********************* 
    set(hObject,'String',NI)
end

end

function NI_INS_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    NI_INS=DATA.NI_INS;
    
    %*********************
    %Set object properties
    %********************* 
    set(hObject,'String',NI_INS)
end

end

function NAP_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    NAP=DATA.NAP;
    
    %*********************
    %Set object properties
    %********************* 
    set(hObject,'String',NAP)
end

end

function NS_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if isempty(handles)==0
    %************
    %Assign input
    %************ 
    DATA=handles.DATA;

    NS=DATA.NS;
    
    %*********************
    %Set object properties
    %********************* 
    set(hObject,'String',NS)
end

end

function FILE_NAME_CreateFcn(hObject,eventdata,handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%     INITIALIZATION OF OBJECTS      %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%      EXECUTION OF OBJECTS      %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ATOM_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;
S=handles.S;
PQN=handles.PQN;

LINE=DATA.LINE;

%****************
%Get object value
%****************
VALUE=get(hObject,'Value');
LIST=get(hObject,'String');

if strcmpi(LINE{1},LIST{VALUE})==0
    %***********
    %Update atom
    %***********
    LINE{1}=LIST{VALUE};
    LINE{2}=0;
    LINE{3}=[0,0];

    %****************
    %Update ni_fit and ni
    %****************
    LIST=[{''},S.(LINE{1})];

    set(handles.SPIN,'String',LIST)
    set(handles.SPIN,'Value',1)
    
    %****************
    %Update ni_fit and ni
    %****************
    LIST=[{''},PQN.(LINE{1})];
    
    set(handles.NF,'String',LIST)
    set(handles.NF,'Value',1)
    set(handles.NI,'String',LIST)
    set(handles.NI,'Value',1)
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.LINE=LINE;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
end

end

function NF_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

LINE=DATA.LINE;

%****************
%Get object value
%****************
VALUE=get(hObject,'Value');
LIST=get(hObject,'String');

if (LINE{3}(1)~=str2double(LIST{VALUE}))
    %***********
    %Update atom
    %***********
    LINE{3}(1)=str2double(LIST{VALUE});
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.LINE=LINE;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
end

end

function NI_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

LINE=DATA.LINE;

%****************
%Get object value
%****************
VALUE=get(hObject,'Value');
LIST=get(hObject,'String');

if (LINE{3}(2)~=str2double(LIST{VALUE}))
    %***********
    %Update atom
    %***********
    LINE{3}(2)=str2double(LIST{VALUE});
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.LINE=LINE;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
end

end

function SPIN_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

LINE=DATA.LINE;

%****************
%Get object value
%****************
VALUE=get(hObject,'Value');
LIST=get(hObject,'String');

if (LINE{2}~=str2double(LIST{VALUE}))
    %***********
    %Update atom
    %***********
    LINE{2}=str2double(LIST{VALUE});
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.LINE=LINE;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
end

end

function PHI_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_PHI=DATA.PSL.PHI;

if (PSL_PHI==1)
    %****************
    %Set object value
    %****************
    set(handles.PHI_CON,'Value',0)
    set(handles.PHI_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_PHI=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.PHI=PSL_PHI;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function PHI_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_PHI=DATA.PSL.PHI;

if (PSL_PHI==0)
    %****************
    %Set object value
    %****************
    set(handles.PHI_FIT,'Value',0)
    set(handles.PHI_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_PHI=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.PHI=PSL_PHI;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function PHI_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_PHI=DATA.PSL.PHI;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_PHI==1)    
    %***********
    %Update PSV
    %***********
    PSV_PHI=str2double(VALUE);

    if (isnan(PSV_PHI)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.PHI=PSV_PHI;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_PHI(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_PHI(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_PHI=str2double(VALUE(jj:ii));

        if (isnan([PSB_PHI NDPS_PHI])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.PHI=PSB_PHI;
            DATA.NDPS.PHI=NDPS_PHI;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function THETA_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_THETA=DATA.PSL.THETA;

if (PSL_THETA==1)
    %****************
    %Set object value
    %****************
    set(handles.THETA_CON,'Value',0)
    set(handles.THETA_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_THETA=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.THETA=PSL_THETA;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function THETA_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_THETA=DATA.PSL.THETA;

if (PSL_THETA==0)
    %****************
    %Set object value
    %****************
    set(handles.THETA_FIT,'Value',0)
    set(handles.THETA_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_THETA=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.THETA=PSL_THETA;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function THETA_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_THETA=DATA.PSL.THETA;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_THETA==1)    
    %***********
    %Update PSV
    %***********
    PSV_THETA=str2double(VALUE);

    if (isnan(PSV_THETA)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.THETA=PSV_THETA;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_THETA(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_THETA(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_THETA=str2double(VALUE(jj:ii));

        if (isnan([PSB_THETA NDPS_THETA])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.THETA=PSB_THETA;
            DATA.NDPS.THETA=NDPS_THETA;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end   
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function SIGMA_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_SIGMA=DATA.PSL.SIGMA;

if (PSL_SIGMA==1)
    %****************
    %Set object value
    %****************
    set(handles.SIGMA_CON,'Value',0)
    set(handles.SIGMA_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_SIGMA=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.SIGMA=PSL_SIGMA;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function SIGMA_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_SIGMA=DATA.PSL.SIGMA;

if (PSL_SIGMA==0)
    %****************
    %Set object value
    %****************
    set(handles.SIGMA_FIT,'Value',0)
    set(handles.SIGMA_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_SIGMA=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.SIGMA=PSL_SIGMA;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function SIGMA_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_SIGMA=DATA.PSL.SIGMA;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_SIGMA==1)    
    %***********
    %Update PSV
    %***********
    PSV_SIGMA=str2double(VALUE);

    if (isnan(PSV_SIGMA)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.SIGMA=PSV_SIGMA;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_SIGMA(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_SIGMA(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_SIGMA=str2double(VALUE(jj:ii));

        if (isnan([PSB_SIGMA NDPS_SIGMA])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.SIGMA=PSB_SIGMA;
            DATA.NDPS.SIGMA=NDPS_SIGMA;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function T1_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T1=DATA.PSL.T1;

if (PSL_T1==1)
    %****************
    %Set object value
    %****************
    set(handles.T1_CON,'Value',0)
    set(handles.T1_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_T1=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.T1=PSL_T1;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function T1_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T1=DATA.PSL.T1;

if (PSL_T1==0)
    %****************
    %Set object value
    %****************
    set(handles.T1_FIT,'Value',0)
    set(handles.T1_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_T1=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.T1=PSL_T1;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function T1_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T1=DATA.PSL.T1;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_T1==1)    
    %***********
    %Update PSV
    %***********
    PSV_T1=str2double(VALUE);

    if (isnan(PSV_T1)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.T1=PSV_T1;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_T1(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_T1(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_T1=str2double(VALUE(jj:ii));

        if (isnan([PSB_T1 NDPS_T1])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.T1=PSB_T1;
            DATA.NDPS.T1=NDPS_T1;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end     
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function T2_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T2=DATA.PSL.T2;

if (PSL_T2==1)
    %****************
    %Set object value
    %****************
    set(handles.T2_CON,'Value',0)
    set(handles.T2_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_T2=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.T2=PSL_T2;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function T2_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T2=DATA.PSL.T2;

if (PSL_T2==0)
    %****************
    %Set object value
    %****************
    set(handles.T2_FIT,'Value',0)
    set(handles.T2_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_T2=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.T2=PSL_T2;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function T2_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T2=DATA.PSL.T2;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_T2==1)    
    %***********
    %Update PSV
    %***********
    PSV_T2=str2double(VALUE);

    if (isnan(PSV_T2)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.T2=PSV_T2;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_T2(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_T2(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_T2=str2double(VALUE(jj:ii));

        if (isnan([PSB_T2 NDPS_T2])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.T2=PSB_T2;
            DATA.NDPS.T2=NDPS_T2;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function B_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_B_Z=DATA.PSL.B_Z;

if (PSL_B_Z==1)
    %****************
    %Set object value
    %****************
    set(handles.B_CON,'Value',0)
    set(handles.B_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_B_Z=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.B_Z=PSL_B_Z;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function B_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_B_Z=DATA.PSL.B_Z;

if (PSL_B_Z==0)
    %****************
    %Set object value
    %****************
    set(handles.B_FIT,'Value',0)
    set(handles.B_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_B_Z=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.B_Z=PSL_B_Z;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function B_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_B_Z=DATA.PSL.B_Z;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_B_Z==1)    
    %***********
    %Update PSV
    %***********
    PSV_B_Z=str2double(VALUE);

    if (isnan(PSV_B_Z)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.B_Z=PSV_B_Z;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_B_Z(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_B_Z(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_B_Z=str2double(VALUE(jj:ii));

        if (isnan([PSB_B_Z NDPS_B_Z])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.B_Z=PSB_B_Z;
            DATA.NDPS.B_Z=NDPS_B_Z;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end   
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function EDC_X_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_EDC_X=DATA.PSL.EDC_X;

if (PSL_EDC_X==1)
    %****************
    %Set object value
    %****************
    set(handles.EDC_X_CON,'Value',0)
    set(handles.EDC_X_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_EDC_X=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.EDC_X=PSL_EDC_X;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function EDC_X_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_EDC_X=DATA.PSL.EDC_X;

if (PSL_EDC_X==0)
    %****************
    %Set object value
    %****************
    set(handles.EDC_X_FIT,'Value',0)
    set(handles.EDC_X_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_EDC_X=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.EDC_X=PSL_EDC_X;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function EDC_X_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_EDC_X=DATA.PSL.EDC_X;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_EDC_X==1)    
    %***********
    %Update PSV
    %***********
    PSV_EDC_X=str2double(VALUE);

    if (isnan(PSV_EDC_X)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.EDC_X=PSV_EDC_X;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_EDC_X(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_EDC_X(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_EDC_X=str2double(VALUE(jj:ii));

        if (isnan([PSB_EDC_X NDPS_EDC_X])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.EDC_X=PSB_EDC_X;
            DATA.NDPS.EDC_X=NDPS_EDC_X;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function EDC_Y_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_EDC_Y=DATA.PSL.EDC_Y;

if (PSL_EDC_Y==1)
    %****************
    %Set object value
    %****************
    set(handles.EDC_Y_CON,'Value',0)
    set(handles.EDC_Y_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_EDC_Y=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.EDC_Y=PSL_EDC_Y;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function EDC_Y_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_EDC_Y=DATA.PSL.EDC_Y;

if (PSL_EDC_Y==0)
    %****************
    %Set object value
    %****************
    set(handles.EDC_Y_FIT,'Value',0)
    set(handles.EDC_Y_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_EDC_Y=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.EDC_Y=PSL_EDC_Y;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function EDC_Y_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_EDC_Y=DATA.PSL.EDC_Y;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_EDC_Y==1)    
    %***********
    %Update PSV
    %***********
    PSV_EDC_Y=str2double(VALUE);

    if (isnan(PSV_EDC_Y)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.EDC_Y=PSV_EDC_Y;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_EDC_Y(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_EDC_Y(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_EDC_Y=str2double(VALUE(jj:ii));

        if (isnan([PSB_EDC_Y NDPS_EDC_Y])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.EDC_Y=PSB_EDC_Y;
            DATA.NDPS.EDC_Y=NDPS_EDC_Y;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end     
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function EDC_Z_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_EDC_Z=DATA.PSL.EDC_Z;

if (PSL_EDC_Z==1)
    %****************
    %Set object value
    %****************
    set(handles.EDC_Z_CON,'Value',0)
    set(handles.EDC_Z_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_EDC_Z=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.EDC_Z=PSL_EDC_Z;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function EDC_Z_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_EDC_Z=DATA.PSL.EDC_Z;

if (PSL_EDC_Z==0)
    %****************
    %Set object value
    %****************
    set(handles.EDC_Z_FIT,'Value',0)
    set(handles.EDC_Z_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_EDC_Z=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.EDC_Z=PSL_EDC_Z;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function EDC_Z_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_EDC_Z=DATA.PSL.EDC_Z;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_EDC_Z==1)    
    %***********
    %Update PSV
    %***********
    PSV_EDC_Z=str2double(VALUE);

    if (isnan(PSV_EDC_Z)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.EDC_Z=PSV_EDC_Z;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_EDC_Z(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_EDC_Z(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_EDC_Z=str2double(VALUE(jj:ii));

        if (isnan([PSB_EDC_Z NDPS_EDC_Z])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.EDC_Z=PSB_EDC_Z;
            DATA.NDPS.EDC_Z=NDPS_EDC_Z;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function ERF_X_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_ERF_X=DATA.PSL.ERF_X;

if (PSL_ERF_X==1)
    %****************
    %Set object value
    %****************
    set(handles.ERF_X_CON,'Value',0)
    set(handles.ERF_X_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_ERF_X=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.ERF_X=PSL_ERF_X;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function ERF_X_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_ERF_X=DATA.PSL.ERF_X;

if (PSL_ERF_X==0)
    %****************
    %Set object value
    %****************
    set(handles.ERF_X_FIT,'Value',0)
    set(handles.ERF_X_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_ERF_X=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.ERF_X=PSL_ERF_X;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function ERF_X_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_ERF_X=DATA.PSL.ERF_X;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_ERF_X==1)    
    %***********
    %Update PSV
    %***********
    PSV_ERF_X=str2double(VALUE);

    if (isnan(PSV_ERF_X)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.ERF_X=PSV_ERF_X;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_ERF_X(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_ERF_X(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_ERF_X=str2double(VALUE(jj:ii));

        if (isnan([PSB_ERF_X NDPS_ERF_X])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.ERF_X=PSB_ERF_X;
            DATA.NDPS.ERF_X=NDPS_ERF_X;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end   
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function ERF_Y_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_ERF_Y=DATA.PSL.ERF_Y;

if (PSL_ERF_Y==1)
    %****************
    %Set object value
    %****************
    set(handles.ERF_Y_CON,'Value',0)
    set(handles.ERF_Y_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_ERF_Y=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.ERF_Y=PSL_ERF_Y;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function ERF_Y_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_ERF_Y=DATA.PSL.ERF_Y;

if (PSL_ERF_Y==0)
    %****************
    %Set object value
    %****************
    set(handles.ERF_Y_FIT,'Value',0)
    set(handles.ERF_Y_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_ERF_Y=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.ERF_Y=PSL_ERF_Y;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function ERF_Y_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_ERF_Y=DATA.PSL.ERF_Y;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_ERF_Y==1)    
    %***********
    %Update PSV
    %***********
    PSV_ERF_Y=str2double(VALUE);

    if (isnan(PSV_ERF_Y)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.ERF_Y=PSV_ERF_Y;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_ERF_Y(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_ERF_Y(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_ERF_Y=str2double(VALUE(jj:ii));

        if (isnan([PSB_ERF_Y NDPS_ERF_Y])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.ERF_Y=PSB_ERF_Y;
            DATA.NDPS.ERF_Y=NDPS_ERF_Y;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end      
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function ERF_Z_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_ERF_Z=DATA.PSL.ERF_Z;

if (PSL_ERF_Z==1)
    %****************
    %Set object value
    %****************
    set(handles.ERF_Z_CON,'Value',0)
    set(handles.ERF_Z_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_ERF_Z=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.ERF_Z=PSL_ERF_Z;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function ERF_Z_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_ERF_Z=DATA.PSL.ERF_Z;

if (PSL_ERF_Z==0)
    %****************
    %Set object value
    %****************
    set(handles.ERF_Z_FIT,'Value',0)
    set(handles.ERF_Z_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_ERF_Z=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.ERF_Z=PSL_ERF_Z;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function ERF_Z_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_ERF_Z=DATA.PSL.ERF_Z;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_ERF_Z==1)    
    %***********
    %Update PSV
    %***********
    PSV_ERF_Z=str2double(VALUE);

    if (isnan(PSV_ERF_Z)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.ERF_Z=PSV_ERF_Z;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_ERF_Z(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_ERF_Z(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_ERF_Z=str2double(VALUE(jj:ii));

        if (isnan([PSB_ERF_Z NDPS_ERF_Z])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.ERF_Z=PSB_ERF_Z;
            DATA.NDPS.ERF_Z=NDPS_ERF_Z;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end     
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function I_1_GAU_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_1_GAU=DATA.PSL.I_1_GAU;

if (PSL_I_1_GAU==1)
    %****************
    %Set object value
    %****************
    set(handles.I_1_GAU_CON,'Value',0)
    set(handles.I_1_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_1_GAU=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_1_GAU=PSL_I_1_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_1_GAU_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_1_GAU=DATA.PSL.I_1_GAU;

if (PSL_I_1_GAU==0)
    %****************
    %Set object value
    %****************
    set(handles.I_1_GAU_FIT,'Value',0)
    set(handles.I_1_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_1_GAU=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_1_GAU=PSL_I_1_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_1_GAU_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_1_GAU=DATA.PSL.I_1_GAU;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_I_1_GAU==1)    
    %***********
    %Update PSV
    %***********
    PSV_I_1_GAU=str2double(VALUE);
    
    if (isnan(PSV_I_1_GAU)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.I_1_GAU=PSV_I_1_GAU;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_I_1_GAU(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_I_1_GAU(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_I_1_GAU=str2double(VALUE(jj:ii));

        if (isnan([PSB_I_1_GAU NDPS_I_1_GAU])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.I_1_GAU=PSB_I_1_GAU;
            DATA.NDPS.I_1_GAU=NDPS_I_1_GAU;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end      
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function X_1_GAU_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_1_GAU=DATA.PSL.X_1_GAU;

if (PSL_X_1_GAU==1)
    %****************
    %Set object value
    %****************
    set(handles.X_1_GAU_CON,'Value',0)
    set(handles.X_1_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_1_GAU=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_1_GAU=PSL_X_1_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_1_GAU_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_1_GAU=DATA.PSL.X_1_GAU;

if (PSL_X_1_GAU==0)
    %****************
    %Set object value
    %****************
    set(handles.X_1_GAU_FIT,'Value',0)
    set(handles.X_1_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_1_GAU=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_1_GAU=PSL_X_1_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_1_GAU_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_1_GAU=DATA.PSL.X_1_GAU;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_X_1_GAU==1)    
    %***********
    %Update PSV
    %***********
    PSV_X_1_GAU=str2double(VALUE);

    if (isnan(PSV_X_1_GAU)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.X_1_GAU=PSV_X_1_GAU;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_X_1_GAU(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_X_1_GAU(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_X_1_GAU=str2double(VALUE(jj:ii));

        if (isnan([PSB_X_1_GAU NDPS_X_1_GAU])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.X_1_GAU=PSB_X_1_GAU;
            DATA.NDPS.X_1_GAU=NDPS_X_1_GAU;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end     
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function KT_1_GAU_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_1_GAU=DATA.PSL.KT_1_GAU;

if (PSL_KT_1_GAU==1)
    %****************
    %Set object value
    %****************
    set(handles.KT_1_GAU_CON,'Value',0)
    set(handles.KT_1_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_KT_1_GAU=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.KT_1_GAU=PSL_KT_1_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function KT_1_GAU_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_1_GAU=DATA.PSL.KT_1_GAU;

if (PSL_KT_1_GAU==0)
    %****************
    %Set object value
    %****************
    set(handles.KT_1_GAU_FIT,'Value',0)
    set(handles.KT_1_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_KT_1_GAU=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.KT_1_GAU=PSL_KT_1_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function KT_1_GAU_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_1_GAU=DATA.PSL.KT_1_GAU;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_KT_1_GAU==1)    
    %***********
    %Update PSV
    %***********
    PSV_KT_1_GAU=str2double(VALUE);

    if (isnan(PSV_KT_1_GAU)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.KT_1_GAU=PSV_KT_1_GAU;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_KT_1_GAU(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_KT_1_GAU(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_KT_1_GAU=str2double(VALUE(jj:ii));

        if (isnan([PSB_KT_1_GAU NDPS_KT_1_GAU])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.KT_1_GAU=PSB_KT_1_GAU;
            DATA.NDPS.KT_1_GAU=NDPS_KT_1_GAU;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function I_2_GAU_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_2_GAU=DATA.PSL.I_2_GAU;

if (PSL_I_2_GAU==1)
    %****************
    %Set object value
    %****************
    set(handles.I_2_GAU_CON,'Value',0)
    set(handles.I_2_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_2_GAU=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_2_GAU=PSL_I_2_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_2_GAU_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_2_GAU=DATA.PSL.I_2_GAU;

if (PSL_I_2_GAU==0)
    %****************
    %Set object value
    %****************
    set(handles.I_2_GAU_FIT,'Value',0)
    set(handles.I_2_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_2_GAU=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_2_GAU=PSL_I_2_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_2_GAU_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_2_GAU=DATA.PSL.I_2_GAU;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_I_2_GAU==1)    
    %***********
    %Update PSV
    %***********
    PSV_I_2_GAU=str2double(VALUE);

    if (isnan(PSV_I_2_GAU)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.I_2_GAU=PSV_I_2_GAU;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_I_2_GAU(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_I_2_GAU(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_I_2_GAU=str2double(VALUE(jj:ii));

        if (isnan([PSB_I_2_GAU NDPS_I_2_GAU])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.I_2_GAU=PSB_I_2_GAU;
            DATA.NDPS.I_2_GAU=NDPS_I_2_GAU;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end     
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function X_2_GAU_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_2_GAU=DATA.PSL.X_2_GAU;

if (PSL_X_2_GAU==1)
    %****************
    %Set object value
    %****************
    set(handles.X_2_GAU_CON,'Value',0)
    set(handles.X_2_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_2_GAU=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_2_GAU=PSL_X_2_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_2_GAU_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_2_GAU=DATA.PSL.X_2_GAU;

if (PSL_X_2_GAU==0)
    %****************
    %Set object value
    %****************
    set(handles.X_2_GAU_FIT,'Value',0)
    set(handles.X_2_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_2_GAU=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_2_GAU=PSL_X_2_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_2_GAU_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_2_GAU=DATA.PSL.X_2_GAU;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_X_2_GAU==1)    
    %***********
    %Update PSV
    %***********
    PSV_X_2_GAU=str2double(VALUE);

    if (isnan(PSV_X_2_GAU)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.X_2_GAU=PSV_X_2_GAU;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_X_2_GAU(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_X_2_GAU(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_X_2_GAU=str2double(VALUE(jj:ii));

        if (isnan([PSB_X_2_GAU NDPS_X_2_GAU])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.X_2_GAU=PSB_X_2_GAU;
            DATA.NDPS.X_2_GAU=NDPS_X_2_GAU;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end     
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function KT_2_GAU_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_2_GAU=DATA.PSL.KT_2_GAU;

if (PSL_KT_2_GAU==1)
    %****************
    %Set object value
    %****************
    set(handles.KT_2_GAU_CON,'Value',0)
    set(handles.KT_2_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_KT_2_GAU=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.KT_2_GAU=PSL_KT_2_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function KT_2_GAU_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_2_GAU=DATA.PSL.KT_2_GAU;

if (PSL_KT_2_GAU==0)
    %****************
    %Set object value
    %****************
    set(handles.KT_2_GAU_FIT,'Value',0)
    set(handles.KT_2_GAU_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_KT_2_GAU=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.KT_2_GAU=PSL_KT_2_GAU;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function KT_2_GAU_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_2_GAU=DATA.PSL.KT_2_GAU;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_KT_2_GAU==1)    
    %***********
    %Update PSV
    %***********
    PSV_KT_2_GAU=str2double(VALUE);

    if (isnan(PSV_KT_2_GAU)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.KT_2_GAU=PSV_KT_2_GAU;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_KT_2_GAU(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_KT_2_GAU(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_KT_2_GAU=str2double(VALUE(jj:ii));

        if (isnan([PSB_KT_2_GAU NDPS_KT_2_GAU])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.KT_2_GAU=PSB_KT_2_GAU;
            DATA.NDPS.KT_2_GAU=NDPS_KT_2_GAU;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end     
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function I_LOR_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_LOR=DATA.PSL.I_LOR;

if (PSL_I_LOR==1)
    %****************
    %Set object value
    %****************
    set(handles.I_LOR_CON,'Value',0)
    set(handles.I_LOR_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_LOR=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_LOR=PSL_I_LOR;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_LOR_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_LOR=DATA.PSL.I_LOR;

if (PSL_I_LOR==0)
    %****************
    %Set object value
    %****************
    set(handles.I_LOR_FIT,'Value',0)
    set(handles.I_LOR_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_LOR=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_LOR=PSL_I_LOR;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_LOR_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_LOR=DATA.PSL.I_LOR;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_I_LOR==1)    
    %***********
    %Update PSV
    %***********
    PSV_I_LOR=str2double(VALUE);

    if (isnan(PSV_I_LOR)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.I_LOR=PSV_I_LOR;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_I_LOR(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_I_LOR(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_I_LOR=str2double(VALUE(jj:ii));

        if (isnan([PSB_I_LOR NDPS_I_LOR])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.I_LOR=PSB_I_LOR;
            DATA.NDPS.I_LOR=NDPS_I_LOR;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end      
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function X_LOR_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_LOR=DATA.PSL.X_LOR;

if (PSL_X_LOR==1)
    %****************
    %Set object value
    %****************
    set(handles.X_LOR_CON,'Value',0)
    set(handles.X_LOR_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_LOR=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_LOR=PSL_X_LOR;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_LOR_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_LOR=DATA.PSL.X_LOR;

if (PSL_X_LOR==0)
    %****************
    %Set object value
    %****************
    set(handles.X_LOR_FIT,'Value',0)
    set(handles.X_LOR_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_LOR=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_LOR=PSL_X_LOR;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_LOR_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_LOR=DATA.PSL.X_LOR;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_X_LOR==1)    
    %***********
    %Update PSV
    %***********
    PSV_X_LOR=str2double(VALUE);

    if (isnan(PSV_X_LOR)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.X_LOR=PSV_X_LOR;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_X_LOR(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_X_LOR(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_X_LOR=str2double(VALUE(jj:ii));

        if (isnan([PSB_X_LOR NDPS_X_LOR])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.X_LOR=PSB_X_LOR;
            DATA.NDPS.X_LOR=NDPS_X_LOR;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end   
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function GAM_LOR_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_GAM_LOR=DATA.PSL.GAM_LOR;

if (PSL_GAM_LOR==1)
    %****************
    %Set object value
    %****************
    set(handles.GAM_LOR_CON,'Value',0)
    set(handles.GAM_LOR_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_GAM_LOR=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.GAM_LOR=PSL_GAM_LOR;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function GAM_LOR_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_GAM_LOR=DATA.PSL.GAM_LOR;

if (PSL_GAM_LOR==0)
    %****************
    %Set object value
    %****************
    set(handles.GAM_LOR_FIT,'Value',0)
    set(handles.GAM_LOR_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_GAM_LOR=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.GAM_LOR=PSL_GAM_LOR;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function GAM_LOR_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_GAM_LOR=DATA.PSL.GAM_LOR;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_GAM_LOR==1)    
    %***********
    %Update PSV
    %***********
    PSV_GAM_LOR=str2double(VALUE);

    if (isnan(PSV_GAM_LOR)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.GAM_LOR=PSV_GAM_LOR;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_GAM_LOR(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_GAM_LOR(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_GAM_LOR=str2double(VALUE(jj:ii));

        if (isnan([PSB_GAM_LOR NDPS_GAM_LOR])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.GAM_LOR=PSB_GAM_LOR;
            DATA.NDPS.GAM_LOR=NDPS_GAM_LOR;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end     
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function IB_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_IB=DATA.PSL.IB;

if (PSL_IB==1)
    %****************
    %Set object value
    %****************
    set(handles.IB_CON,'Value',0)
    set(handles.IB_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_IB=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.IB=PSL_IB;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function IB_CON_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_IB=DATA.PSL.IB;

if (PSL_IB==0)
    %****************
    %Set object value
    %****************
    set(handles.IB_FIT,'Value',0)
    set(handles.IB_VAL,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_IB=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.IB=PSL_IB;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function IB_VAL_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_IB=DATA.PSL.IB;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_IB==1)    
    %***********
    %Update PSV
    %***********
    PSV_IB=str2double(VALUE);

    if (isnan(PSV_IB)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.IB=PSV_IB;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_IB(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_IB(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_IB=str2double(VALUE(jj:ii));

        if (isnan([PSB_IB NDPS_IB])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.IB=PSB_IB;
            DATA.NDPS.IB=NDPS_IB;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function ATOM_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;
S=handles.S;
PQN=handles.PQN;

LINE_BK=DATA.LINE_BK;

%****************
%Get object value
%****************
VALUE=get(hObject,'Value');
LIST=get(hObject,'String');

if strcmpi(LINE_BK{1},LIST{VALUE})==0
    %***********
    %Update atom
    %***********
    LINE_BK{1}=LIST{VALUE};
    LINE_BK{2}=0;
    LINE_BK{3}=[0,0];

    %****************
    %Update ni_fit and ni
    %****************
    LIST=[{''},S.(LINE_BK{1})];

    set(handles.SPIN_BK,'String',LIST)
    set(handles.SPIN_BK,'Value',1)
    
    %****************
    %Update ni_fit and ni
    %****************
    LIST=[{''},PQN.(LINE_BK{1})];
    
    set(handles.NI_BK,'String',LIST)
    set(handles.NI_BK,'Value',1)
    set(handles.NI_BK,'String',LIST)
    set(handles.NI_BK,'Value',1)
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.LINE_BK=LINE_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
end

end

function NF_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

LINE_BK=DATA.LINE_BK;

%****************
%Get object value
%****************
VALUE=get(hObject,'Value');
LIST=get(hObject,'String');

if (LINE_BK{3}(1)~=str2double(LIST{VALUE}))
    %***********
    %Update atom
    %***********
    LINE_BK{3}(1)=str2double(LIST{VALUE});
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.LINE_BK=LINE_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
end

end

function NI_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

LINE_BK=DATA.LINE_BK;

%****************
%Get object value
%****************
VALUE=get(hObject,'Value');
LIST=get(hObject,'String');

if (LINE_BK{3}(2)~=str2double(LIST{VALUE}))
    %***********
    %Update atom
    %***********
    LINE_BK{3}(2)=str2double(LIST{VALUE});
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.LINE_BK=LINE_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
end

end

function SPIN_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

LINE_BK=DATA.LINE_BK;

%****************
%Get object value
%****************
VALUE=get(hObject,'Value');
LIST=get(hObject,'String');

if (LINE_BK{2}~=str2double(LIST{VALUE}))
    %***********
    %Update atom
    %***********
    LINE_BK{2}=str2double(LIST{VALUE});
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.LINE_BK=LINE_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
end

end

function PHI_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_PHI_BK=DATA.PSL.PHI_BK;

if (PSL_PHI_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.PHI_CON_BK,'Value',0)
    set(handles.PHI_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_PHI_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.PHI_BK=PSL_PHI_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function PHI_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_PHI_BK=DATA.PSL.PHI_BK;

if (PSL_PHI_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.PHI_FIT_BK,'Value',0)
    set(handles.PHI_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_PHI_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.PHI_BK=PSL_PHI_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function PHI_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_PHI_BK=DATA.PSL.PHI_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_PHI_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_PHI_BK=str2double(VALUE);

    if (isnan(PSV_PHI_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.PHI_BK=PSV_PHI_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_PHI_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_PHI_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_PHI_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_PHI_BK NDPS_PHI_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.PHI_BK=PSB_PHI_BK;
            DATA.NDPS.PHI_BK=NDPS_PHI_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end     
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function THETA_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_THETA_BK=DATA.PSL.THETA_BK;

if (PSL_THETA_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.THETA_CON_BK,'Value',0)
    set(handles.THETA_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_THETA_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.THETA_BK=PSL_THETA_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function THETA_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_THETA_BK=DATA.PSL.THETA_BK;

if (PSL_THETA_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.THETA_FIT_BK,'Value',0)
    set(handles.THETA_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_THETA_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.THETA_BK=PSL_THETA_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function THETA_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_THETA_BK=DATA.PSL.THETA_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_THETA_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_THETA_BK=str2double(VALUE);

    if (isnan(PSV_THETA_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.THETA_BK=PSV_THETA_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_THETA_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_THETA_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_THETA_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_THETA_BK NDPS_THETA_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.THETA_BK=PSB_THETA_BK;
            DATA.NDPS.THETA_BK=NDPS_THETA_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function SIGMA_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_SIGMA_BK=DATA.PSL.SIGMA_BK;

if (PSL_SIGMA_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.SIGMA_CON_BK,'Value',0)
    set(handles.SIGMA_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_SIGMA_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.SIGMA_BK=PSL_SIGMA_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function SIGMA_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_SIGMA_BK=DATA.PSL.SIGMA_BK;

if (PSL_SIGMA_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.SIGMA_FIT_BK,'Value',0)
    set(handles.SIGMA_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_SIGMA_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.SIGMA_BK=PSL_SIGMA_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function SIGMA_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_SIGMA_BK=DATA.PSL.SIGMA_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_SIGMA_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_SIGMA_BK=str2double(VALUE);

    if (isnan(PSV_SIGMA_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.SIGMA_BK=PSV_SIGMA_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_SIGMA_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_SIGMA_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_SIGMA_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_SIGMA_BK NDPS_SIGMA_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.SIGMA_BK=PSB_SIGMA_BK;
            DATA.NDPS.SIGMA_BK=NDPS_SIGMA_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function T1_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T1_BK=DATA.PSL.T1_BK;

if (PSL_T1_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.T1_CON_BK,'Value',0)
    set(handles.T1_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_T1_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.T1_BK=PSL_T1_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function T1_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T1_BK=DATA.PSL.T1_BK;

if (PSL_T1_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.T1_FIT_BK,'Value',0)
    set(handles.T1_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_T1_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.T1_BK=PSL_T1_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function T1_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T1_BK=DATA.PSL.T1_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_T1_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_T1_BK=str2double(VALUE);

    if (isnan(PSV_T1_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.T1_BK=PSV_T1_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_T1_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_T1_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_T1_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_T1_BK NDPS_T1_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.T1_BK=PSB_T1_BK;
            DATA.NDPS.T1_BK=NDPS_T1_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function T2_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T2_BK=DATA.PSL.T2_BK;

if (PSL_T2_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.T2_CON_BK,'Value',0)
    set(handles.T2_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_T2_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.T2_BK=PSL_T2_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function T2_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T2_BK=DATA.PSL.T2_BK;

if (PSL_T2_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.T2_FIT_BK,'Value',0)
    set(handles.T2_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_T2_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.T2_BK=PSL_T2_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function T2_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_T2_BK=DATA.PSL.T2_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_T2_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_T2_BK=str2double(VALUE);

    if (isnan(PSV_T2_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.T2_BK=PSV_T2_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_T2_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_T2_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_T2_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_T2_BK NDPS_T2_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.T2_BK=PSB_T2_BK;
            DATA.NDPS.T2_BK=NDPS_T2_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end     
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function B_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_B_Z_BK=DATA.PSL.B_Z_BK;

if (PSL_B_Z_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.B_CON_BK,'Value',0)
    set(handles.B_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_B_Z_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.B_Z_BK=PSL_B_Z_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function B_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_B_Z_BK=DATA.PSL.B_Z_BK;

if (PSL_B_Z_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.B_FIT_BK,'Value',0)
    set(handles.B_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_B_Z_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.B_Z_BK=PSL_B_Z_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function B_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_B_Z_BK=DATA.PSL.B_Z_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_B_Z_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_B_Z_BK=str2double(VALUE);

    if (isnan(PSV_B_Z_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.B_Z_BK=PSV_B_Z_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_B_Z_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_B_Z_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_B_Z_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_B_Z_BK NDPS_B_Z_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.B_Z_BK=PSB_B_Z_BK;
            DATA.NDPS.B_Z_BK=NDPS_B_Z_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end     
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function I_1_GAU_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_1_GAU_BK=DATA.PSL.I_1_GAU_BK;

if (PSL_I_1_GAU_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.I_1_GAU_CON_BK,'Value',0)
    set(handles.I_1_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_1_GAU_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_1_GAU_BK=PSL_I_1_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_1_GAU_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_1_GAU_BK=DATA.PSL.I_1_GAU_BK;

if (PSL_I_1_GAU_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.I_1_GAU_FIT_BK,'Value',0)
    set(handles.I_1_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_1_GAU_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_1_GAU_BK=PSL_I_1_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_1_GAU_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_1_GAU_BK=DATA.PSL.I_1_GAU_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_I_1_GAU_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_I_1_GAU_BK=str2double(VALUE);

    if (isnan(PSV_I_1_GAU_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.I_1_GAU_BK=PSV_I_1_GAU_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_I_1_GAU_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_I_1_GAU_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_I_1_GAU_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_I_1_GAU_BK NDPS_I_1_GAU_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.I_1_GAU_BK=PSB_I_1_GAU_BK;
            DATA.NDPS.I_1_GAU_BK=NDPS_I_1_GAU_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function X_1_GAU_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_1_GAU_BK=DATA.PSL.X_1_GAU_BK;

if (PSL_X_1_GAU_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.X_1_GAU_CON_BK,'Value',0)
    set(handles.X_1_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_1_GAU_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_1_GAU_BK=PSL_X_1_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_1_GAU_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_1_GAU_BK=DATA.PSL.X_1_GAU_BK;

if (PSL_X_1_GAU_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.X_1_GAU_FIT_BK,'Value',0)
    set(handles.X_1_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_1_GAU_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_1_GAU_BK=PSL_X_1_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_1_GAU_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_1_GAU_BK=DATA.PSL.X_1_GAU_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_X_1_GAU_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_X_1_GAU_BK=str2double(VALUE);

    if (isnan(PSV_X_1_GAU_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.X_1_GAU_BK=PSV_X_1_GAU_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_X_1_GAU_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_X_1_GAU_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_X_1_GAU_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_X_1_GAU_BK NDPS_X_1_GAU_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.X_1_GAU_BK=PSB_X_1_GAU_BK;
            DATA.NDPS.X_1_GAU_BK=NDPS_X_1_GAU_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function KT_1_GAU_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_1_GAU_BK=DATA.PSL.KT_1_GAU_BK;

if (PSL_KT_1_GAU_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.KT_1_GAU_CON_BK,'Value',0)
    set(handles.KT_1_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_KT_1_GAU_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.KT_1_GAU_BK=PSL_KT_1_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function KT_1_GAU_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_1_GAU_BK=DATA.PSL.KT_1_GAU_BK;

if (PSL_KT_1_GAU_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.KT_1_GAU_FIT_BK,'Value',0)
    set(handles.KT_1_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_KT_1_GAU_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.KT_1_GAU_BK=PSL_KT_1_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function KT_1_GAU_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_1_GAU_BK=DATA.PSL.KT_1_GAU_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_KT_1_GAU_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_KT_1_GAU_BK=str2double(VALUE);

    if (isnan(PSV_KT_1_GAU_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.KT_1_GAU_BK=PSV_KT_1_GAU_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_KT_1_GAU_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_KT_1_GAU_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_KT_1_GAU_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_KT_1_GAU_BK NDPS_KT_1_GAU_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.KT_1_GAU_BK=PSB_KT_1_GAU_BK;
            DATA.NDPS.KT_1_GAU_BK=NDPS_KT_1_GAU_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end      
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function I_2_GAU_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_2_GAU_BK=DATA.PSL.I_2_GAU_BK;

if (PSL_I_2_GAU_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.I_2_GAU_CON_BK,'Value',0)
    set(handles.I_2_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_2_GAU_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_2_GAU_BK=PSL_I_2_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_2_GAU_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_2_GAU_BK=DATA.PSL.I_2_GAU_BK;

if (PSL_I_2_GAU_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.I_2_GAU_FIT_BK,'Value',0)
    set(handles.I_2_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_2_GAU_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_2_GAU_BK=PSL_I_2_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_2_GAU_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_2_GAU_BK=DATA.PSL.I_2_GAU_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_I_2_GAU_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_I_2_GAU_BK=str2double(VALUE);

    if (isnan(PSV_I_2_GAU_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.I_2_GAU_BK=PSV_I_2_GAU_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_I_2_GAU_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_I_2_GAU_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_I_2_GAU_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_I_2_GAU_BK NDPS_I_2_GAU_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.I_2_GAU_BK=PSB_I_2_GAU_BK;
            DATA.NDPS.I_2_GAU_BK=NDPS_I_2_GAU_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function X_2_GAU_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_2_GAU_BK=DATA.PSL.X_2_GAU_BK;

if (PSL_X_2_GAU_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.X_2_GAU_CON_BK,'Value',0)
    set(handles.X_2_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_2_GAU_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_2_GAU_BK=PSL_X_2_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_2_GAU_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_2_GAU_BK=DATA.PSL.X_2_GAU_BK;

if (PSL_X_2_GAU_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.X_2_GAU_FIT_BK,'Value',0)
    set(handles.X_2_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_2_GAU_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_2_GAU_BK=PSL_X_2_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_2_GAU_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_2_GAU_BK=DATA.PSL.X_2_GAU_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_X_2_GAU_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_X_2_GAU_BK=str2double(VALUE);

    if (isnan(PSV_X_2_GAU_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.X_2_GAU_BK=PSV_X_2_GAU_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_X_2_GAU_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_X_2_GAU_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_X_2_GAU_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_X_2_GAU_BK NDPS_X_2_GAU_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.X_2_GAU_BK=PSB_X_2_GAU_BK;
            DATA.NDPS.X_2_GAU_BK=NDPS_X_2_GAU_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end   
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function KT_2_GAU_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_2_GAU_BK=DATA.PSL.KT_2_GAU_BK;

if (PSL_KT_2_GAU_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.KT_2_GAU_CON_BK,'Value',0)
    set(handles.KT_2_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_KT_2_GAU_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.KT_2_GAU_BK=PSL_KT_2_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function KT_2_GAU_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_2_GAU_BK=DATA.PSL.KT_2_GAU_BK;

if (PSL_KT_2_GAU_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.KT_2_GAU_FIT_BK,'Value',0)
    set(handles.KT_2_GAU_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_KT_2_GAU_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.KT_2_GAU_BK=PSL_KT_2_GAU_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function KT_2_GAU_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_KT_2_GAU_BK=DATA.PSL.KT_2_GAU_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_KT_2_GAU_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_KT_2_GAU_BK=str2double(VALUE);

    HIT=0;
    if (isnan(PSV_KT_2_GAU_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.KT_2_GAU_BK=PSV_KT_2_GAU_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_KT_2_GAU_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_KT_2_GAU_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_KT_2_GAU_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_KT_2_GAU_BK NDPS_KT_2_GAU_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.KT_2_GAU_BK=PSB_KT_2_GAU_BK;
            DATA.NDPS.KT_2_GAU_BK=NDPS_KT_2_GAU_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end  
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function I_LOR_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_LOR_BK=DATA.PSL.I_LOR_BK;

if (PSL_I_LOR_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.I_LOR_CON_BK,'Value',0)
    set(handles.I_LOR_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_LOR_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_LOR_BK=PSL_I_LOR_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_LOR_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_LOR_BK=DATA.PSL.I_LOR_BK;

if (PSL_I_LOR_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.I_LOR_FIT_BK,'Value',0)
    set(handles.I_LOR_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_I_LOR_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.I_LOR_BK=PSL_I_LOR_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function I_LOR_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_I_LOR_BK=DATA.PSL.I_LOR_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_I_LOR_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_I_LOR_BK=str2double(VALUE);

    if (isnan(PSV_I_LOR_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.I_LOR_BK=PSV_I_LOR_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_I_LOR_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_I_LOR_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_I_LOR_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_I_LOR_BK NDPS_I_LOR_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.I_LOR_BK=PSB_I_LOR_BK;
            DATA.NDPS.I_LOR_BK=NDPS_I_LOR_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end    
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function X_LOR_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_LOR_BK=DATA.PSL.X_LOR_BK;

if (PSL_X_LOR_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.X_LOR_CON_BK,'Value',0)
    set(handles.X_LOR_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_LOR_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_LOR_BK=PSL_X_LOR_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_LOR_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_LOR_BK=DATA.PSL.X_LOR_BK;

if (PSL_X_LOR_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.X_LOR_FIT_BK,'Value',0)
    set(handles.X_LOR_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_X_LOR_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.X_LOR_BK=PSL_X_LOR_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function X_LOR_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_X_LOR_BK=DATA.PSL.X_LOR_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_X_LOR_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_X_LOR_BK=str2double(VALUE);

    if (isnan(PSV_X_LOR_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.X_LOR_BK=PSV_X_LOR_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_X_LOR_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_X_LOR_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_X_LOR_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_X_LOR_BK NDPS_X_LOR_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.X_LOR_BK=PSB_X_LOR_BK;
            DATA.NDPS.X_LOR_BK=NDPS_X_LOR_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end   
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function GAM_LOR_FIT_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_GAM_LOR_BK=DATA.PSL.GAM_LOR_BK;

if (PSL_GAM_LOR_BK==1)
    %****************
    %Set object value
    %****************
    set(handles.GAM_LOR_CON_BK,'Value',0)
    set(handles.GAM_LOR_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_GAM_LOR_BK=0;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.GAM_LOR_BK=PSL_GAM_LOR_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function GAM_LOR_CON_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_GAM_LOR_BK=DATA.PSL.GAM_LOR_BK;

if (PSL_GAM_LOR_BK==0)
    %****************
    %Set object value
    %****************
    set(handles.GAM_LOR_FIT_BK,'Value',0)
    set(handles.GAM_LOR_VAL_BK,'String',[])
    
    %***********
    %Update PSL
    %***********
    PSL_GAM_LOR_BK=1;
    
    %*********************
    %Assign DATA structure
    %*********************
    DATA.PSL.GAM_LOR_BK=PSL_GAM_LOR_BK;
    
    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles);  
else
    %****************
    %Set object value
    %****************
    set(hObject,'Value',1)
end

end

function GAM_LOR_VAL_BK_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

PSL_GAM_LOR_BK=DATA.PSL.GAM_LOR_BK;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

HIT=0;
if (PSL_GAM_LOR_BK==1)    
    %***********
    %Update PSV
    %***********
    PSV_GAM_LOR_BK=str2double(VALUE);

    if (isnan(PSV_GAM_LOR_BK)==0 && isempty(strfind(VALUE,',')==1))
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSV.GAM_LOR_BK=PSV_GAM_LOR_BK;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;
    else
        HIT=1;
    end
else
    jj=0;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            jj=jj+1;
        end
    end
    
    if (jj==2)
        %*******************
        %Update PSB and NDPS
        %*******************
        jj=1;
        kk=1;
        for ii=1:length(VALUE)
            if (strcmpi(VALUE(ii),',')==1)
                if (kk==1)
                    PSB_GAM_LOR_BK(1)=str2double(VALUE(jj:ii-1));
                elseif (kk==2)
                    PSB_GAM_LOR_BK(2)=str2double(VALUE(jj:ii-1));
                end
                jj=ii+1;
                kk=kk+1;                
            end
        end
        NDPS_GAM_LOR_BK=str2double(VALUE(jj:ii));

        if (isnan([PSB_GAM_LOR_BK NDPS_GAM_LOR_BK])==0)
            %*********************
            %Assign DATA structure
            %*********************
            DATA.PSB.GAM_LOR_BK=PSB_GAM_LOR_BK;
            DATA.NDPS.GAM_LOR_BK=NDPS_GAM_LOR_BK;

            %************************
            %Assign handles structure
            %************************  
            handles.DATA=DATA;  
        else
            HIT=1;
        end
    else
        HIT=1;
    end  
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function HS_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

%***************
%Check formating
%***************
jj=0;
for ii=1:length(VALUE)
    if (strcmpi(VALUE(ii),',')==1)
        jj=jj+1;
    end
end

HIT=0;    
if (jj==2)
    %*******************
    %Update PSB and NDPS
    %*******************
    jj=1;
    kk=1;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            if (kk==1)
                PSB_HS(1)=str2double(VALUE(jj:ii-1));
            elseif (kk==2)
                PSB_HS(2)=str2double(VALUE(jj:ii-1));
            end
            jj=ii+1;
            kk=kk+1;                
        end
    end
    NDPS_HS=str2double(VALUE(jj:ii));

    if (isnan([PSB_HS NDPS_HS])==0)
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSB_INS.HS=PSB_HS;
        DATA.NDPS_INS.HS=NDPS_HS;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;  
    else
        HIT=1;
    end
else
    HIT=1;
end   

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function VS_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

%***************
%Check formating
%***************
jj=0;
for ii=1:length(VALUE)
    if (strcmpi(VALUE(ii),',')==1)
        jj=jj+1;
    end
end

HIT=0;    
if (jj==2)
    %*******************
    %Update PSB and NDPS
    %*******************
    jj=1;
    kk=1;
    for ii=1:length(VALUE)
        if (strcmpi(VALUE(ii),',')==1)
            if (kk==1)
                PSB_VS(1)=str2double(VALUE(jj:ii-1));
            elseif (kk==2)
                PSB_VS(2)=str2double(VALUE(jj:ii-1));
            end
            jj=ii+1;
            kk=kk+1;                
        end
    end
    NDPS_VS=str2double(VALUE(jj:ii));

    if (isnan([PSB_VS NDPS_VS])==0)
        %*********************
        %Assign DATA structure
        %*********************
        DATA.PSB_INS.VS=PSB_VS;
        DATA.NDPS_INS.VS=NDPS_VS;

        %************************
        %Assign handles structure
        %************************  
        handles.DATA=DATA;  
    else
        HIT=1;
    end
else
    HIT=1;
end   

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end  

end

function NI_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

%***********
%Update PSL
%***********
NI=str2double(VALUE);

HIT=0;
if (isnan(NI)==0)
    %*********************
    %Assign DATA structure
    %*********************
    DATA.NI=NI;

    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;
else
    HIT=1;
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end 

end

function NI_INS_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

%***********
%Update PSL
%***********
NI_INS=str2double(VALUE);

HIT=0;
if (isnan(NI_INS)==0)
    %*********************
    %Assign DATA structure
    %*********************
    DATA.NI_INS=NI_INS;

    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;
else
    HIT=1;
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function NS_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

%***********
%Update PSL
%***********
NS=str2double(VALUE);

HIT=0;
if (isnan(NS)==0)
    %*********************
    %Assign DATA structure
    %*********************
    DATA.NS=NS;

    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;
else
    HIT=1;
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function NAP_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

%***********
%Update PSL
%***********
NAP=str2double(VALUE);

HIT=0;
if (isnan(NAP)==0)
    %*********************
    %Assign DATA structure
    %*********************
    DATA.NAP=NAP;

    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;
else
    HIT=1;
end

if HIT==0
    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 
else
    msgbox('***********   WRONG INPUT FORMAT   ***********')
end

end

function READ_EXP_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

%************************
%Browse for the data file
%************************
[FILENAME,PATH] = uigetfile('*.mat', 'Select the data file');

if (PATH~=0)
    %**************************
    %Add file path to directory
    %**************************
    addpath(PATH)

    %******************
    %Load the data file
    %******************
    load(FILENAME)

    %*****************************
    %Remove file path to directory
    %*****************************
    rmpath(PATH)

    %************************
    %Assign experiemntal data
    %************************
    if (exist('EXP','var')==1)
        DATA.EXP=EXP;
        if (isfield(EXP,'NE')==0 || isfield(EXP,'XE')==0 || isfield(EXP,'IE')==0)
            msgbox('WRONG FORMAT - the structure EXP must have the fields NE --- IE --- XE')
            return
        end
    else
        msgbox('WRONG FORMAT - data must be contained within structure EXP')
        return
    end

    %***************************
    %Assign EXP structure fields
    %***************************
    NE=EXP.NE;
    XE(1:NE)=EXP.XE(1:NE);
    IE(1:NE)=EXP.IE(1:NE);
    if (isfield(EXP,'IEE')==1)
        IEE(1:NE)=EXP.IEE(1:NE);
    end
    if (isfield(EXP,'WT')==1)
        WT(1:NE)=EXP.WT(1:NE);
    end
    if (isfield(EXP,'LG')==1)
        LG(1:NE)=EXP.LG(1:NE);
    end

    %**********************
    %Redefine EXP structure
    %**********************
    EXP.NE=NE;
    EXP.XE=XE;
    EXP.IE=IE;
    if (exist('IEE','var')==1)
        EXP.IEE=IEE;
    end
    if (exist('WT','var')==1)
        EXP.WT=WT;
    end
    if (exist('LG','var')==1)
        EXP.LG=LG;
    end

    %*******************
    %Assign the fit data
    %*******************
    if (exist('FIT','var')==1 && exist('PARA','var')==1 && exist('PARA_BACK','var')==1)
        DATA.FIT=FIT;
        DATA.PARA=PARA;
        DATA.PARA_BACK=PARA_BACK;
    end

    %************************
    %Assign handles structure
    %************************  
    handles.DATA=DATA;

    %************************
    %Update handles structure
    %************************
    guidata(hObject,handles); 

    %**********
    %Set Prompt
    %**********
    set(handles.PROMPT,'String','START'),drawnow 
end

end

function PLOT_EXP_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

if (isfield(DATA,'EXP')==1)
    EXP=DATA.EXP;

    if (isfield(EXP,'NE')==1 && isfield(EXP,'XE')==1 && isfield(EXP,'IE')==1) 
        %************************
        %Assign the spectral data
        %************************
        NE=EXP.NE;
        XE=EXP.XE;
        IE=EXP.IE;

        %****************
        %Assign the noise
        %****************
        if (isfield(EXP,'IEE')==1)
            IEE=EXP.IEE;
        else
            IEE(1:NE)=0.05;
        end

        %********************
        %Assign the fit logic
        %********************
        if (isfield(EXP,'LG')==1)
            LG=EXP.LG;
        else
            LG(1:NE)=1;
        end

        %********************
        %Assign the fit logic
        %********************
        if (isfield(EXP,'WT')==1)
            WT=EXP.WT;
        else
            WT(1:NE)=1;
        end

        %**************************
        %Plot the experimental data
        %**************************
        figure
        hold on
        plot(XE(LG(1:NE)==1),IE(LG(1:NE)==1),'rs','MarkerFaceColor','r','MarkerEdgeColor','r')
        plot(XE(LG(1:NE)==0),IE(LG(1:NE)==0),'bs','MarkerFaceColor','b','MarkerEdgeColor','b')
        for jj=1:NE
            plot([XE(jj) XE(jj)],[-IEE(jj) IEE(jj)]+IE(jj),'-r','LineWidth',2)
        end
        hold off
        xlabel('Wavelength (A)','FontSize',32,'FontWeight','Bold') 
        ylabel('Intensity (a.u.)','FontSize',32,'FontWeight','Bold')
        title('Experimental Data','FontSize',34,'Color','k','FontWeight','Bold')
        grid on
        set(gca,'FontSize',22,'FontWeight','Bold')
        axis([min(XE) max(XE) 0 max(IE)*1.05])

        %*****************************
        %Plot the experimental weights
        %*****************************
        figure
        hold on
        plot(XE(LG(1:NE)==1),WT(LG(1:NE)==1),'rs','MarkerFaceColor','r','MarkerEdgeColor','r')
        plot(XE(LG(1:NE)==0),WT(LG(1:NE)==0),'bs','MarkerFaceColor','b','MarkerEdgeColor','b')
        xlabel('Wavelength (A)','FontSize',32,'FontWeight','Bold') 
        ylabel('Weight (a.u.)','FontSize',32,'FontWeight','Bold')
        title('Weights for experimental data points','FontSize',34,'Color','k','FontWeight','Bold')
        grid on
        set(gca,'FontSize',22,'FontWeight','Bold')
        axis([min(XE) max(XE) 0 max(WT)*1.05])    
    end
end

end

function FIT_EXP_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

EXP=DATA.EXP;

NI=DATA.NI;
NI_INS=DATA.NI_INS;
NS=DATA.NS;
NAP=DATA.NAP;
LINE=DATA.LINE;
LINE_BK=DATA.LINE_BK;
PSL=DATA.PSL;
PSV=DATA.PSV;
PSB=DATA.PSB;
NDPS=DATA.NDPS;
PSB_INS=DATA.PSB_INS;
NDPS_INS=DATA.NDPS_INS;

%***********************************
%Assign number of Gaussian functions
%***********************************
if (PSL.KT_2_GAU==0 || PSL.X_2_GAU==0 || PSL.I_2_GAU==0)
    NTG=2;
elseif PSV.I_2_GAU>0
    NTG=2;
else
    NTG=1;
end
    
if (PSL.KT_2_GAU_BK==0 || PSL.X_2_GAU_BK==0 || PSL.I_2_GAU_BK==0)
    NTG_BK=2;
elseif PSV.I_2_GAU_BK>0
    NTG_BK=2;
else
    NTG_BK=1;
end

%*************************************
%Assign number of Lorentzian functions
%*************************************
if (PSL.GAM_LOR==0 || PSL.X_LOR==0 || PSL.I_LOR==0)
    NFL=1;
elseif PSV.I_LOR>0
    NFL=1;
else
    NFL=0;
end
  
if (PSL.GAM_LOR_BK==0 || PSL.X_LOR_BK==0 || PSL.I_LOR_BK==0)
    NFL_BK=1;
elseif PSV.I_LOR_BK>0
    NFL_BK=1;
else
    NFL_BK=0;
end

%*************************************
%Assign main fit parameter space logic
%*************************************
PSL_MN(1:2)=[PSL.THETA,PSL.PHI];
PSL_MN(3:5)=[PSL.SIGMA,PSL.T1,PSL.T2];
PSL_MN(6:6)=PSL.B_Z;
PSL_MN(7:9)=[PSL.EDC_X PSL.ERF_X 1];
PSL_MN(10:12)=[PSL.EDC_Y PSL.ERF_Y 1];
PSL_MN(13:15)=[PSL.EDC_Z PSL.ERF_Z 1];
if (NTG==1)
    PSL_MN(16:16)=PSL.KT_1_GAU;
    PSL_MN(17:17)=PSL.X_1_GAU;
    PSL_MN(18:18)=PSL.I_1_GAU;
    if (NFL==0)
        PSL_MN(19:19)=PSL.IB;
    elseif (NFL==1)
        PSL_MN(19:19)=PSL.GAM_LOR;
        PSL_MN(20:20)=PSL.X_LOR;
        PSL_MN(21:21)=PSL.I_LOR;
        PSL_MN(22:22)=PSL.IB;
    end    
elseif (NTG==2)
    PSL_MN(16:17)=[PSL.KT_1_GAU PSL.KT_2_GAU];
    PSL_MN(18:19)=[PSL.X_1_GAU PSL.X_2_GAU];
    PSL_MN(20:21)=[PSL.I_1_GAU PSL.I_2_GAU];
    if (NFL==0)
        PSL_MN(22:22)=PSL.IB;
    elseif (NFL==1)
        PSL_MN(22:22)=PSL.GAM_LOR;
        PSL_MN(23:23)=PSL.X_LOR;
        PSL_MN(24:24)=PSL.I_LOR;
        PSL_MN(25:25)=PSL.IB;
    end
end

%*******************************************
%Assign background fit parameter space logic
%*******************************************
PSL_BK(1:2)=[PSL.THETA_BK,PSL.PHI_BK];
PSL_BK(3:5)=[PSL.SIGMA_BK,PSL.T1_BK,PSL.T2_BK];
PSL_BK(6:6)=PSL.B_Z_BK;
PSL_BK(7:7)=1;
PSL_BK(8:8)=1;
PSL_BK(9:9)=1;
if (NTG_BK==1)
    PSL_BK(10:10)=PSL.KT_1_GAU_BK;
    PSL_BK(11:11)=PSL.X_1_GAU_BK;
    PSL_BK(12:12)=PSL.I_1_GAU_BK;
    if (NFL_BK==1)
        PSL_BK(13:13)=PSL.GAM_LOR_BK;
        PSL_BK(14:14)=PSL.X_LOR_BK;
        PSL_BK(15:15)=PSL.I_LOR_BK;
    end    
elseif (NTG_BK==2)
    PSL_BK(10:11)=[PSL.KT_1_GAU_BK PSL.KT_2_GAU_BK];
    PSL_BK(12:13)=[PSL.X_1_GAU_BK PSL.X_2_GAU_BK];
    PSL_BK(14:15)=[PSL.I_1_GAU_BK PSL.I_2_GAU_BK];
    if (NFL_BK==1)
        PSL_BK(16:16)=PSL.GAM_LOR_BK;
        PSL_BK(17:17)=PSL.X_LOR_BK;
        PSL_BK(18:18)=PSL.I_LOR_BK;
    end
end

%*************************************
%Assign main fit parameter space logic
%*************************************
PSV_MN(1:2)=[PSV.THETA*pi/180,PSV.PHI*pi/180];
PSV_MN(3:5)=[PSV.SIGMA*pi/180,PSV.T1,PSV.T2];
PSV_MN(6:6)=PSV.B_Z;
PSV_MN(7:9)=[PSV.EDC_X PSV.ERF_X 0];
PSV_MN(10:12)=[PSV.EDC_Y PSV.ERF_Y 0];
PSV_MN(13:15)=[PSV.EDC_Z PSV.ERF_Z 0];
if (NTG==1)
    PSV_MN(16:16)=PSV.KT_1_GAU;
    PSV_MN(17:17)=PSV.X_1_GAU;
    PSV_MN(18:18)=PSV.I_1_GAU;
    if (NFL==0)
        PSV_MN(19:19)=PSV.IB;
    elseif (NFL==1)
        PSV_MN(19:19)=PSV.GAM_LOR;
        PSV_MN(20:20)=PSV.X_LOR;
        PSV_MN(21:21)=PSV.I_LOR;
        PSV_MN(22:22)=PSV.IB;
    end    
elseif (NTG==2)
    PSV_MN(16:17)=[PSV.KT_1_GAU PSV.KT_2_GAU];
    PSV_MN(18:19)=[PSV.X_1_GAU PSV.X_2_GAU];
    PSV_MN(20:21)=[PSV.I_1_GAU PSV.I_2_GAU];
    if (NFL==0)
        PSV_MN(22:22)=PSV.IB;
    elseif (NFL==1)
        PSV_MN(22:22)=PSV.GAM_LOR;
        PSV_MN(23:23)=PSV.X_LOR;
        PSV_MN(24:24)=PSV.I_LOR;
        PSV_MN(25:25)=PSV.IB;
    end
end
    
%*******************************************
%Assign background fit parameter space logic
%*******************************************
PSV_BK(1:2)=[PSV.THETA_BK*pi/180,PSV.PHI_BK*pi/180];
PSV_BK(3:5)=[PSV.SIGMA_BK*pi/180,PSV.T1_BK,PSV.T2_BK];
PSV_BK(6:6)=PSV.B_Z_BK;
PSV_BK(7:7)=0;
PSV_BK(8:8)=0;
PSV_BK(9:9)=0;
PSV_BK(10:11)=[PSV.KT_1_GAU_BK PSV.KT_2_GAU_BK];
PSV_BK(12:13)=[PSV.X_1_GAU_BK PSV.X_2_GAU_BK];
PSV_BK(14:15)=[PSV.I_1_GAU_BK PSV.I_2_GAU_BK];
if (NTG_BK==1)
    PSV_BK(10:10)=PSV.KT_1_GAU_BK;
    PSV_BK(11:11)=PSV.X_1_GAU_BK;
    PSV_BK(12:12)=PSV.I_1_GAU_BK;
    if (NFL_BK==1)
        PSV_BK(13:13)=PSV.GAM_LOR_BK;
        PSV_BK(14:14)=PSV.X_LOR_BK;
        PSV_BK(15:15)=PSV.I_LOR_BK;
    end    
elseif (NTG_BK==2)
    PSV_BK(10:11)=[PSV.KT_1_GAU_BK PSV.KT_2_GAU_BK];
    PSV_BK(12:13)=[PSV.X_1_GAU_BK PSV.X_2_GAU_BK];
    PSV_BK(14:15)=[PSV.I_1_GAU_BK PSV.I_2_GAU_BK];
    if (NFL_BK==1)
        PSV_BK(16:16)=PSV.GAM_LOR_BK;
        PSV_BK(17:17)=PSV.X_LOR_BK;
        PSV_BK(18:18)=PSV.I_LOR_BK;
    end
end

%******************************************
%Assign main fit parameter space boundaries
%******************************************
ll=0;
mm=1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.THETA*pi/180;
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.PHI*pi/180;
end    
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.SIGMA*pi/180;
end   
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.T1;
end   
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.T2;
end       
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.B_Z;
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.EDC_X;
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.ERF_X;
end
mm=mm+2;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.EDC_Y;
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.ERF_Y;
end
mm=mm+2;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.EDC_Z;
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.ERF_Z;
end
mm=mm+2;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.KT_1_GAU;
end
if (NTG==2)
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        PSB_MN(ll,1:2)=PSB.KT_2_GAU;
    end
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.X_1_GAU;
end
if (NTG==2)
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        PSB_MN(ll,1:2)=PSB.X_2_GAU;
    end
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.I_1_GAU;
end
if (NTG==2)
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        PSB_MN(ll,1:2)=PSB.I_2_GAU;
    end
end
if (NFL==1)
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        PSB_MN(ll,1:2)=PSB.GAM_LOR;
    end
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        PSB_MN(ll,1:2)=PSB.X_LOR;
    end
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        PSB_MN(ll,1:2)=PSB.I_LOR;
    end
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    PSB_MN(ll,1:2)=PSB.IB;
end  

%************************************************
%Assign background fit parameter space boundaries
%************************************************
ll=0;
mm=1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    PSB_BK(ll,1:2)=PSB.THETA_BK*pi/180;
end
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    PSB_BK(ll,1:2)=PSB.PHI_BK*pi/180;
end    
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    PSB_BK(ll,1:2)=PSB.SIGMA_BK*pi/180;
end   
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    PSB_BK(ll,1:2)=PSB.T1_BK;
end   
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    PSB_BK(ll,1:2)=PSB.T2_BK;
end       
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    PSB_BK(ll,1:2)=PSB.B_Z_BK;
end
mm=mm+4;
if (PSL_BK(mm)==0)
    ll=ll+1;
    PSB_BK(ll,1:2)=PSB.KT_1_GAU_BK;
end
if (NTG_BK==2)
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        PSB_BK(ll,1:2)=PSB.KT_2_GAU_BK;
    end
end
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    PSB_BK(ll,1:2)=PSB.X_1_GAU_BK;
end
if (NTG_BK==2)
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        PSB_BK(ll,1:2)=PSB.X_2_GAU_BK;
    end
end
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    PSB_BK(ll,1:2)=PSB.I_1_GAU_BK;
end
if (NTG_BK==2)
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        PSB_BK(ll,1:2)=PSB.I_2_GAU_BK;
    end
end
if (NFL_BK==1)
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        PSB_BK(ll,1:2)=PSB.GAM_LOR_BK;
    end
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        PSB_BK(ll,1:2)=PSB.X_LOR_BK;
    end
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        PSB_BK(ll,1:2)=PSB.I_LOR_BK;
    end
end

%*******************************
%Assign main fit discretizations
%*******************************
ll=0;
mm=1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.THETA;
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.PHI;
end    
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.SIGMA;
end   
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.T1;
end   
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.T2;
end       
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.B_Z;
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.EDC_X;
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.ERF_X;
end
mm=mm+2;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.EDC_Y;
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.ERF_Y;
end
mm=mm+2;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.EDC_Z;
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.ERF_Z;
end
mm=mm+2;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.KT_1_GAU;
end
if (NTG==2)
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        NDPS_MN(ll)=NDPS.KT_2_GAU;
    end
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.X_1_GAU;
end
if (NTG==2)
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        NDPS_MN(ll)=NDPS.X_2_GAU;
    end
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.I_1_GAU;
end
if (NTG==2)
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        NDPS_MN(ll)=NDPS.I_2_GAU;
    end
end
if (NFL==1)
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        NDPS_MN(ll)=NDPS.GAM_LOR;
    end
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        NDPS_MN(ll)=NDPS.X_LOR;
    end
    mm=mm+1;
    if (PSL_MN(mm)==0)
        ll=ll+1;
        NDPS_MN(ll)=NDPS.I_LOR;
    end
end
mm=mm+1;
if (PSL_MN(mm)==0)
    ll=ll+1;
    NDPS_MN(ll)=NDPS.IB;
end  

%*************************************
%Assign background fit discretizations
%*************************************
ll=0;
mm=1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    NDPS_BK(ll)=NDPS.THETA_BK;
end
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    NDPS_BK(ll)=NDPS.PHI_BK;
end    
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    NDPS_BK(ll)=NDPS.SIGMA_BK;
end   
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    NDPS_BK(ll)=NDPS.T1_BK;
end   
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    NDPS_BK(ll)=NDPS.T2_BK;
end       
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    NDPS_BK(ll)=NDPS.B_Z_BK;
end
mm=mm+4;
if (PSL_BK(mm)==0)
    ll=ll+1;
    NDPS_BK(ll)=NDPS.KT_1_GAU_BK;
end
if (NTG_BK==2)
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        NDPS_BK(ll)=NDPS.KT_2_GAU_BK;
    end
end
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    NDPS_BK(ll)=NDPS.X_1_GAU_BK;
end
if (NTG_BK==2)
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        NDPS_BK(ll)=NDPS.X_2_GAU_BK;
    end
end
mm=mm+1;
if (PSL_BK(mm)==0)
    ll=ll+1;
    NDPS_BK(ll)=NDPS.I_1_GAU_BK;
end
if (NTG_BK==2)
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        NDPS_BK(ll)=NDPS.I_2_GAU_BK;
    end
end
if (NFL_BK==1)
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        NDPS_BK(ll)=NDPS.GAM_LOR_BK;
    end
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        NDPS_BK(ll)=NDPS.X_LOR_BK;
    end
    mm=mm+1;
    if (PSL_BK(mm)==0)
        ll=ll+1;
        NDPS_BK(ll)=NDPS.I_LOR_BK;
    end
end

%********************************************
%Assign instrument parameter space boundaries
%********************************************
PSB_INSTR(1,1:2)=PSB_INS.VS;
PSB_INSTR(2,1:2)=PSB_INS.HS;

%*********************************
%Assign instrument discretizations
%*********************************
NDPS_INSTR(1)=NDPS_INS.VS;
NDPS_INSTR(2)=NDPS_INS.HS;

%*********************
%Fit parameter options
%*********************
OPT.PARA.NI=NI;
OPT.PARA.NI_INS=NI_INS;
OPT.PARA.NS=NS;
OPT.PARA.NH_X=1;
OPT.PARA.NH_Y=1;
OPT.PARA.NH_Z=1;
OPT.PARA.NTG=NTG;
OPT.PARA.NFL=NFL;
OPT.PARA.PSL=PSL_MN;
OPT.PARA.PSV=PSV_MN;
if (exist('PSB_MN','var')==1)
    OPT.PARA.PSB=PSB_MN;
    OPT.PARA.NDPS=NDPS_MN;
end
OPT.PARA.PSB_INS=PSB_INSTR;
OPT.PARA.NDPS_INS=NDPS_INSTR;

OPT.PARA_BACK.NH_X=0;
OPT.PARA_BACK.NH_Y=0;
OPT.PARA_BACK.NH_Z=0;
OPT.PARA_BACK.NTG=NTG_BK;
OPT.PARA_BACK.NFL=NFL_BK;
OPT.PARA_BACK.LINE=LINE_BK;
OPT.PARA_BACK.PSL=PSL_BK;
OPT.PARA_BACK.PSV=PSV_BK;
if (exist('PSB_BK','var')==1)
    OPT.PARA_BACK.PSB=PSB_BK;
    OPT.PARA_BACK.NDPS=NDPS_BK; 
end

%*************
%Print options
%*************
OPT.PRINT.PARA=1;
OPT.PRINT.PARA_BACK=1;
OPT.PRINT.FIT=1;

%************
%Plot options
%************
OPT.PLOT.FIT=0;

%**********
%Set Prompt
%**********
set(handles.PROMPT,'String','FITTING'),drawnow 

%************
%Fit the data
%************
[FIT,PARA,PARA_BACK]=MAIN(EXP,LINE,OPT,NAP);

%**********
%Set Prompt
%**********
set(handles.PROMPT,'String','FINISHED'),drawnow

%*********************
%Assign DATA structure
%*********************
DATA.FIT=FIT;
DATA.PARA=PARA;
DATA.PARA_BACK=PARA_BACK;

%************************
%Assign handles structure
%************************  
handles.DATA=DATA;    

%************************
%Update handles structure
%************************
guidata(hObject,handles); 

end

function PLOT_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

if (isfield(DATA,'EXP')==1 && isfield(DATA,'FIT')==1 && isfield(DATA,'PARA')==1)
    %***********************************
    %Assign PARA, FIT and EXP sturctures
    %***********************************
    FIT=DATA.FIT;
    PARA=DATA.PARA;
    EXP=DATA.EXP;
    
    %*********************
    %Calc. cell properties
    %*********************
    DATA.EXP=Exp_Data(EXP);
    
    %*************
    %Plot the data
    %*************
    Plot_Fit(PARA,DATA,FIT)
end

end

function FILE_NAME_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

%****************
%Set object value
%****************
VALUE=get(hObject,'String');

%*********************
%Assign DATA structure
%*********************
DATA.FILENAME=VALUE;

%************************
%Assign handles structure
%************************  
handles.DATA=DATA;    

%************************
%Update handles structure
%************************
guidata(hObject,handles); 

end

function SAVE_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

if (isfield(DATA,'FILENAME')==1 && isfield(DATA,'EXP')==1 && isfield(DATA,'FIT')==1 && isfield(DATA,'PARA')==1 && isfield(DATA,'PARA_BACK')==1)
    %*****************
    %Assign sturctures
    %*****************
    FILENAME=DATA.FILENAME;
    EXP=DATA.EXP;
    FIT=DATA.FIT;
    PARA=DATA.PARA;
    PARA_BACK=DATA.PARA_BACK;
    
    %*********
    %Save data
    %*********
    save([FILENAME '.mat'],'EXP','FIT','PARA','PARA_BACK')
end

end

function PRINT_FIT_Callback(hObject,eventdata,handles)

%************
%Assign input
%************
DATA=handles.DATA;

if (isfield(DATA,'FIT')==1 && isfield(DATA,'PARA')==1 && isfield(DATA,'PARA_BACK')==1)
    %************
    %Clear screen
    %************
    clc
    
    %*********************
    %Assign fit sturctures
    %*********************
    FIT=DATA.FIT;
    PARA=DATA.PARA;
    PARA_BACK=DATA.PARA_BACK;
    
    NAP=DATA.NAP;
    
    %*********************
    %Assign solver options
    %*********************
    OPT.SOLVER.ALGO=[1,1];
    
    %***********
    %Print model
    %***********
    Print_Para(PARA,OPT,NAP)
    if (isempty(PARA_BACK)==0)
        Print_Para_Back(PARA_BACK)
    end
    
    %****************
    %Print fit values
    %****************
    Print_Var(PARA,PARA_BACK,FIT)
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%      EXECUTION OF OBJECTS      %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

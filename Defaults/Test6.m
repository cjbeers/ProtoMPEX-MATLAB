
function h = change_dataset_demo

%// sample data
nDataset = 8 ;
x = linspace(0,2*pi,50).' ;     %'// ignore this comment
data = sin( x*(1:nDataset) ) ;

index.max = nDataset ;
index.current = 1 ;

%// Plot the first one
h.fig = figure ;
h.plot = plot( data(:,index.current) ) ;

%// store data in figure appdata
setappdata( h.fig , 'data',  data )
setappdata( h.fig , 'index', index )

%// set the figure event callbacks
set(h.fig, 'KeyPressFcn', @KeyPressFcn_callback ) ;     %// Set figure KeyPressFcn function
set(h.fig, 'WindowScrollWheelFcn',@mouseWheelCallback)  %// Set figure Mouse wheel function

guidata( h.fig , h )


function mouseWheelCallback(hobj,evt)
    update_display( hobj , evt.VerticalScrollCount )

function KeyPressFcn_callback(hobj,evt)
    if ~isempty( evt.Modifier ) ; return ; end  % Bail out if there is a modifier

    switch evt.Key
        case 'rightarrow'
            increment = +1 ;
        case 'leftarrow'
            increment = -1 ;
        otherwise
            % do nothing
            return ;
    end
    update_display( hobj , increment )

function update_display( hobj , increment )

    h = guidata( hobj ) ;
    index = getappdata( h.fig , 'index' ) ;
    data  = getappdata( h.fig , 'data' ) ;

    newindex = index.current + increment ;
    %// roll over if we go out of bound
    if newindex > index.max
        newindex = 1 ;
    elseif newindex < 1
        newindex = index.max ;
    end
    set( h.plot , 'YData' , data(:,newindex) ) ;
    index.current = newindex ;
    setappdata( h.fig , 'index', index )
    
    
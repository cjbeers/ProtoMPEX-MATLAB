% Set preview data to native camera bit depth (default is 8 bit)

imaqmex('feature', '-previewFullBitDepth', true);

v = videoinput('gige', 1, 'Mono16');

% Create a preview window and get image and axes handles
im = preview(v);
ax = im.Parent;

% Specify scaled grayscale data mapping to colormap
im.CDataMapping = 'scaled';

% Specify a colormap to display grayscale image mapped to RGB image
colormap(ax, jet);

% Specify a fixed signal data range to display
signalRange = [10000 50000];
%ax.CLim = signalRange;

% Or specify auto detection of CData limits
ax.CLimMode = 'auto';

%add axis
ax.XGrid='on';
ax.YGrid='on';

%frames per trigger 
vid.FramesPerTrigger = 500;

%specify remote trigger
%triggerconfig(v,'hardware','input1')

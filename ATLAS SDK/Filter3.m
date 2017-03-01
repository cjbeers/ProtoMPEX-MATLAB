function Io  = Filter3(I)
se = strel('disk', 15);
%Opening is an erosion followed by a dilation
Io  = imopen(I, se);

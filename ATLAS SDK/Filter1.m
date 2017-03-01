function blurred = Filter1(I)
%put your filter here
H = fspecial('disk',10);
blurred = imfilter(I,H,'replicate');


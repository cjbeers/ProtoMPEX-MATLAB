function edges = Filter2(I)
%put your filter here
I2 = rgb2gray(I);
BW2 = edge(I2,'canny',0.2);
edges = imfuse(I,BW2,'blend');



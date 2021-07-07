
cleanup
Image1=open('C:\Users\cxe\Documents\Proto-MPEX\MAPP on Proto-MPEX\Pictures\UPW\UPW6.jpg');
Image1.SStarget_pix2cm=(Image1.UPW6);
imagesc(Image1.UPW6)
Image1.HSV=rgb2hsv(Image1.UPW6);
Image1.HueAngle=Image1.HSV*360;
A=[420 435];
B=[240 190];
hold on
plot(A,B);
%set (gcf, 'WindowButtonMotionFcn', @mouseMove);
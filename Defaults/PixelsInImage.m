
cleanup
Image1=open('C:\Users\cxe\Pictures\Screenshots\June19 6.5 DLP.png');
Image1.SStarget_pix2cm=(Image1.cdata);
imagesc(Image1.cdata)
set (gcf, 'WindowButtonMotionFcn', @mouseMove);
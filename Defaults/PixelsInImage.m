
cleanup
Image1=open('C:\Users\cxe\Documents\Papers\PSI 18 Paper\FVC stuff\SStarget_pix2cm.jpg');
Image1.SStarget_pix2cm=(Image1.SStarget_pix2cm);
imagesc(Image1.SStarget_pix2cm)
set (gcf, 'WindowButtonMotionFcn', @mouseMove);
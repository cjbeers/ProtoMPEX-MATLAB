
cleanup
Target=open('C:\Users\cxe\Pictures\Target Probe\Target_v1_Spool11.5_2.jpg');
Target.Target_v1_Spool11_5_2=rot90(rot90(rot90(Target.Target_v1_Spool11_5_2)));
imagesc(Target.Target_v1_Spool11_5_2)
set (gcf, 'WindowButtonMotionFcn', @mouseMove);
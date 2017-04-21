cleanup
%{
[rr cc] = meshgrid(1:480,1:640);
C = sqrt((rr-240).^2+(cc-320).^2)<=75;
G = sqrt((rr-100).^2+(cc-100).^2)<=75;
figure; hold on
imshow(C)
imshow(G)
hold off
%}
%%

cc=1:640; 
rr=cc.';

cx1=320; cy1=320; R1=100;
cx2=100; cy2=100; R2=20;


f=@(xx,yy) (xx-cx1).^2+(yy-cy1).^2 <=R1^2 | (xx-cx2).^2+(yy-cy2).^2 <=R2^2 ; 
 

C=bsxfun(f,rr,cc); %Logical map of 2 circles
figure; imshow(C)


%%

figure()
imagesc(img, 'CDataMapping','scaled')
%caxis([0 18])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [C]', 'FontSize', 13);
ax.FontSize = 13;

%%

% Create a logical image of a circle with specified
% diameter, center, and image size.
% First create the image.
imageSizeX = 640;
imageSizeY = 640;
[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% Next create the circle in the image.
centerX = 320;
centerY = 320;
radius = 50;
circlePixels = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= radius.^2;
% circlePixels is a 2D "logical" array.
% Now, display it.
image(circlePixels) ;
colormap([0 0 0; 1 1 1]);
%title('Binary image of a circle');

%%
% Image

% circle pixel-coordinates
xc = 320;
yc = 320;
r = 21; % radius

% Engine
y=1:size(img,1);
x=1:size(img,2);
[X Y]=meshgrid(x,y);

% This assume the circle falls *entirely* inside the image
R2 = (X-xc).^2+(Y-yc).^2;
c = contourc(x,y,R2,[0 0]+r^2);
c = round(c(:,2:end)); % pixels located ~ on circle, not within circle
Ac = img(sub2ind(size(img),c(2,:),c(1,:))); % extract value
val = mean(Ac) % mean

% Bruno


% % Assign values inside the circle.
% newGrayLevelInside = 50;
% grayImage(circlePixels) = newGrayLevelInside;
% 
% % Or, assign values outside the circle.
% newGrayLevelOutside = 150;
% grayImage(~circlePixels) = newGrayLevelOutside ;

% radius = 50; 
% centerX = 20;
% centerY = 30;
% rectangle('Position',[centerX - radius, centerY - radius, radius*2, radius*2],...
%     'Curvature',[1,1],...
%     'FaceColor','r');
% axis square;

%%
x=320; %Center of circle's x position
y=320; %Center of circle's y position
r=50; %Radius of circle
[xgrid, ygrid] = meshgrid(1:size(img,2), 1:size(img,1)); %Creates meshgrid of circle
mask = ((xgrid-x).^2 + (ygrid-y).^2) <= r.^2; %Creates mask for overlaying on img
values = img(mask); %finds the values in the defined circle
mean(values) %Finds average of defined circle

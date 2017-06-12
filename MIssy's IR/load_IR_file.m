function data = load_IR_file(fname,plotit)
% Note that image is fliped up-down
if nargin < 2
    plotit = 0;
end

px_per_cm = 32.44;  %MS edit, 4/18/17 - 32.44 pixels per centimeter, at location 11.5, A655sc camera
import = matfile(fname);       %MS edit, 4/18/17 - adjusting so can read automatic matrices saved by IR camera script.
d = import.Frame;%MS edit, 4/18/17 - load up the IR image matrix

% px_per_cm = import.px_per_cm;
%d=matfile(fname);
% plot raw data
if plotit
    figure; hold on; box on;
    h = pcolor(d);              %MS edit - got rid of the .Frame: couldnt find what it was referencing
    colorbar
    caxis([0 150])
    set(h,'edgecolor','none')
    title('Raw data','fontsize',14)
    xlabel('X [px]','fontsize',14)
    ylabel('Y [px]','fontsize',14)
    set(gca,'fontsize',14)
end

% Convert to cm and flip
IRdata2D = flipud(d);
nw = size(d,2);                  %MS edit - got rid of the .Frame: couldnt find what it was referencing
nh = size(d,1);                 %MS edit - got rid of the .Frame: couldnt find what it was referencing
dx = nw/px_per_cm;
dy = nh/px_per_cm;
IRdata1D = reshape(IRdata2D,1,nw*nh);

data.dx = dx;
data.dy = dy;
data.nw = nw;
data.nh = nh;
data.IRdata1D = IRdata1D;
data.IRdata2D = IRdata2D;

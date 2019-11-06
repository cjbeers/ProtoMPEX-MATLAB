clear, clc, close all

% example plot
figure(1)
plot(peaks(100))
% image(imread('ngc6543a.jpg'))
% bar(peaks(10))
% stem(peaks(10))
grid on

% plot annotation
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('X axis')
ylabel('Y axis')
title('Demo Plot')

% apply the magnifier
magnifier(gcf, gca)
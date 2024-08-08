clear
clc

fs = 1000; % 
f1 = 50; % 
f2 = 200; % 
t = 0:1/fs:1-1/fs; % sample point
x = 1.8*cos(2*pi*f1*t)+0.5*cos(2*pi*f2*t) + randn(size(t)); % time length 1s

subplot(1,2,1)
periodogram(x,rectwin(length(x))); % rectangle window
% set(gca,'fontsize',12,'fontname','times');
title('\fontname{}周期图','fontsize',14);
subplot(1,2,2)
periodogram(x,hamming(length(x))); % hamming window
% set(gca,'fontsize',12,'fontname','times');
title('\fontname{}改进周期图','fontsize',14);

set(gcf,'Units','centimeter','Position',[10 10 28 10]);
clear
clc

w1 = 100*pi;                 % signal 1 angular frequency
w2 = 150*pi;                 % signal 2 angular frequency

Fs = 2000;                   % sample rate
T = 2;                       % signal length
std = sqrt(0.1);             % noise standard deviation

t = 0: 1/Fs: T-1/Fs;         % sample
x1 = sin(w1*t);              % signal component 1
x2 = 2*cos(w2*t);            % signal component 2
n = std*randn(size(t));      % Gaussian noise
x = x1 + x2 + n;             % signal

len = length(x);             % sample length

% Periodogram method
Sx1 = periodogram_method(x, len);

% Correlogram method
Sx2 = correlogram_method(x, len);

% x-axis
a = 1:(len/2);
ax = a / (len/2);

figure
subplot(2, 1, 1)
plot(ax, 10*log10(Sx1(1:len/2)))
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')
title('Power spectrum density using periodogram method')

subplot(2, 1, 2)
plot(ax, 10*log10(Sx2(1:len/2)))
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')
title('Power spectrum density using correlogram method')
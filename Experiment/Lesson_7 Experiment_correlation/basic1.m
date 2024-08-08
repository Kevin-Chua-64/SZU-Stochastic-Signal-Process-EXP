clear
clc

T = 3;                       % signal time_len T = 3s
Fs = 1000;                   % sample rate Fs = 1000Hz
t = 0: 1/Fs: T-1/Fs;         % sample
f1 = 50;                     % signal 1 frequency f1 = 50Hz
f2 = 200;                    % signal 2 frequency f2 = 200Hz
x1 = sin(2*pi*f1*t);         % signal component 1
x2 = 2*cos(2*pi*f2*t);       % signal component 2
std = sqrt(0.1);             % noise standard deviation σ^2 = 0.1
n = std*randn(size(t));      % Gaussian noise
x = x1 + x2 + n;             % signal X(t) = sin(2Πf_1 t) + 2cos(2Πf_2 t) + N(t)

figure
subplot(3, 1, 1)
plot(t, x)
title('X(t) = sin(100Πt) + 2cos(400Πt) + N(t)')

ac = xcorr(x, 'coeff');      % autocorrelation
c_c = xcorr(x, n, 'coeff');  % cross-correlation
N = T*Fs;                    % sample point
subplot(3, 1, 2)
plot(1-N:N-1, ac)
title('The autocorrelation R_X(┏)')
subplot(3, 1, 3)
plot(1-N:N-1, c_c)
title('The cross-correlation R_X_N(┏)')
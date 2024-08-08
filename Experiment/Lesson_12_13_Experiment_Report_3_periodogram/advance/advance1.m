clc
clear

T = 0.1;                        % signal length
f0 = 1000;                      % signal basic frequency
k = 9000;                       % coefficient

% Calculate signal frequency by derivation
syms tt
f = tt*(f0 + k*tt);
f_ = diff(f, tt);
% Sample rate = 5 * 2*signal frequency
Fs = double(10*subs(f_, tt, T));

t = 0: 1/Fs: T-1/Fs;            % sample
x = sin(2*pi*(t.*(f0+k.*t)));   % signal

figure
plot(t, x)
xlim([-0.01, 0.11])
ylim([-1.1, 1.1])
title('Chirp signal')

% Estimate the average power
Ps = x*x' / length(x);
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

% Periodogram
figure
subplot(3, 1, 1)
periodogram(x, rectwin(length(x)), length(x))
title('Periodogram Power Spectrum Density Estimation (Rectangular window)')
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')

subplot(3, 1, 2)
periodogram(x, triang(length(x)), length(x))
title('Periodogram Power Spectrum Density Estimation (Triangular  window)')
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')

subplot(3, 1, 3)
periodogram(x, hamming(length(x)), length(x))
title('Periodogram Power Spectrum Density Estimation (Hamming window)')
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')

% Change sampling rate
Fs_1 = 1000;

t_1 = 0: 1/Fs_1: T-1/Fs_1;
x1_1 = sin(w1*t_1);
x2_1 = 2*cos(w2*t_1);
n_1 = std*randn(size(t_1));
x_1 = x1_1 + x2_1 + n_1;

figure
subplot(2, 1, 1)
periodogram(x, rectwin(length(x)), length(x))
title('Periodogram Power Spectrum Density Estimation (Fs=2000Hz)')
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')

subplot(2, 1, 2)
periodogram(x_1, rectwin(length(x_1)), length(x_1))
title('Periodogram Power Spectrum Density Estimation (Fs=1000Hz)')
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')

% Change signal length
T_2 = 0.5;

t_2 = 0: 1/Fs: T_2-1/Fs;
x1_2 = sin(w1*t_2);
x2_2 = 2*cos(w2*t_2);
n_2 = std*randn(size(t_2));
x_2 = x1_2 + x2_2 + n_2;

figure
subplot(2, 1, 1)
periodogram(x, rectwin(length(x)), length(x))
title('Periodogram Power Spectrum Density Estimation (T=2s)')
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')

subplot(2, 1, 2)
periodogram(x_2, rectwin(length(x_2)), length(x_2))
title('Periodogram Power Spectrum Density Estimation (T=0.5s)')
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')

% Change FFT length
nfft_3 = 500;

figure
subplot(2, 1, 1)
periodogram(x, rectwin(length(x)), length(x))
title('Periodogram Power Spectrum Density Estimation (nfft=4000)')
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')

subplot(2, 1, 2)
periodogram(x, rectwin(length(x)), nfft_3)
title('Periodogram Power Spectrum Density Estimation (nfft=500)')
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')

% Change noise power
std_4 = sqrt(10);

n_4 = std_4*randn(size(t));
x_4 = x1 + x2 + n_4;

figure
subplot(2, 1, 1)
periodogram(x, rectwin(length(x)), length(x))
title('Periodogram Power Spectrum Density Estimation (\sigma^2=0.1)')
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')

subplot(2, 1, 2)
periodogram(x_4, rectwin(length(x_4)), length(x_4))
title('Periodogram Power Spectrum Density Estimation (\sigma^2=10)')
xlabel('Normalized frequency (\times\pi rad/sample)')
ylabel('Power/ Frequency (dB/(rad/sample))')
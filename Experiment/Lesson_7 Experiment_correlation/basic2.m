clear
clc

rng(28)                      % set random seed
T = 2;                       % signal time_len T = 2s
Fs = 44100;                  % sample rate Fs = 44100Hz
t = 0: 1/Fs: T-1/Fs;         % sample
N = T*Fs;                    % sample point
f = 199;                     % signal frequency f = 199Hz
x_ = 2*cos(2*pi*f*t);        % signal component

std1 = sqrt(0.1);            % noise standard deviation, so σ^2 = 0.1
n1 = std1*randn(1, N);       % Gaussian noise 1
x1 = x_ + n1;                % signal 1
std2 = sqrt(0.5);            % noise standard deviation, so σ^2 = 0.5
n2 = std2*randn(1, N);       % Gaussian noise 2
x2 = x_ + n2;                % signal 2
std3 = sqrt(1);              % noise standard deviation, so σ^2 = 1
n3 = std3*randn(1, N);       % Gaussian noise 3
x3 = x_ + n3;                % signal 3
std4 = sqrt(5);              % noise standard deviation, so σ^2 = 5
n4 = std4*randn(1, N);       % Gaussian noise 4
x4 = x_ + n4;                % signal 4

% signal 1
figure
subplot(2, 1, 1)
plot(t, x1)
xlim([0, 0.1])
xlabel('t')
title('X(t) = sin(398Πt) + N(t)   (σ^2 = 0.1)')

ac1_ = xcorr(x1, 'unbias');  % autocorrelation
ac1 = ac1_ / ac1_(N);        % normalizatin
subplot(2, 1, 2)
plot(1-N:N-1, ac1)
xlim([-1000, 1000])
title('The autocorrelation R_X(┏)')

% signal 2
figure
subplot(2, 1, 1)
plot(t, x2)
xlim([0, 0.1])
xlabel('t')
title('X(t) = sin(398Πt) + N(t)   (σ^2 = 0.5)')

ac2_ = xcorr(x2, 'unbias');  % autocorrelation
ac2 = ac2_ / ac2_(N);        % normalizatin
subplot(2, 1, 2)
plot(1-N:N-1, ac2)
xlim([-1000, 1000])
title('The autocorrelation R_X(┏)')

% signal 3
figure
subplot(2, 1, 1)
plot(t, x3)
xlim([0, 0.1])
xlabel('t')
title('X(t) = sin(398Πt) + N(t)   (σ^2 = 1)')

ac3_ = xcorr(x3, 'unbias');  % autocorrelation
ac3 = ac3_ / ac3_(N);        % normalizatin
subplot(2, 1, 2)
plot(1-N:N-1, ac3)
xlim([-1000, 1000])
title('The autocorrelation R_X(┏)')

% signal 4
figure
subplot(2, 1, 1)
plot(t, x4)
xlim([0, 0.1])
xlabel('t')
title('X(t) = sin(398Πt) + N(t)   (σ^2 = 5)')

ac4_ = xcorr(x4, 'unbias');  % autocorrelation
ac4 = ac4_ / ac4_(N);        % normalizatin
subplot(2, 1, 2)
plot(1-N:N-1, ac4)
xlim([-1000, 1000])
title('The autocorrelation R_X(┏)')

% find the period of autocorrelation (adjacent highest point)
period_ = round(0.5*Fs/f);                     % roughly half sample period
interval1 = N+period_ : N+3*period_;           % interval 1
interval2 = N+3*period_:N+5*period_;           % interval 2

% signal 1
[max11, index11] = max(ac1(interval1));
[max12, index12] = max(ac1(interval2));
difference1 = index12-index11 + 2*period_;     % sample distance between adjacent highest point
estimated_freq_1 = Fs / difference1;           % signal estimated frequency
error_1 = abs(f - estimated_freq_1)/f * 100;   % estimated error

% signal 2
[max21, index21] = max(ac2(interval1));
[max22, index22] = max(ac2(interval2));
difference2 = index22-index21 + 2*period_;     % sample distance between adjacent highest point
estimated_freq_2 = Fs / difference2;           % signal estimated frequency
error_2 = abs(f - estimated_freq_2)/f * 100;   % estimated error

% signal 3
[max31, index31] = max(ac3(interval1));
[max32, index32] = max(ac3(interval2));
difference3 = index32-index31 + 2*period_;     % sample distance between adjacent highest point
estimated_freq_3 = Fs / difference3;           % signal estimated frequency
error_3 = abs(f - estimated_freq_3)/f * 100;   % estimated error

% signal 4
[max41, index41] = max(ac4(interval1));
[max42, index42] = max(ac4(interval2));
difference4 = index42-index41 + 2*period_;     % sample distance between adjacent highest point
estimated_freq_4 = Fs / difference4;           % signal estimated frequency
error_4 = abs(f - estimated_freq_4)/f * 100;   % estimated error

% plot the estimated frequency with different noise variance
figure
plot([f, f, f, f], 's--', 'LineWidth',2, 'MarkerSize',8, 'MarkerEdgeColor','g')
hold on
plot([estimated_freq_1, estimated_freq_2, estimated_freq_3, estimated_freq_4], 's--', 'LineWidth',2, 'MarkerSize',8, 'MarkerEdgeColor','g')
set(gca, 'xtick',1:4, 'xticklabel',{0.1, 0.5, 1, 5})
xlabel('Variacne')
ylabel('Estimated frequency')
legend('Real', 'Estimated')
title('Estimated frequency with different noise variance')

% plot the estimated error with different noise variance
figure
plot([error_1, error_2, error_3, error_4], 's--', 'LineWidth',2, 'MarkerSize',8, 'MarkerEdgeColor','r')
set(gca, 'xtick',1:4, 'xticklabel',{0.1, 0.5, 1, 5})
xlabel('Variacne')
ylabel('Error (%)')
title('Percentage estimation error with different noise variance')
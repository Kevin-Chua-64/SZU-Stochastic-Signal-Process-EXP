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

% Estimate the average power
Ps = x*x' / length(x);



% Matched filter
filter = fliplr(x);
figure
plot(t, filter)
title('Matched filter of the signal')

% Generate receive system with noise
N = 500;                        % N trail
T_r = 1;                        % Receive system length
t_r = 0: 1/Fs: T_r-1/Fs;

% SNR in receive system
SNR = -25: 2: -10;              % SNR = 10*log10(Ps/noise_power);

mse = zeros(1, length(SNR));
success_rate = zeros(1, length(SNR));
for i=1:length(SNR)
    % Receive system
    noise_power = Ps / (10^(SNR(i)/10));
    system = sqrt(noise_power)*randn(size(t_r));
    
    true_time = zeros(1, N);
    estimated_time = zeros(1, N);
    success = zeros(1, N);
    for j=1:N
        % The end of the receive signal
        ending_time = 0.1 + 0.9*rand(1);
        ending_point = round(ending_time/T_r * length(system));
        % Insert the signal
        receive = system;
        receive(ending_point-length(x)+1: ending_point) = x + receive(ending_point-length(x)+1: ending_point);

        % Estimate the end
        y = conv(receive, filter);
        [maxi, index] = max(y);
        estimated_ending_time = index * T_r / length(receive);

        % Statistic
        true_time(j) = ending_time;
        estimated_time(j) = estimated_ending_time;
        if abs(ending_time-estimated_ending_time) < 0.03
            success(j) = 1;
        end
    end

    % MSE and success rate
    mse(i) = mean((true_time-estimated_time).^2);
    success_rate(i) = sum(success) / N;
end

figure
plot(t_r, receive)
title('The received signal')
legend(strcat('From ', num2str(ending_time-0.1), 's to ', num2str(ending_time), 's'))
figure
plot(t_r, y(1:length(receive)))
title('The result of the matched filter')

figure
plot(SNR, mse)
xlabel('SNR')
ylabel('MSE')
title('MSE under different SNR')
figure
plot(SNR, success_rate)
xlabel('SNR')
ylabel('Success rate')
title('Success rate under different SNR')
clc
clear

T = 0.1;                              % signal length
f0 = 1000;                            % signal basic frequency
k = 9000;                             % coefficient

% Calculate signal frequency by derivation
syms tt
f = tt*(f0 + k*tt);
f_ = diff(f, tt);
% Sample rate = 5 * 2*signal frequency
Fs = double(10*subs(f_, tt, T));

t = 0: 1/Fs: T-1/Fs;                  % sample
x1 = sin(2*pi*(t.*(f0+k.*t)));        % signal 1
x2 = sin(2*pi*(t.*(f0+k.*t))+pi/3);   % signal 2

% Estimate the average power
Ps1 = x1*x1' / length(x1);
Ps2 = x2*x2' / length(x2);



% Matched filter of signal 1
filter = fliplr(x1);

% Generate receive system with noise
N = 500;                        % N trail
T_r = 1;                        % Receive system length
t_r = 0: 1/Fs: T_r-1/Fs;

% SNR in receive system
SNR = -25: 3: -10;              % SNR = 10*log10(Ps/noise_power);

mse1 = zeros(1, length(SNR));
success_rate1 = zeros(1, length(SNR));
mse2 = zeros(1, length(SNR));
success_rate2 = zeros(1, length(SNR));
for i=1:length(SNR)
    % Receive system
    noise_power1 = Ps1 / (10^(SNR(i)/10));
    system1 = sqrt(noise_power1)*randn(size(t_r));
    noise_power2 = Ps2 / (10^(SNR(i)/10));
    system2 = sqrt(noise_power2)*randn(size(t_r));
    
    true_time1 = zeros(1, N);
    estimated_time1 = zeros(1, N);
    success1 = zeros(1, N);
    true_time2 = zeros(1, N);
    estimated_time2 = zeros(1, N);
    success2 = zeros(1, N);
    for j=1:N
        % The end of the receive signal
        ending_time1 = 0.1 + 0.9*rand(1);
        ending_point1 = round(ending_time1/T_r * length(system1));
        ending_time2 = 0.1 + 0.9*rand(1);
        ending_point2 = round(ending_time2/T_r * length(system2));
        % Insert the signal
        receive1 = system1;
        receive1(ending_point1-length(x1)+1: ending_point1) = x1 + receive1(ending_point1-length(x1)+1: ending_point1);
        receive2 = system2;
        receive2(ending_point2-length(x2)+1: ending_point2) = x2 + receive2(ending_point2-length(x2)+1: ending_point2);

        % Estimate the end
        y1 = conv(receive1, filter);
        [max1, index1] = max(y1);
        estimated_ending_time1 = index1 * T_r / length(receive1);
        y2 = conv(receive2, filter);
        [max2, index2] = max(y2);
        estimated_ending_time2 = index2 * T_r / length(receive2);

        % Statistic
        true_time1(j) = ending_time1;
        estimated_time1(j) = estimated_ending_time1;
        if abs(ending_time1-estimated_ending_time1) < 0.03
            success1(j) = 1;
        end
        true_time2(j) = ending_time2;
        estimated_time2(j) = estimated_ending_time2;
        if abs(ending_time2-estimated_ending_time2) < 0.03
            success2(j) = 1;
        end
    end

    % MSE and success rate
    mse1(i) = mean((true_time1-estimated_time1).^2);
    success_rate1(i) = sum(success1) / N;
    mse2(i) = mean((true_time2-estimated_time2).^2);
    success_rate2(i) = sum(success2) / N;
end

figure
plot(SNR, mse1)
hold on
plot(SNR, mse2)
legend('Origin', '\pi/3')
xlabel('SNR')
ylabel('MSE')
title('MSE under different SNR')
figure
plot(SNR, success_rate1)
hold on
plot(SNR, success_rate2)
legend('Origin', '\pi/3')
xlabel('SNR')
ylabel('Success rate')
title('Success rate under different SNR')
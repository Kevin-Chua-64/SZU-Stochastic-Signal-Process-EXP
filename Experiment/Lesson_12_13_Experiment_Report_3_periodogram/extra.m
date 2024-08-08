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
% The original filter
x00 = sin(2*pi*(t.*(f0+k.*t)));
filter = fliplr(x00);

% Estimate the average power
Ps = x00*x00' / length(x00);

% Use much filter and select the highest SNR
angles = -pi: 0.5*pi: pi;
filters = zeros(length(angles), Fs*T);
x0 = zeros(length(angles), Fs*T);
for i=1:length(angles)
    x0(i,:) = sin(2*pi*(t.*(f0+k.*t))+angles(i));

    % Matched filters of original signals
    filters(i,:) = fliplr(x0(i,:));
end

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
mse3 = zeros(1, length(SNR));
success_rate3 = zeros(1, length(SNR));
for i=1:length(SNR)
    % Receive system
    noise_power = Ps / (10^(SNR(i)/10));
    system = sqrt(noise_power)*randn(size(t_r));
    
    true_time = zeros(1, N);
    estimated_time1 = zeros(1, N);
    success1 = zeros(1, N);
    estimated_time2 = zeros(1, N);
    success2 = zeros(1, N);
    estimated_time3 = zeros(1, N);
    success3 = zeros(1, N);
    for j=1:N
        % The end of the receive signal
        ending_time = 0.1 + 0.9*rand(1);
        ending_point = round(ending_time/T_r * length(system));
        % Insert the stochastic signal
        phi = -pi + 2*pi*rand(1);
        x = sin(2*pi*(t.*(f0+k.*t)) + phi);
        receive = system;
        receive(ending_point-length(x)+1: ending_point) = x + receive(ending_point-length(x)+1: ending_point);

        % Estimate the end
        y11 = zeros(length(angles), length(receive)+Fs*T-1);
        max11 = zeros(1, length(angles));
        index11 = zeros(1, length(angles));
        for m=1:length(angles)
            y11(m,:) = conv(receive, filters(m,:));
            [max11(m), index11(m)] = max(y11(m,:));
        end
        % The highest SNR is more like to be correct
        [max1, index1] = max(max11);
        estimated_ending_time1 = index11(index1) * T_r / length(receive);
        
        % Relative filter
        filter2 = fliplr(x);
        y2 = conv(receive, filter2);
        [max2, index2] = max(y2);
        estimated_ending_time2 = index2 * T_r / length(receive);
                
        % Original filter
        y3 = conv(receive, filter);
        [max3, index3] = max(y3);
        estimated_ending_time3 = index3 * T_r / length(receive);

        % Statistic
        true_time(j) = ending_time;
        estimated_time1(j) = estimated_ending_time1;
        estimated_time2(j) = estimated_ending_time2;
        estimated_time3(j) = estimated_ending_time3;
        if abs(ending_time-estimated_ending_time1) < 0.03
            success1(j) = 1;
        end
        if abs(ending_time-estimated_ending_time2) < 0.03
            success2(j) = 1;
        end
        if abs(ending_time-estimated_ending_time3) < 0.03
            success3(j) = 1;
        end
    end

    % MSE and success rate
    mse1(i) = mean((true_time-estimated_time1).^2);
    success_rate1(i) = sum(success1) / N;
    mse2(i) = mean((true_time-estimated_time2).^2);
    success_rate2(i) = sum(success2) / N;
    mse3(i) = mean((true_time-estimated_time3).^2);
    success_rate3(i) = sum(success3) / N;
end

figure
plot(SNR, mse1)
hold on
plot(SNR, mse2)
hold on
plot(SNR, mse3)
legend('Design', 'Relevant (best)', 'Original')
xlabel('SNR')
ylabel('MSE')
title('MSE under different SNR')
figure
plot(SNR, success_rate1)
hold on
plot(SNR, success_rate2)
hold on
plot(SNR, success_rate3)
legend('Design', 'Relevant (best)', 'Original')
xlabel('SNR')
ylabel('Success rate')
title('Success rate under different SNR')
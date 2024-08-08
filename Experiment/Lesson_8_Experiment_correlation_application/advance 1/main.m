clear
clc
load noise.mat            % load the special noise if needed

[sig_ori,FS]=audioread('test_audio.wav'); % read the audio, the sig_ori is the signal with a sampling rate FS
sig_ori = sig_ori';
Lsig = length(sig_ori);   % the length of the signal
dt=1/FS;                  % the dt is the samping interval, which is, for dt second, there will be one sample of the speech
t=0: dt: Lsig/FS;
t=t(1: Lsig);             % total seconds
SNR_dB = 60;              % this indicate the Signal_to_Noise_Ratio = 10 * log_10(signal_power / noise_power)
Is_add_special_noise = 1; % if 0, add random noise; otherwise, add predefined noise

M = 4;                    % the number of microphones
c = 340;                  % The speed sound travels through the air is 340m/s

% the location of the microphones
Loc(1,:) = [0, 25, 50, 75]; 
Loc_M_x = Loc(1, :);
Loc(2,:) = [0, 5, 0, 5];
Loc_M_y = Loc(2, :);
% source located in (1, 1)m
xs=1;
ys=1;

% distance between microphones and source
Rsm=[];
for q=1:M
    rsm=sqrt((xs-Loc_M_x(q))^2+(ys-Loc_M_y(q))^2);
    Rsm=[Rsm rsm];        % distance between microphones and source
end
TD=Rsm/c;                 % trasmission time
L_TD=TD/dt;
L_TD=fix(L_TD);           % the number of the samples in trasmission time

% generate recieved signals
Signal_Received=[];
signal_power = sig_ori*sig_ori'/Lsig;                     % calculate signal power
noise_power = signal_power/(10^(SNR_dB/10));              % noise power
% adding noise
for p=1:M    
    noise = sqrt(noise_power)*randn(1, Lsig);             % random noise
    if Is_add_special_noise==0
        sig_noise =  sig_ori + noise;
    else
        sig_noise =  sig_ori + sqrt(noise_power)*noise_default(p, 1:Lsig);
    end   
    
    Signal_with_noise=[sqrt(noise_power)*randn(1, L_TD(p)), sig_noise, sqrt(noise_power)*randn(1, max(L_TD)-L_TD(p))]; % add the time delay with noise 
    Signal_Received=[Signal_Received; Signal_with_noise]; % signal recieved in each microphone
end

% x-axis
Signal_Received_size = size(Signal_Received);             % recieved signal size(2) (number of samples)
plot_time=0:dt:(Signal_Received_size(2)-1)/FS;
Signal_Re_1 = Signal_Received(1,:);                       % the signal received in the first microphone
Signal_Re_Sum = sum(Signal_Received,1);                   % directly sum the signal from the M microphones

% plot and output the signal received in microphone 1
figure()
plot(plot_time,Signal_Re_1)
title('Signal-First')
Signal_Re_1=Signal_Re_1./max(Signal_Re_1);                % normalization
audiowrite('Signal-First.wav',Signal_Re_1,FS);            % store

% plot and output the Sum of the signal received from all microphones directly
figure()
plot(plot_time,Signal_Re_Sum)
title('Signal-Direct-Sum')
Signal_Re_Sum=Signal_Re_Sum./max(Signal_Re_Sum);          % normalization
audiowrite('Signal-Direct-Sum.wav',Signal_Re_Sum,FS);     % store

% plot all the received signal in one figure
figure()
plot(plot_time, Signal_Received', 'DisplayName','Signal_Received')
title('All Signal')

% calculate the delay
x1 = Signal_Received(1,:);                  % microphone 1
x2 = Signal_Received(2,:);                  % microphone 2
x3 = Signal_Received(3,:);                  % microphone 3
x4 = Signal_Received(4,:);                  % microphone 4
Max_lag = 8000; % assume that the maximum distance between any two microphones is less than 170m, which is 0.5s, which is 8000 samples
R_12 = xcorr(x1, x2, Max_lag, 'coeff');     % cross correlation coefficient between microphone 1, 2
R_13 = xcorr(x1, x3, Max_lag, 'coeff');     % cross correlation coefficient between microphone 1, 3
R_14 = xcorr(x1, x4, Max_lag, 'coeff');     % cross correlation coefficient between microphone 1, 4

% plot the Cross-Correlation
lag_list = -Max_lag:Max_lag;
figure()
plot(lag_list, R_12) 
title('the Cross-Correlation between microphone 1, 2')
figure()
plot(lag_list, R_13) 
title('the Cross-Correlation between microphone 1, 3')
figure()
plot(lag_list, R_14) 
title('the Cross-Correlation between microphone 1, 4')

[Lag_12_value, Lag_12_index] = max(R_12);   % the index of the maximum correlation coefficient between microphone 1, 2
[Lag_13_value, Lag_13_index] = max(R_13);   % the index of the maximum correlation coefficient between microphone 1, 3
[Lag_14_value, Lag_14_index] = max(R_14);   % the index of the maximum correlation coefficient between microphone 1, 4
Lag_12_estimate = Lag_12_index-(Max_lag+1); % the lag between microphone 1 and 2, which is ┏
Lag_13_estimate = Lag_13_index-(Max_lag+1); % the lag between microphone 1 and 3, which is ┏
Lag_14_estimate = Lag_14_index-(Max_lag+1); % the lag between microphone 1 and 4, which is ┏

Real_lag_12 = L_TD(1)-L_TD(2);              % real lag (negative if microphone 1 leads)
Real_lag_13 = L_TD(1)-L_TD(3);              % real lag (negative if microphone 1 leads)
Real_lag_14 = L_TD(1)-L_TD(4);              % real lag (negative if microphone 1 leads)
% estimation error of microphone 1 and other microphones (positive if microphone 1 leads after correction)
error_12 = Lag_12_estimate - Real_lag_12
error_13 = Lag_13_estimate - Real_lag_13
error_14 = Lag_14_estimate - Real_lag_14
disp('(The error will be positive if microphone 1 leads after correction)')

% Pre-processing
% pad zeros
padding = abs(Lag_12_estimate)+abs(Lag_13_estimate)+abs(Lag_14_estimate);
x1_pad_zero = [zeros(1, padding), x1, zeros(1, padding)];
x2_pad_zero = [zeros(1, padding), x2, zeros(1, padding)];
x3_pad_zero = [zeros(1, padding), x3, zeros(1, padding)];
x4_pad_zero = [zeros(1, padding), x4, zeros(1, padding)];

% find the most leading microphone
Lag_11_estimate = 0;                                     % microphone auto correlation coefficient is obviously 0, so lag is 0
[Lag_value, microphone_index] = max([Lag_11_estimate; Lag_12_estimate; Lag_13_estimate; Lag_14_estimate]);
The_nearest_microphone_to_the_source = microphone_index
% others lag estimation
[Lag_22_estimate, Lag_33_estimate, Lag_44_estimate] = deal(0);
[Lag_23_estimate, Lag_24_estimate, Lag_34_estimate] = deal(Lag_13_estimate-Lag_12_estimate, Lag_14_estimate-Lag_12_estimate, Lag_14_estimate-Lag_13_estimate);
[Lag_21_estimate, Lag_31_estimate, Lag_32_estimate, Lag_41_estimate, Lag_42_estimate, Lag_43_estimate] = deal(-Lag_12_estimate, -Lag_13_estimate, -Lag_23_estimate, -Lag_14_estimate, -Lag_24_estimate, -Lag_34_estimate);

% Align the signals with correct lag
correction_length = padding + Signal_Received_size(2);   % signal length after correction
for i=1:M
    eval(['x', num2str(i), '_with_lag = x', num2str(i), '_pad_zero(1-Lag_', num2str(microphone_index), num2str(i), '_estimate: (1-Lag_', num2str(microphone_index), num2str(i), '_estimate) + correction_length-1);'])
end    
% % An example for the loop above
% % if the microphone_index is 1
% x1_with_lag = x1_pad_zero(1-Lag_11_estimate: (1-Lag_11_estimate) + correction_length-1);
% x2_with_lag = x2_pad_zero(1-Lag_12_estimate: (1-Lag_12_estimate) + correction_length-1);
% x3_with_lag = x3_pad_zero(1-Lag_13_estimate: (1-Lag_13_estimate) + correction_length-1);
% x4_with_lag = x4_pad_zero(1-Lag_14_estimate: (1-Lag_14_estimate) + correction_length-1);
%
% % if the microphone_index is 2
% x1_with_lag = x1_pad_zero(1-Lag_21_estimate: (1-Lag_21_estimate) + correction_length-1);
% x2_with_lag = x2_pad_zero(1-Lag_22_estimate: (1-Lag_22_estimate) + correction_length-1);
% x3_with_lag = x3_pad_zero(1-Lag_23_estimate: (1-Lag_23_estimate) + correction_length-1);
% x4_with_lag = x4_pad_zero(1-Lag_24_estimate: (1-Lag_24_estimate) + correction_length-1);

Correct_Sum_with_lag = x1_with_lag+x2_with_lag+x3_with_lag+x4_with_lag;     % sum correctly

% plot and output the Sum of the signal with correct lag
figure()
plot_time2=0:dt:(correction_length-1)/FS;
plot(plot_time2, Correct_Sum_with_lag)
title('Signal-Correct-Sum')
Correct_Sum_with_lag=Correct_Sum_with_lag./max(Correct_Sum_with_lag);       % normalization
audiowrite('Signal-Correct-Sum.wav',Correct_Sum_with_lag,FS);               % store
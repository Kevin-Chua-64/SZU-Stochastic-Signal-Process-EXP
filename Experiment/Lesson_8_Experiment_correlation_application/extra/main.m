clear
clc
load noise.mat            % load the special noise if needed

[sig_ori,FS]=audioread('test_audio.wav'); % read the audio, the sig_ori is the signal with a sampling rate FS
sig_ori = sig_ori';
Lsig = length(sig_ori);   % the length of the signal
dt=1/FS;                  % the dt is the samping interval, which is, for dt second, there will be one sample of the speech
t=0: dt: Lsig/FS;
t=t(1: Lsig);             % total seconds
SNR_dB = 20;              % this indicate the Signal_to_Noise_Ratio = 10 * log_10(signal_power / noise_power)
Is_add_special_noise = 1; % if 0, add random noise; otherwise, add predefined noise

M = 16;                   % the number of microphones
c = 340;                  % The speed sound travels through the air is 340m/s

% the location of the microphones
Loc(1,:)=zeros(1, M); 
Loc_M_x=Loc(1,:);
Loc(2,:)=linspace(0, 0.17*(M-1), M);
Loc_M_y=Loc(2,:);
% source located in (0, 10)m
xs=0;
ys=10;

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

Signal_Received_size = size(Signal_Received);             % recieved signal size(2) (number of samples)

% plot and output the signal received in microphone 1
plot_time=0:dt:(Signal_Received_size(2)-1)/FS;
Signal_Re_1 = Signal_Received(1,:);                       % the signal received in the first microphone

figure()
plot(plot_time,Signal_Re_1)
title('Signal-First')

% the recieved signals
for i=1:M
    eval(['x', num2str(i), ' = Signal_Received(', num2str(i), ',:);'])
end
% % An example for once in the loop above
% x1 = Signal_Received(1,:);                % microphone 1

% calculate the delay
Max_lag = 8000; % assume that the maximum distance between any two microphones is less than 170m, which is 0.5s, which is 8000 samples
R_12 = xcorr(x1, x2, Max_lag, 'coeff');     % cross correlation coefficient between microphone 1, 2

% Cross-Correlation
[Lag_12_value, Lag_12_index] = max(R_12);   % the index of the maximum correlation coefficient between microphone 1, 2
Lag_12_estimate = Lag_12_index-(Max_lag+1); % the lag between microphone 1 and 2

Real_lag = L_TD(1)-L_TD(2);                 % real lag (negative if microphone 1 leads)
% estimation error of microphone 1 and 2 (positive if microphone 1 leads after correction)
error = Lag_12_estimate - Real_lag
disp('(The error will be positive if microphone 1 leads after correction)')

% Pre-processing
% pad zeros
padding = (M-1) * Lag_12_estimate;
for i=1:M
    eval(['x', num2str(i), '_pad_zero = [x', num2str(i), ', zeros(1, padding)];'])
end
% % An example for once in the loop above
% x1_pad_zero = [x1, zeros(1, padding)];

% Align the signals with correct lag (Note that the lags between adjacent microphones are the same)
correction_length = Signal_Received_size(2);              % signal length after correction
for i=1:M
    eval(['x', num2str(i), '_with_lag = x', num2str(i), '_pad_zero(1 + (M-', num2str(i), ')*Lag_12_estimate: (1 + (M-', num2str(i), ')*Lag_12_estimate) + correction_length-1);'])
end
% % An example for first two times in the loop above
% x1_with_lag = x1_pad_zero(1 + (M-1)*Lag_12_estimate: (1 + (M-1)*Lag_12_estimate) + correction_length-1);
% x2_with_lag = x2_pad_zero(1 + (M-2)*Lag_12_estimate: (1 + (M-2)*Lag_12_estimate) + correction_length-1);

% the sum of the signal with correct lag
Correct_Sum_with_lag = 0;
for i=1:M
    eval(['Correct_Sum_with_lag = Correct_Sum_with_lag + x', num2str(i), '_with_lag;'])
end
% % An example for first two times in the loop above
% Correct_Sum_with_lag = Correct_Sum_with_lag + x1_with_lag;
% Correct_Sum_with_lag = Correct_Sum_with_lag + x2_with_lag;

% plot and output the Sum of the signal with correct lag
figure()
plot_time2=0:dt:(correction_length-1)/FS;
plot(plot_time2, Correct_Sum_with_lag)
title('Signal-Correct-Sum')
Correct_Sum_with_lag=Correct_Sum_with_lag./max(Correct_Sum_with_lag);       % normalization
audiowrite('Signal-Correct-Sum.wav',Correct_Sum_with_lag,FS);               % store
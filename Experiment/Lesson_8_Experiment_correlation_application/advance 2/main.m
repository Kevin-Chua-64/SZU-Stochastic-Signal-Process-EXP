clear
clc
load noise.mat            % load the special noise if needed

[sig_ori,FS]=audioread('test_audio.wav'); % read the audio, the sig_ori is the signal with a sampling rate FS
sig_ori = sig_ori';
Lsig = length(sig_ori);   % the length of the signal
dt=1/FS;                  % the dt is the samping interval, which is, for dt second, there will be one sample of the speech
t=0: dt: Lsig/FS;
t=t(1: Lsig);             % total seconds
SNR_dBs = [-20, -10, 0, 10, 20, 30, 40]; % this indicate the Signal_to_Noise_Ratio = 10 * log_10(signal_power / noise_power)
Is_add_special_noise = 0; % if 0, add random noise; otherwise, add predefined noise

M = 2;                    % the number of microphones
independent_runs = 100;   % looping 100 independent times
c = 340;                  % The speed sound travels through the air is 340m/s

lags = zeros(length(SNR_dBs), independent_runs);       % correct if 1
RRs = zeros(length(SNR_dBs), independent_runs);        % correct if 1

% the location of the microphones
Loc(1,:) = [0, 50]; 
Loc_M_x = Loc(1, :);
Loc(2,:) = [0, 10];
Loc_M_y = Loc(2, :);
% source located in (1, 1)m
xs=1;
ys=1;

% distance between microphones and source
Rsm=[];
for q=1:M
    rsm=sqrt((xs-Loc_M_x(q))^2+(ys-Loc_M_y(q))^2);
    Rsm=[Rsm rsm];             % distance between microphones and source
end
TD=Rsm/c;                      % trasmission time
L_TD=TD/dt;
L_TD=fix(L_TD);                % the number of the samples in trasmission time

Real_lag_12 = L_TD(1)-L_TD(2); % real lag (negative if microphone 1 leads)

for SNR_dB = 1:length(SNR_dBs)
    for independent_run = 1:independent_runs
        % generate recieved signals
        Signal_Received=[];
        signal_power = sig_ori*sig_ori'/Lsig;                     % calculate signal power
        noise_power = signal_power/(10^(SNR_dBs(SNR_dB)/10));     % noise power
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

        % Evaluate through correct lag detection

        % calculate the delay
        x1 = Signal_Received(1,:);                  % microphone 1
        x2 = Signal_Received(2,:);                  % microphone 2
        Max_lag = 8000; % assume that the maximum distance between any two microphones is less than 170m, which is 0.5s, which is 8000 samples
        R_12 = xcorr(x1, x2, Max_lag, 'coeff');     % cross correlation coefficient between microphone 1, 2

        [Lag_12_value, Lag_12_index] = max(R_12);   % the index of the maximum correlation coefficient between microphone 1, 2
        Lag_12_estimate = Lag_12_index-(Max_lag+1); % the lag between microphone 1 and 2, which is ┏

        % Evaluate
        correct_lag_detection = Lag_12_estimate == Real_lag_12;

        % Evaluate through autocorrealtion
        RR = xcorr(x1+x2, Max_lag, 'coeff');        % directly sum signal autocorrealtion
        RR_ = RR;
        RR_(Max_lag-999 : end) = 0;                 % set the center and latter part to 0 
        [max_, RR_index] = max(RR_);                % find the peak
        RR_estimated = RR_index - (Max_lag+1);      % time difference
        
        % Evaluate
        RR_detection = RR_estimated == Real_lag_12;
        
        % Statistic
        lags(SNR_dB, independent_run) = correct_lag_detection;
        RRs(SNR_dB, independent_run) = RR_detection;
    end
end

% plot the directly sum signal autocorrealtion with the last applied SNR_db
figure
plot(1-Max_lag:1+Max_lag, RR)
xlim([-Max_lag, Max_lag])
title('The autocorrealtion of directly sum signal')

% the probability of success 
success_rate1 = mean(lags, 2);
figure
subplot(1, 2, 1)
plot(success_rate1, 's--', 'LineWidth',1.5, 'MarkerSize',5, 'MarkerEdgeColor','r')
set(gca, 'xtick',1:length(SNR_dBs), 'xticklabel',{SNR_dBs})
xlabel('SNR')
ylabel('Success rate')
title('The probability of success under different SNR from lag detection')

success_rate2 = mean(RRs, 2);
subplot(1, 2, 2)
plot(success_rate2, 's--', 'LineWidth',1.5, 'MarkerSize',5, 'MarkerEdgeColor','r')
set(gca, 'xtick',1:length(SNR_dBs), 'xticklabel',{SNR_dBs})
xlabel('SNR')
ylabel('Success rate')
title('The probability of success under different SNR from RR detection')
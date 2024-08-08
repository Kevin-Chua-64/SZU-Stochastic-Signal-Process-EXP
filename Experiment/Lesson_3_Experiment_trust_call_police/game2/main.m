clear;
clc;
warning off
% counterparty action: 0 trust, others betray
% your action: 0 trust, others call police
% the return: 0 fail, 1 success

independent_runs = 10000;                          % evaluate the strategy with 10000 independent runs
return_result = ones(independent_runs, 1);         % store the result of all the return scores with my strategy
return_result_ = ones(independent_runs, 1);        % store the result of all the return scores with random strategy
prob_predict = zeros(independent_runs, 1);         % store the result of all the counterparty predicted betray probability
prob_result = zeros(independent_runs, 1);          % store the result of all the counterparty true betray probability
my_choice = zeros(independent_runs, 1);            % store the result of my strategy

for n_run = 1 : independent_runs                   % looping
    % calculate 100 friends' result
    counterparty_previous_action = zeros(100, 100);     % the counterparty action before
    counterparty_previous_action_list = rand(100, 100);
    counterparty_betray_prob = 0.4 + 0.3.*rand(1);
    for i = 1 : 100
        counterparty_previous_action(i, :) = double(counterparty_betray_prob > counterparty_previous_action_list(i, :));
    end
    
    % trade with me
    counterparty_action = double(counterparty_betray_prob > rand(1));
    [Your_Strategy, predict_betray_prob] = Your_Strategies(counterparty_previous_action);
    random_strategy = double(rand(1) > 0.5);            % Set a random strategy decision
    % my strategy
    if Your_Strategy==0
        if counterparty_action==0
            return_result(n_run) = 1;          % both trust, success
        else
            return_result(n_run) = 0;          % self trust, counterparty betray, fail
        end
    else
        if counterparty_action==0
            return_result(n_run) = 0;          % self call police, counterparty trust, fail
        else
            return_result(n_run) = 1;          % self call police, counterparty betray, success
        end
    end
    % random strategy
    if random_strategy==0
        if counterparty_action==0
            return_result_(n_run) = 1;         % both trust, success
        else
            return_result_(n_run) = 0;         % self trust, counterparty betray, fail
        end
    else
        if counterparty_action==0
            return_result_(n_run) = 0;         % self call police, counterparty trust, fail
        else
            return_result_(n_run) = 1;         % self call police, counterparty betray, success
        end
    end
    
    prob_predict(n_run) = predict_betray_prob;         % store the counterparty predicted betray probability in this trade
    prob_result(n_run) = counterparty_betray_prob;     % store the counterparty true betray probability in this trade
    my_choice(n_run) = Your_Strategy;                  % store my choice in this trade
end

% trade finished

% evaluate
my_success_rate = sum(return_result) / independent_runs   % print the success rate with my strategy
random_success_rate = sum(return_result_) / independent_runs   % print the success rate with random strategy
MSE = mean((prob_predict - prob_result).^2)            % print the mean square error between predicted and true betray probability

% predicted and true counterparty betray probability
figure
plot(linspace(1, independent_runs, independent_runs), prob_predict)
hold on
plot(linspace(1, independent_runs, independent_runs), prob_result, 'r')
hold off
legend('predicted', 'true')
xlim([0, 100])
ylim([0.3, 0.8])
set(gca, 'xtick',1:independent_runs, 'xticklabel',{})
title('predicted and true counterparty betray probability')

% the histogram of counterparty betray probability
figure
histogram(prob_result, 'Normalization', 'pdf')
hold on
x = 0.3: 0.001: 0.9;
[f, x] = ksdensity(prob_result, x);    % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold on
y = unifpdf(x, 0.4, 0.7);              % truth pdf;
plot(x, y, 'linewidth', 1.5);
hold off
xlim([0.3, 0.9])
legend('histogram', 'betray pdf', 'theoretical pdf')
xlabel('the counterparty betray probability')
title('The histogram of counterparty betray probability')

% my choice
call_police = length(find(my_choice == 1));
trust = length(find(my_choice == 0));
figure
bar([call_police, trust])
set(gca, 'xtick',1:2, 'xticklabel',{'call police', 'trust'})
ylim([0, 11000])
title('Bar graph of my choice in each trade')

% random strategy
success_ = length(find(return_result_ == 1));
fail_ = length(find(return_result_ == 0));
figure
subplot(1, 2, 1)
bar([fail_, success_])
set(gca, 'xtick',1:2, 'xticklabel',{'fail', 'success'})
title('Bar graph of each trade result with random strategy')
% my strategy
success = length(find(return_result == 1));
fail = length(find(return_result == 0));
subplot(1, 2, 2)
bar([fail, success])
set(gca, 'xtick',1:2, 'xticklabel',{'fail', 'success'})
title('Bar graph of each trade result with my strategy')

% relationship between success rate and probability
% divide the probability into intervals
interval = 15;
point = linspace(0.4, 0.7, interval+1);
% create variables to store the result
intervals = zeros(interval, 1);
interval_result = zeros(interval, 1);
for i = 1: interval
    eval(['interval_',num2str(i), ' = 0.4+0.025*', num2str(i), ';'])
    eval(['interval_result_', num2str(i), ' = 0.5;'])
end

% assign values (This cycle might take time)
for i = 1: independent_runs
    for j = 1: interval
        if point(j) < prob_result(i) && prob_result(i) < point(j+1)
            eval(['interval_', num2str(j), ' = [interval_', num2str(j), '; prob_result(', num2str(i), ')];'])
            eval(['interval_result_', num2str(j), ' = [interval_result_', num2str(j), '; return_result(', num2str(i), ')];'])
        end
    end
end

% calculate the mean value
for i = 1: interval
    eval(['intervals(',num2str(i), ') = mean(interval_', num2str(i), ');'])
    eval(['interval_result(', num2str(i), ') = mean(interval_result_', num2str(i), ');'])
end

figure
plot(intervals, interval_result, 'linewidth',3)
xlabel('counterparty betray probability')
ylabel('success rate')
xlim([0.3, 0.7])
ylim([0.4, 0.8])
title('Diagram of succcess rate-betray probability')
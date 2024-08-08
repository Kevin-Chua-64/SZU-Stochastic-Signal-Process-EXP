clear;
clc;
warning off
% the above two commands clear all the previous record in the Memory
% counterparty action: 0 trust, others betray
% your action: 0 trust, others call police

independent_runs = 1000;                           % evaluate the strategy with 1000 independent runs
return_result = zeros(independent_runs, 1);        % store the result of all the return scores with my strategy
return_result_ = zeros(independent_runs, 1);       % store the result of all the return scores with random strategy
prob_predict = zeros(independent_runs, 1);         % store the result of all the counterparty predicted betray probability
prob_result = zeros(independent_runs, 1);          % store the result of all the counterparty true betray probability

for n_run = 1 : independent_runs                   % looping
    N_trades = 100;                                % trade N_trades times
    Return_total = 0;                              % the retrun using my strategy
    random_strategy_score = 0;                     % the return using random strategy
    counterparty_betray_prob = rand(1);            % randomly initial the probability of betray of the counterparty
    % note that it will last for the whole game
    counterparty_previous_action_list = rand(10,1);
    counterparty_previous_action = double(counterparty_betray_prob > counterparty_previous_action_list);

    for n_trade = 1 : N_trades                     % looping
        [Your_Strategy, predict_betray_prob] = Your_Strategies(counterparty_previous_action);
        % this time, you can pass anything you want into the 'Your_Strategies',
        % except the 'counterparty_betray_prob'
        % you can change the whole system as you wish
        random_strategy = double(rand(1) > 0.5);   % Set a random strategy decision
        counterparty_action = double(counterparty_betray_prob > rand(1));
        counterparty_previous_action = [counterparty_previous_action; counterparty_action];     % add the results of each trade to counterparty_action
        % my strategy
        if Your_Strategy==0
            if counterparty_action==0
                Return_current = 10;        % both trust, add 10 points
            else
                Return_current = -10;       % self trust, counterparty betray, -10 points
            end
        else
            if counterparty_action==0
                Return_current = -10;       % self call police, counterparty trust, -10 points
            else
                Return_current = 10;        % self call police, counterparty betray, 10 points
            end
        end
        Return_total = Return_total + Return_current;        % update the return
        % random strategy
        if random_strategy==0
            if counterparty_action==0
                Return_current_ = 10;        % both trust, add 10 points
            else
                Return_current_ = -10;       % self trust, counterparty betray, -10 points
            end
        else
            if counterparty_action==0
                Return_current_ = -10;       % self call police, counterparty trust, -10 points
            else
                Return_current_ = 10;        % self call police, counterparty betray, 10 points
            end
        end
        random_strategy_score = random_strategy_score + Return_current_;        % update the return
    end
    
    return_result(n_run) = Return_total;                     % store my strategy return of this trade
    return_result_(n_run) = random_strategy_score;           % store random strategy return of this trade
    prob_predict(n_run) = predict_betray_prob;               % store the predicted counterparty betray probability of this trade
    prob_result(n_run) = counterparty_betray_prob;           % store the true counterparty betray probability of this trade
end

% trade finished

% evaluate
my_average_scores = sum(return_result)/independent_runs       % print my average scores
random_average_scores = sum(return_result_)/independent_runs  % print random average scores
MSE = mean((prob_predict - prob_result).^2)                   % print the mean square error between predicted and true betray probability

% predicted and true counterparty betray probability
figure
plot(linspace(1, independent_runs, independent_runs), prob_predict)
hold on
plot(linspace(1, independent_runs, independent_runs), prob_result, 'r')
hold off
legend('predicted', 'true')
xlim([0, 100])
ylim([0, 1])
set(gca, 'xtick',1:independent_runs, 'xticklabel',{})
title('predicted and true counterparty betray probability')

% the histogram of counterparty betray probability
figure
histogram(prob_result, 'Normalization', 'pdf')
hold on
x = -0.1: 0.001: 1.8;
[f, x] = ksdensity(prob_result, x);       % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold on
y = unifpdf(x, 0, 1);                     % truth pdf;
plot(x, y, 'linewidth', 1.5);
hold off
xlim([-0.1, 1.8])
legend('histogram', 'betray pdf', 'theoretical pdf')
xlabel('the counterparty betray probability')
title('The histogram of counterparty betray probability')

% random strategy
figure
subplot(1, 2, 1)
histogram(return_result_, 'Normalization', 'pdf')
hold on
x = -1000: 20: 1000;
[f, x] = ksdensity(return_result_, x);    % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold off
xlim([-1000, 1000])
legend('histogram', 'pdf', 'location','NorthWest')
xlabel('scores')
title('Histogram of each trade scores with random strategy')
% my strategy
subplot(1, 2, 2)
histogram(return_result, 'Normalization', 'pdf')
hold on
x = -1000: 20: 1000;
[f, x] = ksdensity(return_result, x);     % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold off
xlim([-1000, 1000])
legend('histogram', 'pdf', 'location','NorthWest')
xlabel('scores')
title('Histogram of each trade scores with my strategy')

% relationship between scores and betray probability
figure
scatter(prob_result, return_result, 50, 'filled')
xlabel('counterparty betray probability')
ylabel('scores')
title('Diagram of scores-betray probability')
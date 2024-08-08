% counterparty action: 0 trust, others betray
% your action: 0 trust, others call police
function [Your_Strategy, predict_betray_prob] = Your_Strategies(counterparty_previous_action)
    betray = length(find(counterparty_previous_action == 1));    % The previous times of counterparty betray
    total = length(counterparty_previous_action);                % The previous times of total trade
    predict_betray_prob = (betray+1)/(total+2);                  % Calculate based on Bayes Rule
    
    if predict_betray_prob < 0.5
        Your_Strategy = 0;     % trust
    else
        Your_Strategy = 1;     % call police
    end
end
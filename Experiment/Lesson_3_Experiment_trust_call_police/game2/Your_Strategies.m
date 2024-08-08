% counterparty action: 0 trust, others betray
% your action: 0 trust, others call police
function [Your_Strategy, predict_betray_prob] = Your_Strategies(counterparty_previous_action)
    % calculate the betray probability each trade
    betray_prob = zeros(100, 1);
    for i = 1: 100
        betray_prob(i) = length(find(counterparty_previous_action(i, :) == 1)) / 100;
    end
    predict_betray_prob = mean(betray_prob);     % take average based on estimation theory
    
    if predict_betray_prob < 0.5
        Your_Strategy = 0;                       % trust
    else
        Your_Strategy = 1;                       % call police
    end
end
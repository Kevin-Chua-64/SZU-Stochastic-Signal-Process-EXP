% Print your student ID and Name here, for example
% 2020282007    佘婷婷
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id19(counterparty_id1)
    load("infor_id19.mat","counterparty_id","counterparty_action");
    if counterparty_id == counterparty_id1 && counterparty_action == 1
        your_strategy = 1;
    else
        if rand(1) < 0.3
            your_strategy = 0; % this strategy means that you will always betray anyone
        else
            your_strategy = 1;
        end
    end 
    %
end
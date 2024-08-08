% Print your student ID and Name here, for example
% 2020282061    蔡丰锴
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id20(counterparty_id)
    if counterparty_id == 2 || counterparty_id == 3 || counterparty_id == 23 || counterparty_id == 24 || counterparty_id == 25 || counterparty_id == 26
        your_strategy = 0;
    else
        p = rand();
        if p > 0.8
            your_strategy = 0;
        else
            your_strategy = 1;
        end
    end
end
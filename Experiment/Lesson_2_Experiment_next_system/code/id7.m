% Print your student ID and Name here, for example
% 2020281048    宋坤平
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id7(counterparty_id)
    load storage_id7.mat
    if  mod(Trade_no, 2) == 0
        your_strategy = 0;
    else
        your_strategy = 1;
    end
    Trade_no = Trade_no + 1;
end
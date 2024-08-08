% Print your student ID and Name here, for example
% 2020281129    ÷‹¡÷…≠
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id14(counterparty_id)
    load storage_id14.mat
    if mod(Trade_no,3) == 0
        your_strategy = 0; 
    else
        your_strategy = 1; 
    end
    Trade_no = Trade_no + 1;
    save('storage_id14', 'Trade_no', 'your_id')
end
% Print your student ID and Name here, for example
% 2020281069   Yu Liu
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id9(counterparty_id)
    load infor_id9
    load storage_id9
    Trade_no = Trade_no + counterparty_action;
    save ('storage_id9','Trade_no')
    if Trade_no<30
       your_strategy = 0;
    else    
       your_strategy = 1;   
end
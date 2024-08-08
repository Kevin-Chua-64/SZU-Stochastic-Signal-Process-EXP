% Print your student ID and Name here, for example
% 2020281046    林国健
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id5(counterparty_id)
    load infor_id5
    load storage_id5
    if counterparty_action==0
       your_strategy=round(rand(1),0);
    else 
       your_strategy=0;
    end
    save('storge_id5','your_strategy','counterparty_id')
end
   % your_strategy = 0;  % this strategy means that you will always trust anyone 
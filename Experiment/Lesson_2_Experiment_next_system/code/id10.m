% Print your student ID and Name here, for example
% 2020281077    Yingjie Ma
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id10(counterparty_id)
    load infor_id10.mat
    load storage_id10.mat
    if counterparty_action == 0
        your_strategy = 0;  % this means that you will trust this person
    else  
        your_strategy = round(rand); % this means that you will have a 50% chance of betrayal, a 50% chance of trust
    end
    Trade_no = Trade_no + 1;
    save('storage_id10', 'Trade_no', 'your_id')
    % your strategy will trush one person when last time you were trusted,
    % if last time you were betrayed, then you will have a 50% chance of betrayal, a 50% chance of trust
end 
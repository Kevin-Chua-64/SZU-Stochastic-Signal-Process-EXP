% Print your student ID and Name here, for example
% 2020281153    Zongliang He
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id17(counterparty_id)
    load('infor_id17.mat', 'counterparty_action', 'counterparty_id')
    load('storage_id17.mat', 'Trade_no', 'your_id')
    your_strategy = 0;  % Firstly, trust anybody 
    if counterparty_action == 1
        random_num = rand(0, 1);
        if random_num > 0.5
            your_strategy = 1;
        else
            your_strategy = 0;
        end
        Trade_no = Trade_no + 1;
    else
        your_strategy = 0;
    end
    
    if Trade_no >= 3   % Being betrayed over 3 times, never trust anybody
        your_strategy = 1;
    end
    
    save('storage_id17.mat', 'Trade_no', 'your_id')
end
% Print your student ID and Name here, for example
% 2020282061    蔡丰锴
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy > 0 means that you want to betray the counterparty this time 
% your_strategy = others means that you reject this counterparty
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id20(counterparty_id)
    if 31 <= counterparty_id && counterparty_id <= 35
        your_strategy = -1;          % reject (npc always betray)
        
    elseif 36 <= counterparty_id && counterparty_id <= 40
        your_strategy = 0;           % trust (npc reject once you betray)
        
    else
        counterparty_now = counterparty_id;
        load infor_id20.mat
        load storage_id20.mat
        if Trade_no == 0
            list_betray = [];
        end
        if counterparty_action > 0
            list_betray = [list_betray; counterparty_id];     % statistics of the betrayed
        end
        betray_time = length(find(list_betray == counterparty_now));
        if betray_time == 0
            your_strategy = 0;       % trust if I have never been betray
            
        elseif betray_time >= 3
            your_strategy = -1;      % reject if I have been betrayed at least 3 times
            
        else
            p = rand();
            if p > 0.8
                your_strategy = 0;   % small probability to trust
            else
                your_strategy = 1;   % high probability to betray
            end
        end
        Trade_no = Trade_no + 1;
        save storage_id20.mat Trade_no your_id list_betray    
    end
end
% Print your student ID and Name here, for example
% 2020281100    郑伟杰
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id13(counterparty_idnow)
    load storage_id13.mat;
    load infor_id13.mat;
    temp = 0;          % To store the number of betrayed
    templist = zeros(40);
    if Trade_no == 0
        global num_betrayed;
        global actionlist;
        temp = counterparty_action;
    else
        temp = num_betrayed + counterparty_action;
        templist = actionlist;
        templist(counterparty_id-1) = templist(counterparty_id-1) + counterparty_action;
    end
    num_betrayed = temp;
    actionlist = templist;       % To store the betrayed list
    p_betrayed = num_betrayed/Trade_no;
    if p_betrayed > 0.5
        your_strategy = 1;
    else
        if actionlist(counterparty_idnow) > 0
            your_strategy = 1;
        else
            r = rand();
            if r > 0.5
                your_strategy = 1;
            else 
                your_strategy = 0;
            end
        end
    end
    save('storage_id13.mat',"num_betrayed","Trade_no",'your_id','actionlist')
end
% Print your student ID and Name here, for example
% 2020282152    林镇铭
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
%% Now we begins
function [your_strategy] = id22(counterparty_id)
    load storage_id22.mat
    load infor_id31.mat
    if Trade_no == 0
        be_believed_times = 0;
        betrayed_times = 0;
    end
    
    if be_believed_times > betrayed_times
        your_strategy = 0;  % this means that you will trust this person
    else
        your_strategy = 1;  % this means that you will betray this person
    end
    Trade_no = Trade_no + 1;
    if counterparty_action == 0
        be_believed_times = be_believed_times + 1;  % this means that you will trust this person
    else
        betrayed_times = betrayed_times + 1;  % this means that you will betray this person
    end
    save('storage_id22', 'Trade_no', 'your_id', 'be_believed_times', 'betrayed_times')
    % your strategy will trush one person and then betray one and goes on
    % ONLY save your data in the file storage_id21.mat, 
    % otherwise you will be treated as 'homework not submitted'
end
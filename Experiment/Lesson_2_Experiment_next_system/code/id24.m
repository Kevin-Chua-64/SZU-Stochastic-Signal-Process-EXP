% Print your student ID and Name here, for example
% 2020284028    Zhuorong Chen
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id  is the ID of the counterparty you are going to trade with
% this time
%% Now we begins
function [your_strategy] = id24(counterparty_id)
    load infor_id24.mat
    decide_array = round(rand(1,10)*10);  % An array for decision
    if counterparty_action == 0
        your_strategy = 1;  % this means that you will betray this person
    elseif sum(decide_array)>30    
        your_strategy = 1;
    else 
        your_strategy = 0;   % this means that you will have the probability of 1/3 trust this person
    end
    % your strategy will trust one person and then betray one and goes on
    % ONLY save your data in the file storage_id21.mat, 
    % otherwise you will be treated as 'homework not submitted'
end
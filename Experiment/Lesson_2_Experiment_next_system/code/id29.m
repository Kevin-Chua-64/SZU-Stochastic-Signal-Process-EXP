% Print your student ID and Name here, for example
% 2020285102    余韦�?
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
%% Now we begins
function [your_strategy] = id29(counterparty_id)
    load storage_id29.mat
    load infor_id29.mat
    if counterparty_action == 0
        random = round(10*rand(1));
        if random <= 8
            your_strategy = 0;  % this means that you will trust this person
    
        else
            your_strategy = 1;  % this means that you will betray this person
        end
    else 
       random = 10*round(rand(1));
       if random <= 5
            your_strategy = 0;  % this means that you will trust this person
       else
            your_strategy = 1;  % this means that you will betray this person
       end 
    end
    Trade_no = Trade_no + 1;
    save('storage_id29', 'Trade_no', 'your_id')
    % your strategy will trush one person and then betray one and goes on
    % ONLY save your data in the file storage_id21.mat, 
    % otherwise you will be treated as 'homework not submitted'
end
% Print your student ID and Name here, for example
% 2020285120    Weitan Ye
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
%% Now we begins
function [your_strategy] = id30(counterparty_id)
    load storage_id30.mat
    if mod(Trade_no,3) == 0
        your_strategy = 1;  % To satisfy the earn proportion of 6:3. I decide to distrust somebody once After trust somebody twice.
    else
        your_strategy = 0;  % this means that you will betray this person
    end
    Trade_no = Trade_no + 1;
    save('storage_id30', 'Trade_no', 'your_id')
    % your strategy will trush one person and then betray one and goes on
    % ONLY save your data in the file storage_id21.mat, 
    % otherwise you will be treated as 'homework not submitted'
end
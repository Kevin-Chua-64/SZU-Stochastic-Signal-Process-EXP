% Print your student ID and Name here, for example
% 2019144039 姜宇杨
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id1(counterparty_id)
load infor_id1.mat
load storage_id1.mat
     if mod(Trade_no,2) == 1 || counterparty_action == 1
         traitor = counterparty_id;   %save id
         if counterparty_id == traitor
          your_strategy = 1;  % this means that you will trust this person
         else 
              your_strategy = round(rand(1),0);  % this means that you may betray this person
         end
    else
        your_strategy = 0;  % this means that you will trust this person
     end
    Trade_no = Trade_no + 1;
     save('storage_id1', 'Trade_no')
end
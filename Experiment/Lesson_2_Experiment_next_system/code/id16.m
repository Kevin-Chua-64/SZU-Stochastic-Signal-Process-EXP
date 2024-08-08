%2020281147 王绍垒
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id16(counterparty_id)
%%load information I can read
    tmp=counterparty_id;
    load('infor_id16');
    load('storage_id16');
%%save the action of last time opponent to 'Trade_no' 
    if Trade_no(1)==0
        Trade_no=ones(1,50);%format Trade_no the first time to lunch
    end
    Trade_no(1)=Trade_no(1)+1; %the first number of 'Trade_no' means the 
    %number of games
    Trade_no(counterparty_id+1)=counterparty_action; %the others means the
    %action of last time opponent
%%decide the action
    if(Trade_no(1)>96)
 %the '96' come from as at this point my mathematical expectation of myearnings is the largest
 %too small to explain in details
       your_strategy =0;  %if it's so late that it's almost impossible to 
       %see the same player,betray them
    else
       your_strategy =Trade_no(tmp+1); 
       %else copy his or her action last time(trust him at first time)
    end
 %%initialization 'Trade_no' at the last game
    if Trade_no(1)>=100
        Trade_no=0;
    end
    save('storage_id16','Trade_no');
end
%The robustness of the program is not very good,you may need to reset data
%of 'storage_id16.mat' manually
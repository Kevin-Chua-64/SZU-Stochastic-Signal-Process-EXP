% Print your student ID and Name here, for example
% 2020281047  6  Wentian Zhang
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time




function [your_strategy] = id6(counterparty_id)
    

%  Assume the probability of the counterparty's trust is y and ours is x, and we can find the
%  expectation : (y-3)x+15y-3, we can see the parameter of x is always
%  smaller than 0, so x need to be 0 which means we should always betray to
%  benefit most.
    your_strategy = 1;  % this strategy means that you will always betray anyone 
end
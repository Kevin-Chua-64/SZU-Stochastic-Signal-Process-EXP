% Print your student ID and Name here, for example
% 2020281131    Jinfeng Zheng
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id15(counterparty_id)
    % The trading game, obviously, I can't decide everyone's decision, but I can decide my own decision.  
    % I make two decisions, either trust or betray. How to maximize the income is my goal.
    % When I can't interfere with other people's decisions, I think a steady return is the prerequisite for maximum returns.
    % When X=6,Y=3, when I choose to believe, the average return on multiple trades is: 10-6=4
    % If I choose to betray, the payoff for every two times I defect is: 12-3=9
    % Obviously, the payoff for choosing trust is 4, and the payoff for betrayal is 9 。
    % Therefore, the ratio of these two numbers (4 and 9) is used to decide whether to believe or betray.
    % So the value is: 4/ (4+9) =0.3077  
    % This result may not be accurate, but I think it is a good result.
    judge_my = rand;
    if judge_my <=0.3077
        your_strategy = 0;  % trust
    else
        your_strategy = 1;  % betray
    end
    
    
end
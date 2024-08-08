% Print your student ID and Name here, for example
% 2020112108    ÁººÆ
%%

function [your_strategy] = id3(counterparty_id)
    load infor_id3.mat
    a=rand();
    if counterparty_action == 1
        if a >= 0.8
            your_strategy = 0;   
        else
            your_strategy = 1;
        end
    else
        if a >= 0.7
            your_strategy = 1;   
        else
            your_strategy = 0;
        end   
    end
end
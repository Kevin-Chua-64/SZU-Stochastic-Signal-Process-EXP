%Student ID: 2020276056
%Student Name: 刘庆麟

function [your_strategy] = id4(counterparty_id)
    if rand(1) >= 0.4
        your_strategy = 1 ;
    else
        your_strategy = 0 ;
    end
end
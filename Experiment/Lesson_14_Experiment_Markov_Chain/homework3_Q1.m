clear
clc

P = [1,    0,    0,    0,    0,    0;
    0.25,  0,  0.75,   0,    0,    0;
    0,   0.25,   0,  0.75,   0,    0;
    0,     0,  0.25,   0,   0.75,  0;
    0,     0,    0,  0.25,   0,   0.75;
    0,     0,    0,    0,    0,    1];

Prob_of_A_ruin = [];
Prob_of_B_ruin = [];
Prob_of_no_ruin = [];

Total_Game_No = 20;
A_start = 2;
B_start = 3;

P_current = eye(A_start + B_start + 1);
games = 1:Total_Game_No;
for i = games
    P_current = P_current*P;
    Prob_of_A_ruin = [Prob_of_A_ruin, P_current(A_start+1, 1)];
    Prob_of_B_ruin = [Prob_of_B_ruin, P_current(A_start+1, end)];
    Prob_of_no_ruin = [Prob_of_no_ruin, 1-P_current(A_start+1, 1)-P_current(A_start+1, end)];
end

figure
plot(games, Prob_of_A_ruin)
grid on
xlim([1,Total_Game_No])
ylim([0,1])
title('Prob of A ruin')

figure
plot(games, Prob_of_B_ruin)
grid on
xlim([1,Total_Game_No])
ylim([0,1])
title('Prob of B ruin')

figure
plot(games, Prob_of_no_ruin)
grid on
xlim([1,Total_Game_No])
ylim([0,1])
title('Prob of no ruin')

probability_of_no_ruin_for_10_games = Prob_of_no_ruin(10)
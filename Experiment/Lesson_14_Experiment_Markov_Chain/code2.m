clear
clc

% P = [1,0,0,0,0;0.3,0.3,0.4,0,0;0,0.3,0.3,0.4,0;0,0,0.3,0.3,0.4;0,0,0,0,1];
% P = [0.3,0.7,0,0,0;0.3,0.3,0.4,0,0;0,0.3,0.3,0.4,0;0,0,0.3,0.3,0.4;0,0,0,0.7,0.3];
P = [0.3,0.7,0,0,0;0.3,0.3,0.4,0,0;0,0.3,0.3,0.4,0;0,0,0.3,0.3,0.4;0,0,0,0,1];
% P2 = P*P;

Prob_of_A_ruin = [];
Prob_of_B_ruin = [];
Prob_of_no_ruin = [];

Total_Game_No = 50;
A_start = 2;
B_start = 2;

P_current = eye(A_start+B_start+1);
games = 1:Total_Game_No;
for i = games
    P_current = P_current*P;
    Prob_of_A_ruin = [Prob_of_A_ruin, P_current(A_start+1, 1)];
    Prob_of_B_ruin = [Prob_of_B_ruin, P_current(A_start+1, end)];
    Prob_of_no_ruin = [Prob_of_no_ruin, 1-P_current(A_start+1, 1)-P_current(A_start+1, end)];
end

figure(1)
plot(games, Prob_of_A_ruin)
xlim([1,Total_Game_No])
ylim([0,1])
title('Prob of A ruin')

figure(2)
plot(games, Prob_of_B_ruin)
xlim([1,Total_Game_No])
ylim([0,1])
title('Prob of B ruin')

figure(3)
plot(games, Prob_of_no_ruin)
xlim([1,Total_Game_No])
ylim([0,1])
title('Prob of no ruin')


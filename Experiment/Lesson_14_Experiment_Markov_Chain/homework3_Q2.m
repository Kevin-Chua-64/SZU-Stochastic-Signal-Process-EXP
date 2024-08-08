clear
clc

P = [0.7, 0.1, 0.1, 0.1;
     0.2, 0.4, 0.2, 0.2;
     0.1, 0.1, 0.6, 0.2;
     0.3,  0,  0.3, 0.4];

Total_Gen_No = 24;
initial = [0.25, 0.25, 0.25, 0.25];

gens = 1:Total_Gen_No;
Vec_current = initial;
Vec_all = initial;
for i = gens
    Vec_current = Vec_current*P;
    Vec_all = [Vec_all; Vec_current];
end

gens = [0, gens];

figure
plot(gens, Vec_all(:, 1), 'b'), grid on, hold on
plot(gens, Vec_all(:, 2), 'r'), grid on, hold on
plot(gens, Vec_all(:, 3), 'k'), grid on, hold on
plot(gens, Vec_all(:, 4), 'g'), grid on, hold on
xlim([0,Total_Gen_No])
ylim([0,1])
legend('Shampoo A', 'Shampoo B', 'Shampoo C', 'Shampoo D')
title('Shampoo distribution')

month_2 = [Vec_all(2+1, 1), Vec_all(2+1, 2), Vec_all(2+1, 3), Vec_all(2+1, 4)]
month_12 = [Vec_all(12+1, 1), Vec_all(12+1, 2), Vec_all(12+1, 3), Vec_all(12+1, 4)]
clear
clc

P = [0.6, 0.4;
     0.2, 0.8];

Total_Gen_No = 25;
random = rand(1);
initial = [random, 1-random];

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
xlim([0,Total_Gen_No])
ylim([0,1])
legend('Shampoo A', 'Shampoo B')
title('Shampoo distribution')

if abs(Vec_all(end, 1) - Vec_all(end-1, 1)) < 1e-7
    A_stationary_distribution = Vec_all(end, 1)
    B_stationary_distribution = Vec_all(end, 2)
end
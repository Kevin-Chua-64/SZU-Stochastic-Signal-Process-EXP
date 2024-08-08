% Rayleigh distribution by 50 random numbers
B = 3;
figure
subplot(2, 4, 1)
rd = makedist('Rayleigh', B);
r50 = random(rd, 1, 50);
x = 0: 0.001: 14;              % range
histogram(r50, 8, 'Normalization', 'pdf');
hold on
[f, x] = ksdensity(r50, x);    % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold on
y = raylpdf(x, B);             % truth pdf;
plot(x, y, 'linewidth', 1.5);
hold off
legend('histogram', 'estimate', 'truth')
title('Rayleigh distribution of 50 random variables');

% Rayleigh distribution by 5000 random numbers
subplot(2, 4, 5)
rd = makedist('Rayleigh', B);
r5000 = random(rd, 1, 5000);
x = 0: 0.001: 14;              % range
histogram(r5000, 'Normalization', 'pdf');
hold on
[f, x] = ksdensity(r5000, x);  % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold on
y = raylpdf(x, B);             % truth pdf;
plot(x, y, 'linewidth', 1.5);
hold off
legend('histogram', 'estimate', 'truth')
title('Rayleigh distribution of 5000 random variables');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Poisson distribution by 50 random numbers
lamda = 5;
subplot(2, 4, 2)
pd = makedist('Poisson', lamda);
p50 = random(pd, 1, 50);
x = 0: 1: 15;                  % range
histogram(p50, 'Normalization', 'pdf');
hold on
[f, x] = ksdensity(p50, x);    % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold on
y = poisspdf(x, lamda);        % truth pdf;
plot(x, y, 'linewidth', 1.5);
hold off
legend('histogram', 'estimate', 'truth')
title('Poisson distribution of 50 random variables');

% Poisson distribution by 5000 random numbers
subplot(2, 4, 6)
pd = makedist('Poisson', lamda);
p5000 = random(pd, 1, 5000);
x = 0: 1: 15;                  % range
histogram(p5000, 'Normalization', 'pdf');
hold on
[f, x] = ksdensity(p5000, x);  % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold on
y = poisspdf(x, lamda);        % truth pdf;
plot(x, y, 'linewidth', 1.5);
hold off
legend('histogram', 'estimate', 'truth')
title('Poisson distribution of 5000 random variables');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Uniform distribution by 50 random numbers
lower = 0;
upper = 1;
subplot(2, 4, 3)
ud = makedist('Uniform', lower, upper);
u50 = random(ud, 1, 50);
x = -0.1: 0.001: 2.3;          % range
histogram(u50, 8, 'Normalization', 'pdf');
hold on
[f, x] = ksdensity(u50, x);    % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold on
y = unifpdf(x, lower, upper);  % truth pdf;
plot(x, y, 'linewidth', 1.5);
hold off
xlim([-0.1, 2.3])
legend('histogram', 'estimate', 'truth')
title('Uniform distribution of 50 random variables');

% Uniform distribution by 5000 random numbers
subplot(2, 4, 7)
ud = makedist('Uniform', lower, upper);
u5000 = random(ud, 1, 5000);
x = -0.1: 0.001: 2.3;          % range
histogram(u5000, 'Normalization', 'pdf');
hold on
[f, x] = ksdensity(u5000, x);  % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold on
y = unifpdf(x, lower, upper);  % truth pdf;
plot(x, y, 'linewidth', 1.5);
hold off
xlim([-0.1, 2.3])
legend('histogram', 'estimate', 'truth')
title('Uniform distribution of 5000 random variables');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Exponential distribution by 50 random numbers
mu = 3;
subplot(2, 4, 4)
ed = makedist('Exponential', mu);
e50 = random(ed, 1, 50);
x = -0.1: 0.001: 20;           % range
histogram(e50, 8, 'Normalization', 'pdf');
hold on
[f, x] = ksdensity(e50, x);    % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold on
y = exppdf(x, mu);             % truth pdf;
plot(x, y, 'linewidth', 1.5);
hold off
xlim([-1, 20])
legend('histogram', 'estimate', 'truth')
title('Exponential distribution of 50 random variables');

% Exponential distribution by 5000 random numbers
subplot(2, 4, 8)
ed = makedist('Exponential', mu);
e5000 = random(ed, 1, 5000);
x = -0.1: 0.001: 20;           % range
histogram(e5000, 'Normalization', 'pdf');
hold on
[f, x] = ksdensity(e5000, x);  % estimate pdf
plot(x, f, 'linewidth', 1.5);
hold on
y = exppdf(x, mu);             % truth pdf;
plot(x, y, 'linewidth', 1.5);
hold off
xlim([-1, 20])
legend('histogram', 'estimate', 'truth')
title('Exponential distribution of 5000 random variables');
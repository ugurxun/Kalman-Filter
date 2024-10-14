clear;clc;

%Author: Uğur ÜN
%Date  : 10 Oct 2024

meas_xy =  [301.5 298.23 297.83 300.42 301.94 299.5 305.98 301.25 299.73 299.2 298.62 301.84 299.6 295.3 299.3 301.95 296.3, 295.11 295.12 289.9 283.51 276.42 264.22 250.25 236.66 217.47, 199.75 179.7 160 140.92 113.53 93.68 69.71 45.93 20.87;
            -401.46 -375.44 -346.15 -320.2 -300.08 -274.12 -253.45 -226.4 -200.65 -171.62 -152.11 -125.19 -93.4 -74.79 -49.12 -28.73 2.99 25.65 49.86 72.87 96.34 120.4 144.69 168.06 184.99 205.11 221.82 238.3 253.02 267.19 270.71 285.86 288.48 292.9 298.77];

n_of_meas = length(meas_xy);
dt = 1;
acc_std = 0.2;
meas_std = 3;

k = zeros(6,2);
est = zeros(6,n_of_meas);

%Initilization
x_n = zeros(6,1);
p_n = eye(6)*500;

f = [1, dt, 0.5*dt^2, 0, 0 , 0       ;
     0, 1 , dt      , 0, 0 , 0       ;
     0, 0 , 1       , 0, 0 , 0       ;
     0, 0 , 0       , 1, dt, 0.5*dt^2;
     0, 0 , 0       , 0, 1 , dt      ;
     0, 0 , 0       , 0, 0 , 1        ];

q = [dt^4/4, dt^3/2, dt^2/2, 0     , 0     , 0
     dt^3/2, dt^2  , dt    , 0     , 0     , 0
     dt^2/2, dt    , 1     , 0     , 0     , 0
     0     , 0     , 0     , dt^4/4, dt^3/2, dt^2/2
     0     , 0     , 0     , dt^3/2, dt^2  , dt
     0     , 0     , 0     , dt^2/2, dt    , 1      ] * acc_std^2;

r = [meas_std^2, 0
     0          , meas_std^2];

h = [1, 0, 0, 0, 0, 0
     0, 0, 0, 1, 0, 0];

I = eye(6);

%initial prediction
x_n = f * x_n;
p_n = f * p_n * f' + q;

for i=1:n_of_meas

    %update
    k = p_n * h' * inv(h * p_n * h' + r);
    est(:,i) = x_n + k * (meas_xy(:,i) - h * x_n);
    p_n = (I - k * h) * p_n * (I - k * h)' + k * r * k';

    %predict
    x_n = f * est(:,i);
    p_n = f * p_n * f' + q;
end

%PLOT
figure(1)
plot(est(1,:), est(4,:), 'r-','Linewidth',2);hold on;
plot(meas_xy(1,:), meas_xy(2,:), 'b-','Linewidth',2)
title('Vehicle Location estimation 2-D')
legend('Estimations', 'Measurements')
xlabel('X')
ylabel('Y')
xlim([min(est(1,:)) max(est(1,:)) + 10])
ylim([min(est(4,:)) max(est(4,:)) + 10])
grid on


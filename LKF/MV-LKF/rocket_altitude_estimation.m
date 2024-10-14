clear;clc;

%Author: Uğur ÜN
%Date  : 14 Oct 2024

z =  [6.43 1.3 39.43 45.89 41.44 48.7 78.06 80.08 61.77 75.15 110.39 127.83 158.75 156.55 213.32 ...
             229.82 262.8 297.57 335.69 367.92 377.19 411.18 460.7 468.39 553.9 583.97 655.15 723.09 736.85 787.22
             39.81 39.67 39.81 39.84 40.05 39.85 39.78 39.65 39.67 39.78 39.59 39.87 39.85 39.59 39.84 ...
             39.9 39.63 39.59 39.76 39.79 39.73 39.93 39.83 39.85 39.94 39.86 39.76 39.86 39.74 39.94
             ];

n_of_meas = length(z);
dt = 0.25;
alt_std = 20;
acc_std = 0.1;
G = 9.81;
t = (1:n_of_meas)*dt;

k = zeros(2,1);
est = zeros(2,n_of_meas);

%Initilization
x_n = zeros(2,1);
a_n = 0;
p_n = eye(2)*500;

f = [1, dt
     0, 1 ];

g = [0.5 * dt^2,
     dt ,       ];

q = [dt^4/4, dt^3/2
     dt^3/2, dt^2  ]*acc_std^2;

r = alt_std^2;

I = eye(2);

h = [1 0];

%initial prediction
x_n = f * x_n + g * a_n;
p_n = f * p_n * f' + q;

for i=1:n_of_meas

    %update
    k = p_n * h' * inv(h * p_n * h' + r);
    est(:,i) = x_n + k * (z(1,i) - h * x_n);
    p_n = (I - k * h) * p_n * (I - k * h)' + k * r * k';

    %predict
    a_n = z(2,i);
    x_n = f * est(:,i) + g * (a_n - G) ;
    p_n = f * p_n * f' + q;

end


%PLOT
figure(1)
plot(t, est(1,:), 'r-','Linewidth',2);hold on;
plot(t, z(1,:), 'b-','Linewidth',2)
title('Rocket Altitude Estimation')
legend('Estimations', 'Measurements')
xlabel('time (sec)')
ylabel('altitude (m)')
grid on

figure(2)
plot(t, est(2,:), 'r-','Linewidth',2); hold on;
title('Rocket Velocity Estimation')
xlabel('time (sec)')
ylabel('velocity (m/s)')
grid on

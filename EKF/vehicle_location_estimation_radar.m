clear;clc;

%Author: Uğur ÜN
%Date  : 15 Oct 2024

z = [502.55 477.34 457.21 442.94 427.27 406.05 400.73 377.32 360.27 345.93 333.34 328.07 315.48 301.41 302.87 304.25 294.46 ...
     294.29 299.38 299.37 300.68 304.1 301.96 300.3 301.9 296.7 297.07 295.29 296.31 300.62 292.3 298.11 298.07 298.92 298.04
     -0.9316 -0.8977 -0.8512 -0.8114 -0.7853 -0.7392 -0.7052 -0.6478 -0.59 -0.5183 -0.4698 -0.3952 -0.3026 -0.2445 -0.1626 -0.0937 0.0085 ...
     0.0856 0.1675 0.2467 0.329 0.4149 0.504 0.5934 0.667 0.7537 0.8354 0.9195 1.0039 1.0923 1.1546 1.2564 1.3274 1.409 1.5011
     ];
z_p = [z(1,:) .* cos(z(2,:)); z(1,:) .* sin(z(2,:))]; %z on cartesian plane (x, y)

n = length(z);
t = 1:n;

dt = 1;
acc_std = 0.2;     %m/s^2
range_std = 5;     %m
angle_est = 0.0087; %rad

est = zeros(6,n);


f = [1, dt, 0.5*dt^2, 0, 0 , 0
     0, 1 , dt      , 0, 0 , 0
     0, 0 , 1       , 0, 0 , 0
     0, 0 , 0       , 1, dt, 0.5*dt^2
     0, 0 , 0       , 0, 1 , dt
     0, 0 , 0       , 0, 0 , 1        ];

q = [dt^4/4, dt^3/2, dt^2/2, 0     , 0     , 0
     dt^3/2, dt^2  , dt    , 0     , 0     , 0
     dt^2  , dt    , 1     , 0     , 0     , 0
     0     , 0     , 0     , dt^4/4, dt^3/2, dt^2/2
     0     , 0     , 0     , dt^3/2, dt^2  , dt
     0     , 0     , 0     , dt^2  , dt    , 1      ] * acc_std^2;

r = [range_std^2, 0
     0          , angle_est^2];

I = eye(6);

h = @(x,y)[sqrt(x^2 + y^2); atan(y/x)];
h_d = @(x, y)[x/sqrt(x^2 + y^2) , 0, 0, y/sqrt(x^2 + y^2), 0, 0
              -y/(x^2 + y^2)    , 0, 0, x/(x^2 + y^2)    , 0, 0 ];


%initialization

x_n = [400; 0; 0; -300; 0; 0];
p_n = eye(6) * 500;

%initial prediction

x_n = f * x_n;
p_n = f * p_n * f' + q;

for i = 1:n

   %update
   k = p_n * h_d(x_n(1), x_n(4))' * inv( h_d(x_n(1), x_n(4)) * p_n * h_d(x_n(1), x_n(4))' + r);
   est(:,i) = x_n + k * (z(:,i) - h(x_n(1), x_n(4)));
   p_n = (I - k * h_d(x_n(1), x_n(4))) * p_n * (I - k * h_d(x_n(1), x_n(4)))' + k * r * k';

   %prediction
   x_n = f * est(:,i);
   p_n = f * p_n * f' + q;

end


%plot
figure(1)
plot(est(1,:), est(4,:), '-r', 'Linewidth', 2);hold on;
plot(z_p(1,:), z_p(2,:), '-b', 'Linewidth', 2)
title('Vehicle Location Estimation With Radar')
legend('Estimations', 'Measurements')
xlabel('X')
ylabel('Y')
xlim([min(est(1,:))-10 max(est(1,:)) + 10])
ylim([min(est(4,:))-10 max(est(4,:)) + 10])
grid on



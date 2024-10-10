clear;
clc;

true_temp = [50.005, 49.994, 49.993, 50.001, 50.006, 49.998, 50.021, 50.005, 50,  49.997];
meas_temp =  [49.986, 49.963, 50.09, 50.001, 50.018, 50.05, 49.938, 49.858, 49.965, 50.114];
%true_temp =  [50.505,50.994, 51.493, 52.001, 52.506, 52.998, 53.521, 54.005, 54.5,54.997]
%meas_temp =  [50.486, 50.963, 51.597, 52.001, 52.518,53.05, 53.438, 53.858, 54.465,55.114]



n_of_meas = length(true_temp);

k = zeros(n_of_meas,1);
est = zeros(n_of_meas,1);
t = 0:9;
q = 0.0001; # process noise variance
r = 0.01  ; # measurement noise variance


%Initilization
x_i = 60;
std_init = 100;
p_i = std_init ^ 2;

%initial prediction
x_i = x_i;
p_i = p_i + q;

for i = 1:n_of_meas

    %update
    k(i) = p_i/(p_i + r);
    est(i) = x_i + k(i)*(meas_temp(i) - x_i);
    p_i = (1 - k(i))*p_i;

    %predict
    x_i = est(i);
    p_i = p_i + q;
end


%PLOTS
%Estimation plots
figure(1)
plot(t, est, 'r-','Linewidth',2);hold on
plot(t, meas_temp, 'b-','Linewidth',2);hold on
plot(t, true_temp, 'g-','Linewidth',2);
title('Temperature Estimates of Liquid Tank')
xlabel('iterations')
ylabel('Temperature (oC)')
xlim([t(1) t(end)])
grid on


%Kalman Gain plot
figure(2)
plot(t, k, 'b-','Linewidth',2)
title('Temperature Estimates Kalman Gain of Liquid Tank')
xlabel('iterations')
ylabel('Kalman Gain')
xlim([t(1) t(end)])
grid on



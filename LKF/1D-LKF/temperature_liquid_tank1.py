import numpy as np
import matplotlib.pyplot as plt


true_temp = np.array([50.005, 49.994, 49.993, 50.001, 50.006, 49.998, 50.021, 50.005, 50,  49.997])
meas_temp =  np.array([49.986, 49.963, 50.09, 50.001, 50.018, 50.05, 49.938, 49.858, 49.965, 50.114])
#true_temp = np.array([ 50.505,50.994, 51.493, 52.001, 52.506, 52.998, 53.521, 54.005, 54.5,54.997])
#meas_temp =  np.array([50.486, 50.963, 51.597, 52.001, 52.518,53.05, 53.438, 53.858, 54.465,55.114])

K = np.zeros(10)
Est = np.zeros(10)
t = np.arange(10)
q = 0.0001 # process noise variance
r = 0.01   # measurement noise variance


#Initilization
x_i = 60
std_init = 100
p_i = std_init ** 2

#initial prediction
x_i = x_i 
p_i = p_i + q

for i in range(10):

    #update
    K[i] = p_i/(p_i + r)
    Est[i] = x_i + K[i]*(meas_temp[i] - x_i)
    p_i = (1 - K[i])*p_i
     
    #predict
    x_i = Est[i]
    p_i = p_i + q 

#PLOTS
#Estimation plots
plt.figure(1)
plt.plot(t, Est,       label='Estimated Temp', color='red', linestyle='-', linewidth=1)   
plt.plot(t, meas_temp, label='Measured Temp', color='blue', linestyle='-', linewidth=1) 
plt.plot(t, true_temp, label='True Temp', color='green', linestyle='-', linewidth=1)  
plt.title('Temperature Estimates of Liquid Tank')  
plt.xlabel('iterations')  
plt.ylabel('Temperature (oC)')  
plt.legend()  
plt.xlim(t[0], t[-1])
plt.grid(True)
plt.tight_layout()


#Kalman Gain plot
plt.figure(2)
plt.plot(t, K, color='black', linestyle='-', linewidth=1)    
plt.title('Temperature Estimates Kalman Gain of Liquid Tank')  
plt.xlabel('iterations')  
plt.ylabel('Kalman Gain')  
plt.xlim(t[0], t[-1])
plt.grid(True)

plt.tight_layout()
plt.show() 
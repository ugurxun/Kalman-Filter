import numpy as np
import matplotlib.pyplot as plt


#true_temp = np.array([50.005, 49.994, 49.993, 50.001, 50.006, 49.998, 50.021, 50.005, 50,  49.997])
meas_xy =  np.array([[301.5, 298.23, 297.83, 300.42, 301.94, 299.5, 305.98, 301.25, 
                        299.73, 299.2, 298.62, 301.84, 299.6, 295.3, 299.3, 301.95, 296.3,
                        295.11, 295.12, 289.9, 283.51, 276.42, 264.22, 250.25, 236.66, 217.47,
                        199.75, 179.7, 160, 140.92, 113.53, 93.68, 69.71, 45.93, 20.87],
                       [-401.46, -375.44, -346.15, -320.2, -300.08, -274.12, -253.45, -226.4,
                        -200.65, -171.62, -152.11, -125.19, -93.4, -74.79, -49.12, -28.73, 2.99,
                        25.65, 49.86, 72.87, 96.34, 120.4, 144.69, 168.06, 184.99, 205.11,
                        221.82, 238.3, 253.02, 267.19, 270.71, 285.86, 288.48, 292.9, 298.77,
                        ]                     
                       ])

n_of_meas = meas_xy.shape[1]
dt = 1
acc_std = 0.2
meas_std = 3

K = np.zeros((6,2))
Est = np.zeros((6,n_of_meas))
print(Est)

#Initilization
x_n = np.zeros((6,1))
p_n = np.eye(6)*500
f = np.array([[1, dt, 0.5*dt**2, 0, 0 , 0        ],   
                [0, 1 , dt       , 0, 0 , 0        ],
                [0, 0 , 1        , 0, 0 , 0        ],
                [0, 0 , 0        , 1, dt, 0.5*dt**2],
                [0, 0 , 0        , 0, 1 , dt       ],
                [0, 0 , 0        , 0, 0 , 1        ]    
               ])

q = np.array([[dt**4/4, dt**3/2, dt**2/2, 0      , 0      , 0      ],  
                [dt**3/2, dt**2  , dt     , 0      , 0      , 0      ],
                [dt**2/2, dt     , 1      , 0      , 0      , 0      ],
                [0      , 0      , 0      , dt**4/4, dt**3/2, dt**2/2],
                [0      , 0      , 0      , dt**3/2, dt**2  , dt     ],
                [0      , 0      , 0      , dt**2/2, dt     , 1      ]    
               ])* acc_std**2

r =np.array([[meas_std**2, 0          ],
               [0          , meas_std**2]

              ])

h = np.array([[1, 0, 0, 0, 0, 0],
              [0, 0, 0, 1, 0, 0]
             ]) 
I = np.eye(6)


#initial prediction
x_n = f @ x_n 
p_n = f @ p_n @ f.T + q

#print(meas_temp[0] - h @ x_n)
for i in range(n_of_meas):

    #update
    K = p_n @ h.T @ np.linalg.inv((h @ p_n @ h.T + r))
    Est[:,i] = x_n + K @ (meas_xy[:,i].reshape(2,1) - h @ x_n)
    p_n = (I - K @ h) @ p_n @ (I - K @ h).T + K[i] @ r @ K.T
     
    #predict
    x_n = f @ Est[i]
    p_n = f @ p_n @ f.T + q

#PLOTS
#Estimation plots
plt.figure(1)
plt.plot(Est[0,:], Est[1,:],       label='Estimated Positions', color='red', linestyle='-', linewidth=1)   
plt.title('Vehicle Location Estimation on 2D plane')  
plt.xlabel('X')  
plt.ylabel('Y')  
plt.legend()  
#plt.xlim(t[0], t[-1])
plt.grid(True)
plt.tight_layout()

plt.show() 

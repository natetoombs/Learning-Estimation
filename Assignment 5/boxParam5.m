% Parameter File

% Drawing Params
param.show_animation = true;
param.side = 0.3;
param.map_width = 8;
param.map_height = 7;

% Sim Params
param.t_start = 0;
param.t_end = 10;
param.t_plot = 0.25;

% Initial Params
param.x_start = 1;
param.y_start = 1;

% Process Params
param.st_dev = 0.3;
param.Q = [param.st_dev^2 0; 0 param.st_dev^2]; % Process Covariance

% Measurement Params
param.N = 4; % Measurement Frequency
param.meas_noise = 0.3;
param.R = [param.meas_noise^2 0; 0 param.meas_noise^2];
param.H = [1 0; 0 1];
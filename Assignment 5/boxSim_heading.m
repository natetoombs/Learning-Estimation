clear; clc;

boxParam_heading % Load Params

if param.show_animation
    truth_animation = boxAnimation5(param, 0, param.st_dev, 'b', 1);
    est_animation = boxAnimation5(param, 1, param.st_dev, 'g', 0);
    ref_animation = boxAnimation5(param, 0, param.st_dev, 'k', 0);
end
dataPlot = dataPlotter5(param);

t = param.t_start;
x = param.x_start;
y = param.y_start;
x_hat = x;
y_hat = y;
P = param.Q;
sm = 0;

% Define the position of the reference, and draw it
ref_X = [3;3];
ref_animation.update(ref_X, 0);
while t < param.t_end
    X = [x;y];
    X_hat = [x_hat;y_hat];
    
    if param.show_animation
        truth_animation.update(X, 0);
        est_animation.update(X_hat, P);
    end
    dataPlot.update(t, X, X_hat, P);
    t = t + param.t_plot;
    
    % Movement State Machine for Square Movement
    if sm < 5
        del_x = 0;
        del_y = 1;
        sm = sm + 1;
    elseif sm < 11
        del_x = 1;
        del_y = 0;
        sm = sm + 1;
    elseif sm < 16
        del_x = 0;
        del_y = -1;
        sm = sm + 1;
    elseif sm < 21
        del_x = -1;
        del_y = 0;
        sm = sm + 1;
    else
        sm = 0;
    end
    
    % Update truth with changes in x and y
    x = x + del_x;
    y = y + del_y;
    X = [x;y];
    
    % This is a placeholder for the prediction step
    x_meas = del_x + param.st_dev*randn();
    y_meas = del_y + param.st_dev*randn();
    % Update Predicted States
    x_hat = x_hat + x_meas;
    y_hat = y_hat + y_meas;
    X_hat = [x_hat;y_hat];
    % Update Predicted Covariance
    Q = param.Q;
    P = P + Q;
    
    % Measurement Update (Wikipedia)
    % Use distance and angle to obstacle as a measurement
    if mod(sm,param.N) == 0 % update every N steps
%         if param.show_animation
%             truth_animation.update(X, 0);
%             est_animation.update(X_hat, P);
%         end
        % Get measurements
        theta = atan2(ref_X(1)-x,ref_X(2) - y);
        theta_meas = theta + param.meas_noise*randn(); 
        z = theta_meas;
        
        % Update
        Y = z - h_heading(X_hat,ref_X);
        H = H_heading(X_hat,ref_X);
        S = H * P * H' + param.R;
        K = P * H' * pinv(S);
        X_hat = X_hat + K * Y;
        x_hat = X_hat(1);
        y_hat = X_hat(2);
        P = (eye(2) - K * H) * P;
    end
    
    pause(param.t_plot)
end

dataPlot.plot();

function out = h_heading(X_hat,X_ref)
    x_m = X_ref(1) - X_hat(1);
    y_m = X_ref(2) - X_hat(2);
    out = atan2(x_m,y_m);
end

function out = H_heading(X_hat,X_ref)
    x_m = X_ref(1) - X_hat(1);
    y_m = X_ref(2) - X_hat(2);
    out = [-y_m/(x_m^2+y_m^2),  x_m/(x_m^2+y_m^2)];
end
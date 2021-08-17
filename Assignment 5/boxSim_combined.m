clear; clc;

% Set mode to range, heading, or combined
mode = 'combined';

% Change param to correct file
boxParam5 % Load Params

if param.show_animation
    truth_animation = boxAnimation5(param, 0, param.st_dev, 'b', 1);
    est_animation = boxAnimation5(param, 1, param.st_dev, 'g', 0);
    ref_animation = boxAnimation5(param, 0, param.st_dev, 'k', 0);
    ref2_animation = boxAnimation5(param, 0, param.st_dev, 'k', 0);
    ref3_animation = boxAnimation5(param, 0, param.st_dev, 'k', 0);
end

dataPlot = dataPlotter5(param);

t = param.t_start;
x = param.x_start;
y = param.y_start;
x_hat = x;
y_hat = y;
P = param.Q;
R = param.R;
sm = 0;

% Define the position of the reference, and draw it
ref_X = [3;3];
ref_animation.update(ref_X, 0);
ref2_X = [5;3];
ref2_animation.update(ref2_X, 0);
ref3_X = [4;7];
ref3_animation.update(ref3_X, 0);

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
        l = sqrt((ref_X(1) - x)^2 + (ref_X(2) - y)^2);
        theta = atan2(ref_X(1)-x,ref_X(2) - y);
        l_meas = l + param.meas_noise*randn();
        theta_meas = theta + param.meas_noise*randn(); 

        switch mode
            case 'range'
                z = l_meas;
                Y = z - h_range(X_hat,ref_X);
                H = H_range(X_hat,ref_X);
            case 'heading'
                z = theta_meas;
                Y = z - h_heading(X_hat,ref_X);
                H = H_heading(X_hat,ref_X);
            case 'combined'
                z = [l_meas; theta_meas];
                Y = z - h_combined(X_hat,ref_X);
                H = H_combined(X_hat,ref_X);
        end

        % Update
        [X_hat,P] = measurement_update(Y,H,X_hat,P,R);

                    % Get measurements
        l = sqrt((ref2_X(1) - x)^2 + (ref2_X(2) - y)^2);
        theta = atan2(ref2_X(1)-x,ref2_X(2) - y);
        l_meas = l + param.meas_noise*randn();
        theta_meas = theta + param.meas_noise*randn(); 

        switch mode
            case 'range'
                z = l_meas;
                Y = z - h_range(X_hat,ref2_X);
                H = H_range(X_hat,ref2_X);
            case 'heading'
                z = theta_meas;
                Y = z - h_heading(X_hat,ref2_X);
                H = H_heading(X_hat,ref2_X);
            case 'combined'
                z = [l_meas; theta_meas];
                Y = z - h_combined(X_hat,ref2_X);
                H = H_combined(X_hat,ref2_X);
        end

        [X_hat,P] = measurement_update(Y,H,X_hat,P,R);

        % Get measurements
        l = sqrt((ref3_X(1) - x)^2 + (ref3_X(2) - y)^2);
        theta = atan2(ref3_X(1)-x,ref3_X(2) - y);
        l_meas = l + param.meas_noise*randn();
        theta_meas = theta + param.meas_noise*randn(); 

        switch mode
            case 'range'
                z = l_meas;
                Y = z - h_range(X_hat,ref3_X);
                H = H_range(X_hat,ref3_X);
            case 'heading'
                z = theta_meas;
                Y = z - h_heading(X_hat,ref3_X);
                H = H_heading(X_hat,ref3_X);
            case 'combined'
                z = [l_meas; theta_meas];
                Y = z - h_combined(X_hat,ref3_X);
                H = H_combined(X_hat,ref3_X);
        end

        [X_hat,P] = measurement_update(Y,H,X_hat,P,R);

        x_hat = X_hat(1);
        y_hat = X_hat(2);

    end
    
    pause(param.t_plot)
end

dataPlot.plot();

function [state, cov] = measurement_update(Y,H,X_hat,P,R)
    S = H * P * H' + R;
    K = P * H' * pinv(S);
    state = X_hat + K * Y;

    cov = (eye(2) - K * H) * P;
end

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

function out = h_range(X_hat,X_ref)
    x_m = X_ref(1) - X_hat(1);
    y_m = X_ref(2) - X_hat(2);
    out = sqrt(x_m^2 + y_m^2);
end

function out = H_range(X_hat,X_ref)
    x_m = X_ref(1) - X_hat(1);
    y_m = X_ref(2) - X_hat(2);
    out = [-x_m/sqrt(x_m^2 + y_m^2) -y_m/sqrt(x_m^2 + y_m^2)];
end

function out = h_combined(X_hat,X_ref)
    x_m = X_ref(1) - X_hat(1);
    y_m = X_ref(2) - X_hat(2);
    out = [sqrt(x_m^2 + y_m^2);
         atan2(x_m,y_m)];
end

function out = H_combined(X_hat,X_ref)
    x_m = X_ref(1) - X_hat(1);
    y_m = X_ref(2) - X_hat(2);
    out = [-x_m/sqrt(x_m^2 + y_m^2) -y_m/sqrt(x_m^2 + y_m^2);
           -y_m/(x_m^2+y_m^2)      x_m/(x_m^2+y_m^2)];
end
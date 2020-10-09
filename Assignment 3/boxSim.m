clear; clc;

boxParam % Load Params

if param.show_animation
    truth_animation = boxAnimation(param, 0, param.st_dev, 'b', 1);
    est_animation = boxAnimation(param, 1, param.st_dev, 'g', 0);
end
dataPlot = dataPlotter(param);

t = param.t_start;
x = param.x_start;
y = param.y_start;
x_hat = x;
y_hat = y;
P = param.Q;
sm = 0;
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
    
    % Update truth
    x = x + del_x;
    y = y + del_y;
    % Update estimates
    x_hat = x_hat + del_x + param.st_dev*randn();
    y_hat = y_hat + del_y + param.st_dev*randn();
    
    % Measurement Update (Wikipedia)
    if mod(sm,param.N) == 0 % update every N steps
        zx = x + param.meas_noise*randn();
        zy = y + param.meas_noise*randn();
        z = [zx;zy];
        Y = z - X_hat;
        S = param.H * P * param.H' + param.R;
        K = P * param.H * pinv(S);
        X_hat = X_hat + K * Y;
        x_hat = X_hat(1);
        y_hat = X_hat(2);
        P = (eye(2) - K * param.H) * P;
    end
    
    Q = param.Q;
    P = P + Q;
    
    pause(param.t_plot)
end

dataPlot.plot()
classdef dataPlotter4 < handle
    properties
        time_history
        x_history
        xhat_history
        xerr_history
        y_history
        yhat_history
        yerr_history
        Px_history
        Py_history
        index
        x_handle
        xhat_handle
        xerr_handle
        y_handle
        yhat_handle
        yerr_handle
        xy_handle
        xyhat_handle
        Px_handle
        Py_handle
    end
    methods
        function self = dataPlotter4(param)
            self.time_history = NaN*ones(1,round((param.t_end-param.t_start)/param.t_plot));
            self.x_history = NaN*ones(1,round((param.t_end-param.t_start)/param.t_plot));
            self.y_history = NaN*ones(1,round((param.t_end-param.t_start)/param.t_plot));
            self.xhat_history = NaN*ones(1,round((param.t_end-param.t_start)/param.t_plot));
            self.yhat_history = NaN*ones(1,round((param.t_end-param.t_start)/param.t_plot));
            self.xerr_history = NaN*ones(1,round((param.t_end-param.t_start)/param.t_plot));
            self.yerr_history = NaN*ones(1,round((param.t_end-param.t_start)/param.t_plot));
            self.Px_history = NaN*ones(1,round((param.t_end-param.t_start)/param.t_plot));
            self.Py_history = NaN*ones(1,round((param.t_end-param.t_start)/param.t_plot));
            self.index = 1;
            
%             % For live plots
%             figure(2), clf
%             subplot(4, 1, 1)
%                 hold on
%                 self.x_handle = plot(self.time_history, self.x_history, 'b');
%                 self.xhat_handle = plot(self.time_history, self.xhat_history, 'g');
%                 ylabel('x')
%                 title('X Data')
%             subplot(4, 1, 2)
%                 hold on
%                 self.y_handle = plot(self.time_history, self.y_history, 'b');
%                 self.yhat_handle = plot(self.time_history, self.yhat_history, 'g');
%                 ylabel('y')
%                 title('Y Data')
%             subplot(4, 1, 3)
%                 hold on
%                 self.xerr_handle = plot(self.time_history, self.xerr_history, 'r');
%                 self.Px_handle = plot(self.time_history, self.Px_history, 'b');
%                 ylabel('X Error / P')
%                 title('X Error Data')
%             subplot(4,1,4)
%                 hold on
%                 self.yerr_handle = plot(self.time_history, self.yerr_history, 'r');
%                 self.Py_handle = plot(self.time_history, self.Py_history, 'b');
%                 ylabel('Y Error / P')
%                 title('Y Error Data')
%             figure(3), clf
%                 hold on
%                 self.xy_handle = plot(self.x_history, self.y_history, 'b');
%                 self.xyhat_handle = plot(self.xhat_history, self.yhat_history, 'g');
%                 xlabel('x Data')
%                 ylabel('y Data')
%                 title('XY Data')
        end
        function self = update(self, t, states, est_states, cov)
            % update the time history of all plot variables
            self.time_history(self.index) = t;
            self.x_history(self.index) = states(1);
            self.y_history(self.index) = states(2);
            self.xhat_history(self.index) = est_states(1);
            self.yhat_history(self.index) = est_states(2);
            self.xerr_history(self.index) = est_states(1) - states(1);
            self.yerr_history(self.index) = est_states(2) - states(2);
            self.Px_history(self.index) = cov(1,1);
            self.Py_history(self.index) = cov(2,2);
            self.index = self.index + 1;
            
            % update the plots with associated histories
%             set(self.x_handle, 'Xdata', self.time_history, 'Ydata', self.x_history)
%             set(self.y_handle, 'Xdata', self.time_history, 'Ydata', self.y_history)
%             set(self.xerr_handle, 'Xdata', self.time_history, 'Ydata', self.xerr_history)
%             set(self.yerr_handle, 'Xdata', self.time_history, 'Ydata', self.yerr_history)
%             set(self.xhat_handle, 'Xdata', self.time_history, 'Ydata', self.xhat_history)
%             set(self.yhat_handle, 'Xdata', self.time_history, 'Ydata', self.yhat_history)
%             set(self.xy_handle, 'Xdata', self.x_history, 'Ydata', self.y_history)
%             set(self.xyhat_handle, 'Xdata', self.xhat_history, 'Ydata', self.yhat_history)
%             set(self.Px_handle, 'Xdata', self.time_history, 'Ydata', self.Px_history)
%             set(self.Py_handle, 'Xdata', self.time_history, 'Ydata', self.Py_history)
        end
        function self = plot(self)
            figure(2), clf
            % Plot x data (truth and estimate)
            subplot(4, 1, 1)
                hold on
                self.x_handle = plot(self.time_history, self.x_history, 'b');
                self.xhat_handle = plot(self.time_history, self.xhat_history, 'g');
                ylabel('x')
                title('X Data')
            % Plot y data (truth and estimate)
            subplot(4, 1, 2)
                hold on
                self.y_handle = plot(self.time_history, self.y_history, 'b');
                self.yhat_handle = plot(self.time_history, self.yhat_history, 'g');
                ylabel('y')
                title('Y Data')
            subplot(4, 1, 3)
            % Plot x error data (error and P)
                hold on
                self.xerr_handle = plot(self.time_history, self.xerr_history, 'r');
                self.Px_handle = plot(self.time_history, 3*self.Px_history.^(1/2), 'b');
                self.Px_handle = plot(self.time_history, -3*self.Px_history.^(1/2), 'b');
                ylabel('X Error / P')
                title('X Error Data')
            % Plot y error data (error and P)
            subplot(4,1,4)
                hold on
                self.yerr_handle = plot(self.time_history, self.yerr_history, 'r');
                self.Py_handle = plot(self.time_history, 3*self.Py_history.^(1/2), 'b'); % 3-sigma
                self.Py_handle = plot(self.time_history, -3*self.Py_history.^(1/2), 'b'); % 3-sigma
                ylabel('Y Error / P')
                title('Y Error Data')
            figure(3), clf
                hold on
                self.xy_handle = plot(self.x_history, self.y_history, 'b');
                self.xyhat_handle = plot(self.xhat_history, self.yhat_history, 'g');
                xlabel('x Data')
                ylabel('y Data')
                title('XY Data')
        end
    end
end
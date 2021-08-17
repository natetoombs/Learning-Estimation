% Animation Class for a box with a covariance ellipse
classdef boxAnimation4
    properties
        side % Side length
        box_handle
        box_x
        box_y
        sigma_handle
        map_width
        map_height
        bool
        sigma
        color
    end
    methods
        function self = boxAnimation4(param, bool, sigma, color, clear)
            self.bool = bool;
            self.sigma = sigma;
            self.color = color;
            self.side = param.side;
            self.map_width = param.map_width;
            self.map_height = param.map_height;
            figure(1)
            if clear
                clf
            end
            hold on
            self=self.draw_box(param.x_start,param.y_start);
            if self.bool
                mu = [self.box_x;self.box_y];
                p = .997;
                self=self.draw_sigma(mu,self.sigma,p);
            end
            axis([0, self.map_width, 0, self.map_height])
            grid on
                       
        end
        
        function self=update(self, state, sigma) %Add covariance
            x = state(1);
            y = state(2);
            self = self.draw_box(x,y);
            mu = [self.box_x;self.box_y];
            p = .997;
            if self.bool
                self=self.draw_sigma(mu,sigma,p); % Add covariance
            end
            drawnow
        end
        
        function self=draw_box(self, x, y)
            self.box_x = x;
            self.box_y = y;
            X = [x-self.side/2, x+self.side/2,...
                x+self.side/2, x-self.side/2];
            Y = [y+self.side/2, y+self.side/2,...
                y-self.side/2, y-self.side/2];
            if isempty(self.box_handle)
                self.box_handle = fill(X,Y,self.color);
            else
                set(self.box_handle,'XData',X,'YData',Y)
            end
        end
        
%         function self=draw_sigma(self, sigma)
%             r_x = sigma;
%             r_y = sigma;
%             th = 0:2*pi/50:2*pi;
%             X = self.box_x + r_x*cos(th);
%             Y = self.box_y + r_y*sin(th);
%           
%             if isempty(self.sigma_handle)
%                 self.sigma_handle = plot(X,Y,'r');
%             else
%                 set(self.sigma_handle,'XData',X,'YData',Y);
%             end
%         end
        
        function self = draw_sigma(self, mu, Sigma, p)
            s = -2 * log(1 - p);
            [V, D] = eig(Sigma * s);
            t = linspace(0, 2 * pi);
            a = (V * sqrt(D)) * [cos(t(:))'; sin(t(:))'];

            X = a(1, :) + mu(1);
            Y = a(2, :) + mu(2);
            
            if isempty(self.sigma_handle)
                self.sigma_handle = plot(X,Y,'r');
            else
                set(self.sigma_handle,'XData',X,'YData',Y);
            end
        end
    end
end

                
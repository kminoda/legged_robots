function u = control_koji(q, dq)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function
theta = [pi + q(1) - q(3); pi - q(3) + q(2)];
%dtheta = [dq(1) - dxq(3); - dq(3) + dq(2)];

thetad = getNextDesiredTheta(theta, 0.01);
disp("current theta is " + string(theta))
disp("desired theta is " + string(thetad))
disp("=====================")
%dthetad = [0; 0];

kp = [-4e2, -1e2; -1e2, -4e2];
kv = [0, 0; 0, 0];

u = kp * (thetad - theta);% + kv * (dthetad - dtheta);
%u = zeros(2, 1);
end


function nextDTheta = getNextDesiredTheta(theta, dt)
theta1_func = @(t) 2/3*(t + pi);
theta2_func = @(t) pi*(1 + cos(t)/3);
objFunc = @(t) (theta1_func(t) - theta(1))^2 + (theta2_func(t) - theta(2))^2;

% calculate the optimal t for current theta
t = fminbnd(objFunc, 0, pi);

% set theta at t + dt as desired state
nextDTheta = [theta1_func(t + dt); theta2_func(t + dt)];
end
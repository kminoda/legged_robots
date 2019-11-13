function u = control_koji(t, q, dq)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function
theta = [pi + q(1) - q(3); pi - q(3) + q(2)];
%dtheta = [dq(1) - dxq(3); - dq(3) + dq(2)];

thetad = getNextDesiredTheta(theta, 0.01);
disp("current theta is " + string(theta))
disp("desired theta is " + string(thetad))
%dthetad = [0; 0];

kp = 6.9*[-4e1, -1e1; -1e1, -4e1];
kv = [0, 0; 0, 0];

u = kp * (thetad - theta);% + kv * (dthetad - dtheta);
disp("input is " + string(u))

%u = zeros(2, 1);
disp("=====================")

end
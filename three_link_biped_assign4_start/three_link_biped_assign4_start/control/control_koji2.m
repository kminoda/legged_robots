function u = control_koji2(q, dq)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function

[qd, dqd, ddqd] = getNextDesiredQ(q, 0.1);

kp = -1e4 .* [1, 1, 1; 1, 1, 1; 1, 1, 1];
kd = [0, 0, 0; 0, 0, 0; 0, 0, 0];

qTemp = ddqd + kd * (dqd - dq) + kp * (qd - q);
Dq = eval_M(qTemp) * q;
Tr = eval_C(q, dq) * dq + eval_G(q);
u = pinv(eval_B) * (Tr + Dq)


disp("current q is " + string(q))
disp("desired q is " + string(qd))
disp("=====================")
end


function [qd, dqd, ddqd] = getNextDesiredQ(q, dt)
dqd = [0; 0; 0];
ddqd = [0; 0; 0];
qd = [0; 0; 0];
q1 = @(t) t;
q2 = @(t) -pi/3*sin(3/2*t);
objFunc = @(t) (q1(t) - q(1))^2 + (q2(t) - q(2))^2;

t = fminbnd(objFunc, -pi/3, pi/3);

qd(1) = q1(t + dt);
qd(2) = q2(t + dt);

end
function u = control_static_control(t, q, dq)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function

qd = [0; pi/3; 0];
%disp("current q is " + string(q))
%disp("desired q is " + string(qd))
%dthetad = [0; 0];

kp = 200*[-1, -1.5, 1;
      -1.5, -1, 1];
kv = 10*[1, 1, 1;
    1, 1, 1];

u = kp * (q - qd) + pinv(eval_B)*eval_G(q);
%disp("input is " + string(u))

%u = zeros(2, 1);
%disp("=====================")

end
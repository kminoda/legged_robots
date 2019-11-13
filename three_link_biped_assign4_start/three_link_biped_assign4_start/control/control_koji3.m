function u = control_koji3(t, q, dq)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function

qd = getDesiredQ(t);
%disp("current q is " + string(q))
%disp("desired q is " + string(qd))
%dthetad = [0; 0];

kp = 100 * [1, 1, 0;
      1, 1, 0;
      0, 0, 1];
kv = 0*[1, 1, 1;
    1, 1, 1;
    1, 1, 1];

uG = pinv(eval_B) * eval_G(q);
uC = pinv(eval_B) * eval_C(q, dq) * dq;
uM = pinv(eval_B) * eval_M(q) * (kp * (q - qd) + kv * (dq));
u = uM + uC + uG;
%u = pinv(eval_B)*eval_G(q);
disp("input delta is " + string(u(1)-uG(1)) + ' ' + string(u(2)-uG(2)));

%u = zeros(2, 1);
%disp("=====================")

end
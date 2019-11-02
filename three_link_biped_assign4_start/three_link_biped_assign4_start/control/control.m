% function u = control(t, q, dq, q0, dq0, step_number
function u = control(t, q, dq)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function


u = control_koji(q, dq);
%u = control_koji2(q, dq);

end
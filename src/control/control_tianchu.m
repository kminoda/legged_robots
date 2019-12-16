function u = control_tianchu(t,q,dq)%(t, q, dq, q0, dq0, step_number)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function
% t is the current time
% q is the desired q(t)
% dq is the desired dq(t)
[~, ~, ~, l1, l2, l3, ~] = set_parameters;
q1 = q(1); q2 = q(2); q3 = q(3);
dq1 = dq(1); dq2 = dq(2); dq3 = dq(3);
%% circle walking gait
% theta = [q1; q2]; dtheta = [dq1; dq2];
% % theta_d = [-pi/(6*(t*t+1)); 3*pi/2]
% theta_d = [pi/6; 11*pi/6 + 0.1]
% dtheta_d = [0; 0];
% kp = 500*diag([1,1]);
% % kp = [500, 0; 0, 0]
% kd = 100*diag([1,1]);
% % kd = [100, 0; 0, 0]
% u = -kp*(theta-theta_d) - kd*(dtheta-dtheta_d)
% % humain walking gait
% theta = [q1; q2]; dtheta = [dq1; dq2];
% % theta_d = [-pi/(6*(t*t+1)); 3*pi/2]
% theta_d = [pi/6+0.1; 0]
% dtheta_d = [0; 0];
% kp = 500*diag([1,1]);
% kp = [50, 0; 0, 500]
% kd = 100*diag([1,1]);
% u = -kp*(theta-theta_d) - kd*(dtheta-dtheta_d);
% u = [100;1];
%%
% % Feedback Linearization + computed torque:
% % The dynamic: M(q)*ddq + C(q,dq)*dq + G(q) = Bu
% % M(q)*ddq + N(q,dq) = Bu
% M = eval_M(q); N = eval_C(q,dq)*dq + eval_G(q);
% M = vpa(M,3); N = vpa(N,3);
% % hyper parameter:
% kp1 = 500; kp2 = 500;
% kd1 = 100; kd2 = 100;
% % desired output: [qd,dqd,ddqd]
% [qd, dqd, ddqd] = desired_outputs(t,q0,dq0);
% q1d = qd(1); q2d = qd(2); %q3d = qd(3); %% be careful about dq3
% dq1d = dqd(1); dq2d = dqd(2); %dq3d = dqd(3); 
% ddq1d = ddqd(1); ddq2d = ddqd(2); %dq3d = dqd(3); 
% % feedback error: e(3x1) = [e1; e2; e3]
% e1 = q1d - q1; e2 = q2d - q2; %e3 = q3d - q3;
% de1 = dq1d - dq1; de2 = dq2d - dq2; %de3 = dq3d - dq3;
% % linearized control input v(3x1) = [v1;v2:v3], such that ddq1 = v1; ddq2 = v2; ddq3 = v3
% % v1 = ddq1d + kp1*e1 + kd1*de1;
% % v2 = ddq2d + kp2*e2 + kd2*de2;
% v1 = kp1*e1 + kd1*de1;
% v2 = kp2*e2 + kd2*de2;
% v3 = -(sum(M(:,1:2)*[v1;v2])+sum(N))/sum(M(:,3)); % We can not control v3
% v = [v1; v2; v3];
% % real control input u = f(v)
% u1 = M(1,:)*v + N(1);
% u2 = M(2,:)*v + N(2);
% u1 = vpa(u1);
% u2 = vpa(u2);
% u = [u1; u2]
%% test
% u = [0;0];
%% simplified PD
% q1d = pi/6; dq1d = 0;
% q2d = -pi/6; dq2d = 0;
% kp1 = 500; kp2 = 500;
% kd1 = 100; kd2 = 100;
% m11 = 10; m12 = -cos(q1-q2);
% m21 = -cos(q1-q2); m22 = cos(q1-q3);
% v1 = kp1*(q1d-q1) + kd1*(dq1d-dq1);
% v2 = kp2*(q2d-q2) + kd2*(dq2d-dq2);
% u1 = m11*v1 + m12*v2 + 100*q3;
% u2 = m21*v1 + m22*v2 + 100*q3;
% u = [u1;u2];
%% heuristic PD (working unnaturally 1)
%%%%%%%%successful parameters: 
% kp1 = 500; kp2 = 1000;
% kd1 = 100; kd2 = 100;
%%%%%%%%
% q1d = pi/6; dq1d = 0;
% q2d = -pi/6; dq2d = 0;
% kp1 = 500; kp2 = 1000;
% kd1 = 100; kd2 = 100;
% u1 = kp1*(q1d-q1) + kd1*(dq1d-dq1);
% u2 = kp2*(q2d-q2) + kd2*(dq2d-dq2);
% u = [u1;u2];
%% heuristic PD (Working!!!)
% Please use this initial condition: sln = solve_eqns([pi/24; -pi/24; 0], [0;0;0], 20)
% q1d = pi/6; dq1d = 0;
% q2d = -pi/6; dq2d = 0;
% q3d = 0; dq3d = 0;
kp1 = 500; kp2 = 1000;
kd1 = 500; kd2 = 100;
u1 = kp1*(q3-q1+pi/36) + kd1*(dq3-dq1) + 500*(dq3-dq2);
u2 = kp2*(q3-q2-5*pi/36) + kd2*(dq3-dq2);
u = [u1;u2];
end

function dy = myEqns(t, y, u, noise_q, noise_dq)
% n this is the dimension of the ODE, note that n is 2*DOF, why? 
% y1 = q1, y2 = q2, y3 = q3, y4 = dq1, y5 = dq2, y6 = dq3

% if noise
%q = y(1:3);
%dq = y(4:6);
q = y(1:3) + noise_q * randn(3, 1);
dq = y(4:6) + noise_dq * randn(3, 1);

M = eval_M(q);
C = eval_C(q, dq);
G = eval_G(q);
B = eval_B();

n = 6;   
dy = zeros(n, 1);

% write down the equations for dy:
dy(1:3) = dq;
dy(4:6) = inv(M) * (B*u - C*dq - G);
end
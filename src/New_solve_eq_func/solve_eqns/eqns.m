function dy = eqns(t, y, y0, step_number, dCpgdt_u1, dCpgdt_u2, strategy)
% n this is the dimension of the ODE, note that n is 2*DOF, why? 
% y1 = q1, y2 = q2, y3 = q3,     y4 = dq1, y5 = dq2, y6 = dq3
% y0 is the states right after impact
% y7 = phase of u1, y8 = torque pattern of u1
% y9 = phase of u2, y10 = torque pattern of u2

q = [];
dq = [];

q0 = [];
dq0 = [];

M = [];
C = [];
G = [];
B = [];

u = control(t, q, dq, q0, dq0, step_number); 

n = 8;   
dy = zeros(n, 1);
dy(1) = y(4);
dy(2) = y(5);
dy(3) = y(6);

uu_fb = []; % no cpg 
uu_ff = []; % cpg

if(strategy == 0)           % fb only
    uu = [];
elseif(strategy == 1)       % cpg only
    uu = [];
elseif(strategy == 2)      % N% cpg 
    uu = [];
elseif(strategy == 3)      % Different percentage for u1 and u2
    uu = [];
end

dy(4:6) = [];
dy(7:8) = [];
dy(9:10) = [];

end
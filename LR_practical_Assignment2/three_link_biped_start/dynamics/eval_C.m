function C = eval_C(dq1,dq2,dq3,l1,l2,l3,m2,m3,q1,q2,q3)
%EVAL_C
%    C = EVAL_C(DQ1,DQ2,DQ3,L1,L2,L3,M2,M3,Q1,Q2,Q3)

%    This function was generated by the Symbolic Math Toolbox version 8.4.
%    15-Oct-2019 12:20:15

t2 = -q2;
t3 = -q3;
t4 = q1+t2;
t5 = q1+t3;
t6 = sin(t4);
t7 = sin(t5);
C = reshape([0.0,(dq1.*l1.*l2.*m2.*t6)./2.0,dq1.*l1.*l3.*m3.*t7.*(-1.0./2.0),dq2.*l1.*l2.*m2.*t6.*(-1.0./2.0),0.0,0.0,(dq3.*l1.*l3.*m3.*t7)./2.0,0.0,0.0],[3,3]);

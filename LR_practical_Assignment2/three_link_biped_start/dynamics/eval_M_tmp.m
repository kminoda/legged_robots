function M = eval_M_tmp(l1,l2,l3,m1,m2,m3,q1,q2,q3)
%EVAL_M_TMP
%    M = EVAL_M_TMP(L1,L2,L3,M1,M2,M3,Q1,Q2,Q3)

%    This function was generated by the Symbolic Math Toolbox version 8.4.
%    15-Oct-2019 09:50:30

t2 = -q2;
t3 = -q3;
t4 = q1+t2;
t5 = q1+t3;
t6 = cos(t4);
t7 = cos(t5);
t8 = (l1.*l2.*m2.*t6)./2.0;
t9 = (l1.*l3.*m3.*t7)./2.0;
t10 = -t8;
M = reshape([(l1.^2.*(m1+m2.*4.0+m3.*4.0))./4.0,t10,t9,t10,(l2.^2.*m2)./4.0,0.0,t9,0.0,(l3.^2.*m3)./4.0],[3,3]);

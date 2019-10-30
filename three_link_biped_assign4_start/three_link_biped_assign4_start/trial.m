clc; close all; clear all;
q0 = [-pi/6; pi/4; 0];
dq0 = [0; 0; 0];
sln = solve_eqns(q0, dq0, 1);
animate(sln);
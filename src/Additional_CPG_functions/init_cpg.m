function [y0, dCpgdt_u1, dCpgdt_u2] = init_cpg(y0, ff_u1, ff_u2)
% Initialize Cpg
g = 10; % gain, how fast the awo tracks the input signal g
% U1
model_u1 = awo_modelFunc(ff_u1);
awo_u1 = @(t,y,omega,gamma,model) [omega;100*(model_u1.g(y(1))-y(2))+model_u1.dg(y(1))*omega];
dCpgdt_u1 = @(t,y) awo_u1(t,y,freq,g,model_u1);
y0 = [y0; [0;3.1]];
% U2
model_u2 = awo_modelFunc(ff_u2);
awo_u2 = @(t,y,omega,gamma,model) [omega;100*(model_u2.g(y(1))-y(2))+model_u2.dg(y(1))*omega];
dCpgdt_u2 = @(t,y) awo_u2(t,y,freq,g,model_u2);
y0 = [y0; [0;-5.6]];
end


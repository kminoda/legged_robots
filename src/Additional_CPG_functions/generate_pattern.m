function [ff_u1, ff_u2, freq] = generate_pattern(steps, controls)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% generate cpg patterns
L = 100; % Set the number of data points you want.

% we loop on all the steps
U1 = [];
U2 = [];
T  = [];
for i = 1:num_steps
    s = find(diff(steps == i) == 1);
    if(isempty(s))
        s = 1;
    end
    e = find(diff(steps == i) == -1);
    if(isempty(e))
        e = length(steps);
    end
    % normalize in time
    y = controls(:,s:e);
    x  = linspace(0,1,length(y));
    xx = linspace(0,1,L);
    yy = spline(x,y,xx);
    U1 = [U1; yy(1,:)];
    U2 = [U2; yy(2,:)];
    T = [T; length(y)];
end

ff_u1 = mean(U1);
ff_u2 = mean(U2);
dt = 0.001;
freq  = 1.0/(dt*mean(T));
end


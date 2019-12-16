%% Solve equations of motion 
% Note: eqns.m defines the equations of motion to be solved by this script
% This function returns the time vector T, the solution Y, the event time
% TE, solution at the event time YE.
% q0, dq0 are the initial angles and angular velocities, num_steps are the
% number of steps the robot is supposed to take
% As an example you can use q0 = [pi/6; -pi/3; 0] and dq0 = [0;0;0]. 

function sln = solve_eqns_by_time(q0, dq0, tmax, u)

% options = ...
h = 0.001; % time step
%tmax = 2; % max time that we allow for a single step
y0 = [q0; dq0];
t0 = 0;

x0 = 0;
%tspan = 0:h:2*h;% from 0 to tmax with time step h

opts = odeset('Event', @event_func, 'RelTol', 1e-4);

% we define the solution as a structure to qsimplify the post-analyses and
% animation, here we intialize it to null. 
sln.T = {};
sln.Y = {};
sln.TE = {};
sln.YE = {};

numImpact = 0;
while true
    %tspan = t0:h:tmax+t0;
    tspan = 0 : h : tmax;

    eqnsControlled = @(t, y) myEqns(t, y, u);
    [T, Y, TE, YE] = ode45(eqnsControlled, tspan, y0, opts);% use ode45 to solve the equations of motion (eqns.m)
    %[T, Y, TE, YE] = ode45(func, tspan, y0);% use ode45 to solve the equations of motion (eqns.m)

    sln.T{numImpact+1} = T;
    sln.Y{numImpact+1} = Y;
    sln.TE{numImpact+1} = TE;
    sln.YE{numImpact+1} = YE;
    sln.X0{numImpact+1} = x0;
    
    % Impact map
    
    if ~isempty(TE)
        q_m = YE(1:3).';
        dq_m = YE(4:6).';
    
        [q_p, dq_p] = impact(q_m, dq_m);
        y0 = [q_p; dq_p];
        [x_swf, ~, ~, ~] = kin_swf(q_m, dq_m);
        x0 = x0 + x_swf;
        
        sln.T{numImpact+2} = [0];
        sln.Y{numImpact+2} = y0';
        sln.TE{numImpact+2} = [];
        sln.YE{numImpact+2} = [];
        sln.X0{numImpact+2} = x0;
    else
        break
    end
    if T(end) > tmax - h
        break
    end
    tmax = tmax - T(end);
    tmax = tmax - mod(tmax, h);
    numImpact = numImpact + 1;
end
end



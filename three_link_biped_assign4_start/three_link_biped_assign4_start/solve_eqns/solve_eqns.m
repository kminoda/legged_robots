%% Solve equations of motion 
% Note: eqns.m defines the equations of motion to be solved by this script
% This function returns the time vector T, the solution Y, the event time
% TE, solution at the event time YE.
% q0, dq0 are the initial angles and angular velocities, num_steps are the
% number of steps the robot is supposed to take
% As an example you can use q0 = [pi/6; -pi/3; 0] and dq0 = [0;0;0]. 

function sln = solve_eqns(q0, dq0, num_steps)

% options = ...
h = 0.001; % time step
tmax = 2; % max time that we allow for a single step
y0 = [q0; dq0];
t0 = 0;
tspan = 0:h:tmax;% from 0 to tmax with time step h

%tspan = 0:h:2*h;% from 0 to tmax with time step h

opts = odeset('Event', @event_func_tianchu, 'RelTol', 1e-5);

% we define the solution as a structure to qsimplify the post-analyses and
% animation, here we intialize it to null. 
sln.T = {};
sln.Y = {};
sln.TE = {};
sln.YE = {};


for i = 1:num_steps
    %tspan = t0:h:tmax+t0;
    [T, Y, TE, YE] = ode45(@eqns, tspan, y0, opts);% use ode45 to solve the equations of motion (eqns.m)
    %[T, Y, TE, YE] = ode45(func, tspan, y0);% use ode45 to solve the equations of motion (eqns.m)

    sln.T{i} = T;
    sln.Y{i} = Y;
    sln.TE{i} = TE;
    sln.YE{i} = YE;
    if T(end) == tmax
        break
    end
    
    % Impact map
    
    if ~isempty(sln.TE{i})
        q_m = YE(1:3).';
        dq_m = YE(4:6).';
    
        [q_p, dq_p] = impact(q_m, dq_m);
    
        y0 = [q_p; dq_p];
        t0 = T(end);
    end
end
end



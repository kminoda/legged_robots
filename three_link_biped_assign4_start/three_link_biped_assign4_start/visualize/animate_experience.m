%%
% This function animates the solution of the equations of motion of the
% three link biped. 
% sln is the solution computed by solve_eqns.m
%%
function animate_experience(experience)

figure();
skip = 1; 
data = experience.Observation.BipedStates.Data;
prevPivotFoot = 0;
num_steps = length(data); %length(sln.Y); % total number of steps the robot has taken (find this from sln)
r0 = [0; 0];
tic();
for i = 1:skip:(num_steps-1)
    if data(7, 1, i)~=prevPivotFoot
        prevPivotFoot = data(7, 1, i);
        [x_swf, ~, ~, ~] = kin_swf(q, dq);
        r0 = r0 + [x_swf; 0];
    end
    q = data(1:3, 1, i);%
    dq = data(4:6, 1, i);%
    pause(0.002);  % pause for 2 mili-seconds
    % visualize :
    visualize(q, r0);
        
    hold off
    % update r0:
end
t_anim = toc();

% Real time factor is the actual duration of the simulations (get it from sln) to
% the time it takes for MATLAB to animate the simulations (get it from
% t_anim). How does 'skip' effect this value? what does a real time factor
% of 1 mean?
real_time_factor = 0.01;% This is only an estimation 
fprintf('Real time factor:');
disp(real_time_factor);
end
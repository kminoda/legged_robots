function [NextObs, Reward, IsDone, LoggedSignals] = myStepFunction(Action, LoggedSignals)
    Action = double(Action);

    numObs = size(LoggedSignals.State, 1);
    state = reshape(LoggedSignals.State, [numObs, 1]);
    q0 = state(1:3, :);
    dq0 = state(4:6, :);
    if (LoggedSignals.T >= 4 && rem(LoggedSignals.T, 2.0)<1e-2)
        LoggedSignals.noise_1 = 2*randi(2)-3;
        LoggedSignals.noise_2 = 2*randi(2)-3;
    end
    if (LoggedSignals.T > 4 && abs(rem(LoggedSignals.T, 2.0)-0.1) < 1e-2)
        LoggedSignals.noise_1 = 0;
        LoggedSignals.noise_2 = 0;
    end
    global u_with_noise;
    global u_noise;
    Action(1) = Action(1) + LoggedSignals.noise_1 * LoggedSignals.amp_noise;
    Action(2) = Action(2) + LoggedSignals.noise_2 * LoggedSignals.amp_noise;
   
    u_noise = [u_noise, [LoggedSignals.noise_1 * LoggedSignals.amp_noise; LoggedSignals.noise_2 * LoggedSignals.amp_noise]];
    u_with_noise = [u_with_noise, Action];
    
    % calculate next step q, dq, pivotFoot
    sln = solve_eqns_by_time(q0, dq0, LoggedSignals.Ts, Action);
                         
    y0 = sln.Y{end}(end, :)';
    
    % update some parameters
    LoggedSignals.prevPivotFoot = LoggedSignals.pivotFoot;
    LoggedSignals.pivotFoot = mod(size(sln.TE, 2) - 1 + LoggedSignals.pivotFoot, 2);
    LoggedSignals.x0 = LoggedSignals.x0 + sln.X0{end};
    LoggedSignals.T = LoggedSignals.T + LoggedSignals.Ts;
    
    % update state
    LoggedSignals.State = [y0 ; LoggedSignals.pivotFoot; Action];
    NextObs = LoggedSignals.State;    
    
    % update x_swf in LoggedSignals
    [~, z_h, ~, ~] = kin_hip(NextObs(1:3), NextObs(4:6));
    [x_swf, z_swf, ~, ~] = kin_swf(NextObs(1:3), NextObs(4:6));
    LoggedSignals.x_swf = LoggedSignals.x0 + x_swf;
    
    % calculate reward
    Reward = getReward(LoggedSignals, Action);
    LoggedSignals.totalReward = LoggedSignals.totalReward + Reward;
    
    % terminate or not
    IsDone = false;
    if (z_h < 0)
        Reward = -1 * (1 - LoggedSignals.T / LoggedSignals.Tf);
        IsDone = true;
        disp("Terminating Condition : hip is underground");
    end
    if (z_swf < -0.2)
        Reward = -1 * (1 - LoggedSignals.T / LoggedSignals.Tf);
        IsDone = true;
        disp("Terminating Condition : swing foot is underground");
    end
    if (abs(NextObs(1))>pi*0.75)
        Reward = -1 * (1 - LoggedSignals.T / LoggedSignals.Tf);
        IsDone = true;
        disp("Terminating Condition : Foot 1 is too high");
    end
    if (abs(NextObs(2))>pi*0.75)
        Reward = -1 * (1 - LoggedSignals.T / LoggedSignals.Tf);
        IsDone = true;
        disp("Terminating Condition : Foot 2 is too high");
    end
    if (abs(NextObs(3))>pi*0.75)
        Reward = -1 * (1 - LoggedSignals.T / LoggedSignals.Tf);
        IsDone = true;
        disp("Terminating Condition : Torso is too low");
    end
    
    if (LoggedSignals.T >= LoggedSignals.Tf)
        IsDone = true;
        Reward = Reward + 1;
    end
    
    LoggedSignals.prevprevAction = LoggedSignals.prevAction;
    LoggedSignals.prevAction = Action;

    % log if terminate
    if IsDone
        disp("Total Reward : " + num2str(LoggedSignals.totalReward));
        disp("Terminate timestep : " + num2str(LoggedSignals.T/LoggedSignals.Ts));
        disp("=======================");
        global numSteps;
        numSteps = numSteps + 1;
        disp("# Episode : " + num2str(numSteps));
    end
end
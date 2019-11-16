function [NextObs, Reward, IsDone, LoggedSignals] = myStepFunction(Action, LoggedSignals)
    LoggedSignals.prevAction = Action;

    numObs = size(LoggedSignals.State, 1);
    state = reshape(LoggedSignals.State, [numObs, 1]);
    q0 = state(1:3, :);
    dq0 = state(4:6, :);
    
    sln = solve_eqns_by_time(q0, dq0, LoggedSignals.Ts, Action, ...
                             LoggedSignals.noise_u, ...
                             LoggedSignals.noise_q, ...
                             LoggedSignals.noise_dq);
    y0 = sln.Y{end}(end, :)';
    if isempty(sln.TE{end})
        LoggedSignals.pivotFoot = mod(size(sln.TE, 2) - 1 + LoggedSignals.pivotFoot, 2);
        LoggedSignals.x0 = LoggedSignals.x0 + sln.X0{end};
    else 
        LoggedSignals.pivotFoot = mod(size(sln.TE, 2) + LoggedSignals.pivotFoot, 2);
        q_m = y0(1:3);
        dq_m = y0(4:6);
        [q_p, dq_p] = impact(q_m, dq_m);
        y0 = [q_p; dq_p];
        [x_swf, ~, ~, ~] = kin_swf(q_m, dq_m);
        LoggedSignals.x0 = LoggedSignals.x0 + sln.X0{end} + x_swf;
    end
    LoggedSignals.State = [y0 ; LoggedSignals.pivotFoot];
    %LoggedSignals.State = sln.Y{end}(end, :)';
    LoggedSignals.T = LoggedSignals.T + LoggedSignals.Ts;

    NextObs = LoggedSignals.State;
    
    [x_h, z_h, dx_h, ~] = kin_hip(NextObs(1:3), NextObs(4:6));
    [x_swf, z_swf, dx_swf, ~] = kin_swf(NextObs(1:3), NextObs(4:6));
    LoggedSignals.x_swf = LoggedSignals.x0 + x_swf;
    
    Reward = getReward2(LoggedSignals);
    
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
    if (abs(NextObs(3))>pi*0.5)
        Reward = -1 * (1 - LoggedSignals.T / LoggedSignals.Tf);
        IsDone = true;
        disp("Terminating Condition : Torso is too low");
    end
    
    if (LoggedSignals.T >= LoggedSignals.Tf)
        IsDone = true;
        Reward = Reward + 1;
    end
end
function [NextObs, Reward, IsDone, LoggedSignals] = myStepFunction(Action, LoggedSignals)

    numObs = size(LoggedSignals.State, 1);
    state = reshape(LoggedSignals.State, [numObs, 1]);
    q0 = state(1:3, :);
    dq0 = state(4:6, :);
    
    sln = solve_eqns_by_time(q0, dq0, LoggedSignals.Ts, Action);
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

    
    %% Reward
    r_zh = -0.04 * (z_h - 0.45)^2;
    r_dxh = 0.04 * dx_h;
    r_t = 0.1 * LoggedSignals.T / LoggedSignals.Tf;
    r_u = -1e-5 * norm(Action)^2;
    
    Reward = r_zh + r_dxh + r_t + r_u;
    LoggedSignals.x_swf = LoggedSignals.x0 + x_swf;
    if (abs(NextObs(4))>pi/2 || abs(NextObs(5))>pi/2)
        Reward = -0.01;
    end
    
    IsDone = false;
    if (z_h < 0 || z_swf < -0.2)
        IsDone = true;
    end
    
    if (LoggedSignals.T >= LoggedSignals.Tf)
        IsDone = true;
        Reward = Reward + 1;
    end
end
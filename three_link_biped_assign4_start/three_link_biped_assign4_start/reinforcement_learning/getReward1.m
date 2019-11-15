function reward = getReward1(LoggedSignals)
    NextObs = LoggedSignals.State;
    
    [x_h, z_h, dx_h, ~] = kin_hip(NextObs(1:3), NextObs(4:6));
    [x_swf, z_swf, dx_swf, ~] = kin_swf(NextObs(1:3), NextObs(4:6));

    r_zh = -0.1 * (z_h - 0.45)^2;
    r_dxh = 0.01 * dx_h;
    r_t = 0.05 * LoggedSignals.Ts / LoggedSignals.Tf;
    %r_t = 0.005;
    r_u = -2e-5 * norm(LoggedSignals.prevAction)^2;
    
    reward = r_zh + r_dxh + r_t + r_u;
end
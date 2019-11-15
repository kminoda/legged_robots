function reward = getReward2(LoggedSignals)
    NextObs = LoggedSignals.State;
    
    [x_h, z_h, dx_h, dz_h] = kin_hip(NextObs(1:3), NextObs(4:6));
    [x_swf, z_swf, dx_swf, ~] = kin_swf(NextObs(1:3), NextObs(4:6));

    r_height = 0.1*(z_h - 0.3);
    r_speed = 0.01*min(dx_h, 1);
    r_time = 0.0025*LoggedSignals.Ts / LoggedSignals.Tf;

    th_dxswf = 0.4;
    r_swf = (max(th_dxswf, dx_swf) - th_dxswf)*0.03;
    
    r_penalty1 = 0;
    if (r_height<0)
        r_penalty1 = -0.1*r_height^2;
    end
    
    r_penalty2 = 0;
    if (dx_h<0.2)
        r_penalty2 = -0.002;
    end    
    
    r_penalty3 = 0;
    Hdot = -0.8;
    if (dz_h < Hdot)
        r_penalty3 = 0.2*(exp(dz_h - Hdot)- 1);
    end
    
    reward = r_height + r_speed + r_time + r_swf + r_penalty1 + r_penalty2 + r_penalty3;
end
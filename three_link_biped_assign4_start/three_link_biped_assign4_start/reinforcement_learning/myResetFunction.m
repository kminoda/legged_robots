function [InitialObservation, LoggedSignals] = myResetFunction()
    q2 = 0.5 * randn;
    q1 = (0.5*rand - 1) * q2 ;
    q3 = 0.1 * randn;
    
    q0 = [q1; q2; q3];
    q0 = [pi/6; -pi/4 ; 0];
    dq0 = [0; 0; 0];
    LoggedSignals.State = [q0; dq0; 0.; 0.; 0.];
    InitialObservation = reshape(LoggedSignals.State, [9, 1]);

    LoggedSignals.prevPivotFoot = 0;
    LoggedSignals.pivotFoot = 0;
    LoggedSignals.amp_noise = 10;
    LoggedSignals.noise_freq = 1;
    
    LoggedSignals.noise_1 = 0;
    LoggedSignals.noise_2 = 0;
    
    LoggedSignals.ODEOpts = odeset('Event', @event_func, 'RelTol', 1e-5);
    LoggedSignals.Ts = 0.01;
    LoggedSignals.Tf = 4;
    LoggedSignals.prevAction = [0;0];
    LoggedSignals.prevprevAction = [0; 0];
    LoggedSignals.totalReward = 0;

    LoggedSignals.T = 0;
    LoggedSignals.x0 = 0;
    [x_h, ~, ~, ~] = kin_hip(q0, dq0);
    [x_swf, ~, ~, ~] = kin_hip(InitialObservation(1:3), InitialObservation(4:6));
    LoggedSignals.x_h = x_h;
    LoggedSignals.x_swf = x_swf;

end
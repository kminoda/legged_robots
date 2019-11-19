function [InitialObservation, LoggedSignals] = myResetFunction()
    q0 = [pi/6; -pi/4; 0];
    dq0 = [0; 0; 0];
    LoggedSignals.State = [q0; dq0; 0.; 0.; 0.];
    InitialObservation = reshape(LoggedSignals.State, [9, 1]);

    LoggedSignals.prevPivotFoot = 0;
    LoggedSignals.pivotFoot = 0;
    LoggedSignals.noise_u = 0.0;
    LoggedSignals.noise_q = 0.0;
    LoggedSignals.noise_dq = 0.0;
    
    LoggedSignals.ODEOpts = odeset('Event', @event_func, 'RelTol', 1e-5);
    LoggedSignals.Ts = 0.01;
    LoggedSignals.Tf = 20;
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
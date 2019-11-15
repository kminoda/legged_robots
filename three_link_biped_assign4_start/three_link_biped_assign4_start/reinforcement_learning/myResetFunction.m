function [InitialObservation, LoggedSignals] = myResetFunction()
    q0 = [pi/6; -pi/4; 0];
    dq0 = [0; 0; 0];
    LoggedSignals.State = [q0; dq0; 0];
    %LoggedSignal.State = [q0; dq0];
    InitialObservation = reshape(LoggedSignals.State, [7, 1]);

    LoggedSignals.pivotFoot = 0;
    
    LoggedSignals.ODEOpts = odeset('Event', @event_func, 'RelTol', 1e-5);
    LoggedSignals.Ts = 0.01;
    LoggedSignals.Tf = 10;
    LoggedSignals.prevAction = [0;0];

    LoggedSignals.T = 0;
    LoggedSignals.x0 = 0;
    [x_h, ~, ~, ~] = kin_hip(q0, dq0);
    [x_swf, ~, ~, ~] = kin_hip(InitialObservation(1:3), InitialObservation(4:6));
    LoggedSignals.x_h = x_h;
    LoggedSignals.x_swf = x_swf;

end
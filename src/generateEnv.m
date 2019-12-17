function env = generateEnv(numObs, numAct)

    ObservationInfo = rlNumericSpec([numObs 1]);
    ObservationInfo.Name = 'Biped States';
    ObservationInfo.Description = 'q1, q2, q3, dq1, dq2, dq3, pivotFoot';
    
    ActionInfo = rlNumericSpec([numAct 1], 'LowerLimit', -30, 'UpperLimit', 30);
    ActionInfo.Name = 'Biped Action';
    
    env = rlFunctionEnv(ObservationInfo, ActionInfo, 'myStepFunction', 'myResetFunction');
end
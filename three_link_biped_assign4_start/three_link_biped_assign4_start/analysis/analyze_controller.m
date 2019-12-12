function analyze_controller(control)
    % initial parameter setting
    q0 = [pi/36; -pi/36 ; 0];
    dq0 = [0; 0; 0];
    num_steps = 2;
    noise_norm = 0;
    
    % generate sln
    sln = solve_eqns_for_analyze(q0, dq0, num_steps, control, noise_norm);
    
    % analyze sln
    analyze_sln(sln, control);
    
    %% TODO: analysis on pertubation.
%     noise_norm_list = [1e-5, 1e-3, 1e-1];
%     for noise_norm = noise_norm_list:
%         sln = solve_eqns_for_analyze(q0, dq0, num_steps, control, 0);
%         analyze_sln(sln, control);
%     end
    
end
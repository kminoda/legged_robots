function analyze_sln(sln, ctrl)
%%%%% You should put your controller as well as sln, which you used to
%%%%% generate the sln.
%%%%% IMPORTANT: use analyze_controller.m instead of this function.


    %% initial preparation
    num_steps = length(sln.Y);
    dt = 0.001;
    t = [];
    q = [];
    dq = [];
    x0 = 0;
    freq = [];
    
    for i = 1:num_steps
        t = [t; sln.T{i}];
        q = [q; sln.Y{i}(:, 1:3)];
        dq = [dq; sln.Y{i}(:, 4:6)];
        freq = [freq ; 1/sln.TE{i}];
        [x_swf, ~, ~, ~] = kin_swf(q, dq);
        x0 = x0 + x_swf;
    end
        
    [init_x_h, ~, ~, ~] = kin_hip(q(1,:), dq(1,:));
    [final_x_h, ~, ~, ~] = kin_hip(q(end,:), dq(end,:));
    final_x_h = final_x_h + x0;
    
    for i = 1:size(q, 1)
        u(i, :) = ctrl(t(i), q(i, :), dq(i, :)); 
        [~, ~, dx_h(i), ~] = kin_hip(q(i,:), dq(i,:));
    end
    
    %% plot q
    figure(1)
    plot(q(:, 1));
    hold on 
    %figure(2)
    plot(q(:, 2));
    hold on
    %figure(3)
    plot(q(:, 3));
    legend('q1','q2','q3');
    title('q');
    
    %% plot dq
    figure(2)
    plot(dq(:, 1));
    hold on
    plot(dq(:, 2));
    hold on
    plot(dq(:, 3));   
    legend('dq1','dq2','dq3');
    title('dq');
    
    %% plot u
    figure(3)
    plot(u(:, 1));
    hold on
    plot(u(:, 2));
    legend('u1','u2');
    
    %% plot velocity
    figure(4)
    plot(dx_h);
    title('dx_h');
    
    %% plot q1 VS dq1
    figure(5)
    plot(q(:, 1), dq(:, 1));
    xlabel('q1');
    ylabel('dq1');
    title('q1 VS dq1');
    
    %% plot q2 VS dq2
    figure(6)
    plot(q(:, 2), dq(:, 2));
    xlabel('q2');
    ylabel('dq2');
    title('q2 VS dq2');
    
    %% plot q3 VS dq3
    figure(7)
    plot(q(:, 3), dq(:, 3));
    xlabel('q3');
    ylabel('dq3');
    title('q3 VS dq3');

    %% plot frequency VS step number, to see the convergence to steady walking gait.
    figure(8)
    plot(freq)
    xlabel('number of steps');
    ylabel('frequency [Hz]');
    title('Step frequency VS steps. It converges to steady walking gait if this is also converging.');
    
    
    dx = final_x_h - init_x_h; %TODO: need to change here
    CoT = calcCoT(dt, dq, u, dx);
    disp("Cost of Transportation : " + CoT);
end

function CoT = calcCoT(dt, dq, u, dx)
    term1 = 0;
    term2 = 0;
    for i = 1:size(u, 1)
        term1 = term1 + max(0, u(i, 1)*(dq(i, 1)-dq(i, 3)));
        term2 = term2 + max(0, u(i, 2)*(dq(i, 2)-dq(i, 3)));
    end
    CoT = (term1 + term2) * dt / dx;
end
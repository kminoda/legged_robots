    global u_with_noise;
    global u_noise;

    obs = sln_rl.Observation.BipedStates.Data;
    act = sln_rl.Action.BipedAction.Data;
    fignum = 1;
    
    min_t = 1;
    max_t = 400;
    
    h = 0.01;
        
    q = [];
    dq = [];
    for i = 1 : size(obs, 3)
        q(i, :) = obs(1:3, 1, i);
        dq(i, :) = obs(4:6, 1, i);
        [~, ~, dx_h(i), ~] = kin_hip(q(i,:), dq(i,:));
    end  
    
    u = [];
    for i = 1 : size(act, 3)
        u(i, :) = act(:, 1, i);
    end    
    
    impact_step = [];
    prevPivotFoot = 0;
    strides = [];
    freq = [];
    
    t = 0;
    xf = 0;
    CoT = 0;
    
    for i = 1 : size(obs, 3)-1
        t = t + h;
        if i > 400
            CoT = CoT + max(0, u(i, 1)*(dq(i, 1) - dq(i, 3)))*h;
            CoT = CoT + max(0, u(i, 2)*(dq(i, 2) - dq(i, 3)))*h;
        end
        if prevPivotFoot ~= obs(7, 1, i)
            impact_step = [impact_step; i-1];
            [x_swf, ~, ~, ~] = kin_swf(obs(1:3, 1, i), obs(4:6, 1, i));
            strides = [strides; abs(x_swf)];
            [x_swf_prev, ~, ~, ~] = kin_swf(obs(1:3, 1, i-1), obs(4:6, 1, i-1));
            if i > 400
                xf = xf + x_swf_prev;
            end
            if 1/t < 99
                freq = [freq; 1/t];
            else
                freq = [freq; freq(end)];
            end
            prevPivotFoot = obs(7, 1, i);
            t = 0;
        end 
    end
    Results.CoT = CoT / xf;
    
    %% plot q  
    
    if sum(sum(abs(u_noise)))==0
        figure(fignum)
        fignum = fignum + 1;
        
        subplot(4, 1, 1);
        q1 = plot(h*(min_t:max_t), q(min_t:max_t, 1));
        hold on 
        q2 = plot(h*(min_t:max_t), q(min_t:max_t, 2));
        hold on
        q3 = plot(h*(min_t:max_t), q(min_t:max_t, 3));
        for i = 1:size(impact_step, 1)
            step = impact_step(i);
            if (step > min_t) && (step < max_t)
                plot([step*h, step*h], [min(min(q)), max(max(q))], '--', 'Color', 'black')
            end
        end

        legend([q1, q2, q3],{'q1', 'q2', 'q3'});
        ylabel('angle [rad]');
        title('q');


        subplot(4, 1, 2);
        %fignum = fignum + 1;
        dq1 = plot(h*(min_t:max_t), dq(min_t:max_t, 1));
        hold on
        dq2 = plot(h*(min_t:max_t), dq(min_t:max_t, 2));
        hold on
        dq3 = plot(h*(min_t:max_t), dq(min_t:max_t, 3));  
        for i = 1:size(impact_step, 1)
            step = impact_step(i);
            if (step > min_t) && (step < max_t)
                plot([step*h, step*h], [min(min(dq)), max(max(dq))], '--', 'Color', 'black')
            end
        end
        legend([dq1, dq2, dq3],{'dq1', 'dq2', 'dq3'});
        ylabel('angular vel [rad/s]');
        title('dq');

        %% plot u
        subplot(4, 1, 3);
        %figure(fignum)
        %fignum = fignum + 1;
        u1 = plot(h*(min_t:max_t), u_with_noise(1, min_t:max_t));
        hold on
        u2 = plot(h*(min_t:max_t), u_with_noise(2, min_t:max_t));
        for i = 1:size(impact_step, 1)
            step = impact_step(i);
            if (step > min_t) && (step < max_t)
                plot([step*h, step*h], [min(min(u_with_noise))*1.2, max(max(u_with_noise))*1.2], '--', 'Color', 'black')
            end
        end
        legend([u1, u2],{'u1', 'u2'});
        ylabel('torque [Nm]');
        title('u');

        subplot(4, 1, 4);
        dx_h_plot = plot(h*(min_t:max_t), dx_h(min_t:max_t));
        hold on
        for i = 1:size(impact_step, 1)
            step = impact_step(i);
            if (step > min_t) && (step < max_t)
                plot([step*h, step*h], [min(dx_h)*1.2, max(dx_h)*1.2], '--', 'Color', 'black')
            end
        end
        ylabel('dx_h [m/s]');
        xlabel('time [s]');
        title('dx_h');  
    else
        figure(fignum)
        fignum = fignum + 1;

        subplot(5, 1, 1);
        u1 = plot(h*(min_t:max_t), u_noise(1, min_t:max_t));
        hold on
        u2 = plot(h*(min_t:max_t), u_noise(2, min_t:max_t));
        for i = 1:size(impact_step, 1)
            step = impact_step(i);
            if (step > min_t) && (step < max_t)
                plot([step*h, step*h], [min(min(u_noise))*1.2, max(max(u_noise))*1.2], '--', 'Color', 'black')
            end
        end

        legend([u1, u2],{'impulse on u1', 'impulse on u2'});
        ylabel('torque [Nm]');
        title('u');

        subplot(5, 1, 2);
        q1 = plot(h*(min_t:max_t), q(min_t:max_t, 1));
        hold on 
        q2 = plot(h*(min_t:max_t), q(min_t:max_t, 2));
        hold on
        q3 = plot(h*(min_t:max_t), q(min_t:max_t, 3));
        for i = 1:size(impact_step, 1)
            step = impact_step(i);
            if (step > min_t) && (step < max_t)
                plot([step*h, step*h], [min(min(q)), max(max(q))], '--', 'Color', 'black')
            end
        end
        legend([q1, q2, q3],{'q1', 'q2', 'q3'});
        ylabel('angle [rad]');
        title('q');


        subplot(5, 1, 3);
        %fignum = fignum + 1;
        dq1 = plot(h*(min_t:max_t), dq(min_t:max_t, 1));
        hold on
        dq2 = plot(h*(min_t:max_t), dq(min_t:max_t, 2));
        hold on
        dq3 = plot(h*(min_t:max_t), dq(min_t:max_t, 3));  
        for i = 1:size(impact_step, 1)
            step = impact_step(i);
            if (step > min_t) && (step < max_t)
                plot([step*h, step*h], [min(min(dq)), max(max(dq))], '--', 'Color', 'black')
            end
        end
        legend([dq1, dq2, dq3],{'dq1', 'dq2', 'dq3'});
        ylabel('angular vel [rad/s]');
        title('dq');

        %% plot u
        subplot(5, 1, 4);
        %figure(fignum)
        %fignum = fignum + 1;
        u1 = plot(h*(min_t:max_t), u_with_noise(1, min_t:max_t));
        hold on
        u2 = plot(h*(min_t:max_t), u_with_noise(2, min_t:max_t));
        for i = 1:size(impact_step, 1)
            step = impact_step(i);
            if (step > min_t) && (step < max_t)
                plot([step*h, step*h], [min(min(u_with_noise))*1.2, max(max(u_with_noise))*1.2], '--', 'Color', 'black')
            end
        end
        legend([u1, u2],{'u1', 'u2'});
        ylabel('torque [Nm]');
        title('u');

        subplot(5, 1, 5);
        dx_h_plot = plot(h*(min_t:max_t), dx_h(min_t:max_t));
        hold on
        for i = 1:size(impact_step, 1)
            step = impact_step(i);
            if (step > min_t) && (step < max_t)
                plot([step*h, step*h], [min(dx_h)*1.2, max(dx_h)*1.2], '--', 'Color', 'black')
            end
        end
        ylabel('dx_h [m/s]');
        xlabel('time [s]');
        title('dx_h');

    end
    
    %% calc stride
    figure(fignum);
    fignum = fignum + 1;
    subplot(3, 1, 1);
    plot(1:size(strides,1), strides, '-.x');
    xlabel("Number of step");
    ylabel("Distance of stride[m]");
    Results.strides = strides;
    ylim([0 0.5]);

    subplot(3, 1, 2);
    plot(1:size(strides,1), freq, '-.x');
    xlabel("Number of step");
    ylabel("Frequency[Hz]");
    Results.strides = strides;
    
    subplot(3, 1, 3);
    plot(1:size(strides,1), strides.*freq, '-.x');
    xlabel("Number of step");
    ylabel("Average Velocity[m/s]");
    Results.strides = strides;
    
    
    %% q vs dq
    figure(fignum);
    fignum = fignum + 1;
    plot(q(:, 1), dq(:, 1));
    xlabel('q1');
    ylabel('dq1');
    
    figure(fignum);
    fignum = fignum + 1;
    plot(q(:, 2), dq(:, 2));
    xlabel('q2');
    ylabel('dq2');    
    
    figure(fignum);
    fignum = fignum + 1;
    plot(q(:, 3), dq(:, 3));
    xlabel('q3');
    ylabel('dq3');

    %% print others
    Results.mean_dx_h = mean(dx_h(400:end), 'all');
    disp('mean of dx_h' + Results.mean_dx_h);
    Results
function plot_experience(experience)
    %% plot q
    data = experience.Observation.BipedStates.Data;
    action = experience.Action.BipedAction.Data;
    N = size(experience.Observation.BipedStates.Data,3);
    
    for i = 1 : N
        if data(7,1,i)==1
            q1(i) = data(1, 1, i);
            q2(i) = data(2, 1, i);
            dq1(i) = data(4, 1, i);
            dq2(i) = data(5, 1, i);
        else
            q1(i) = data(2, 1, i);
            q2(i) = data(1, 1, i);
            dq1(i) = data(5, 1, i);
            dq2(i) = data(4, 1, i);
        end
        q3(i) = data(3, 1, i);
        dq3(i) = data(6, 1, i);
    end
    
    for i = 1 : N - 1
        if data(7,1,i)==1
            u1(i) = action(1, 1, i);
            u2(i) = action(2, 1, i);
        else
            u1(i) = action(2, 1, i);
            u2(i) = action(1, 1, i);
        end
    end

    figure(1)
    plot(q1);
    hold on 
    %figure(2)
    plot(q2);
    hold on
    %figure(3)
    plot(q3);
    legend('q1','q2','q3');
    title('q');
    
    %figure(2)
    figure(2)
    plot(dq1);
    hold on
    plot(dq2);
    hold on
    plot(dq3);   
    legend('dq1','dq2','dq3');
    
    
    %% plot u
    figure(3)
    plot(u1);
    hold on
    plot(u2);
    legend('u1','u2');
    title('u');
    
    %% plot q1-q2
    figure(4)
    plot(q1, q2)
    title('q1-q2');
end
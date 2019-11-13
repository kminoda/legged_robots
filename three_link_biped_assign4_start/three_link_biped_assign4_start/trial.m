clc; close all; clear all;
set_path;
q0 = [-pi/6+0.1; pi/6+0.15 ; 0];
%q0 = [0.1; pi/3; 0.1];
dq0 = [0; 0; 0];
sln = solve_eqns(q0, dq0, 1);
animate(sln);
hold off

q1 = sln.Y{1}(:, 1);
q2 = sln.Y{1}(:, 2);
q3 = sln.Y{1}(:, 3);

dt = 0.01;
for i = 1:size(sln.T{1},1)
    qd(:, i) = getDesiredQ(sln.T{1}(i));
end

figure(2);
plot(q1);
hold on
plot(qd(1, :), '--');
legend('q1','q1 desired');

%figure(3)
plot(q2);
hold on
plot(qd(2, :), '--');
legend('q2','q2 desired');


%figure(4)
plot(q3);
hold on
plot(qd(3, :), '--');
legend('q3','q3 desired');

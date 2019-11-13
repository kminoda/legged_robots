
function nextDTheta = getNextDesiredTheta(theta, dt)
theta1_func = @(t) 2/3*(t + pi);
theta2_func = @(t) pi*(1 + cos(t)/3);
objFunc = @(t) (theta1_func(t) - theta(1))^2 + (theta2_func(t) - theta(2))^2;

% calculate the optimal t for current theta
t = fminbnd(objFunc, 0, pi);

% set theta at t + dt as desired state
nextDTheta = [theta1_func(t + dt); theta2_func(t + dt)];
end
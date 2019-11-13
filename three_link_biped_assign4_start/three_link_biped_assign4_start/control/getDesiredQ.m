function nextDQ = getDesiredQ(t)
T = 500 * 0.001;

if rem(floor(t/T), 2) == 0
    q1 = - pi/6 * (1 - 2*rem(t, T)/T);
else 
    q1 = pi/6 * (1 - 2*rem(t, T)/T);
end

q2 = pi/3*sin(2*pi*(t+T/6)/(4/3*T));
q3 = 0.1;

nextDQ = [q1; q2; q3];

end
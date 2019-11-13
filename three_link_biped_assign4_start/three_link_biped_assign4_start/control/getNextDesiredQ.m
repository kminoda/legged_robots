function nextDQ = getNextDesiredQ(q)
T = 200 * 0.001;
if rem(floor(2*t/T), 2) == 0
    q1 = - pi/6 * (1 - 4*rem(t, T/2)/T);
else 
    q1 = pi/6 * (1 - 4*rem(t, T/2)/T);
end

q2 = pi/4*cos(2*pi*t/T);
q3 = 0.1;

nextDQ = [q1; q2; q3];

end
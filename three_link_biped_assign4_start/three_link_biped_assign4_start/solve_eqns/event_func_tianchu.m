%% 
% This function defines the event function.
% In the three link biped, the event occurs when the swing foot hits the
% ground.
%%
function [value,isterminal,direction] = event_func(t, y)

[m1, m2, m3, l1, l2, l3, g] = set_parameters();
% you may want to use kin_swf to set the 'value' ???
value = l1*cos(y(1)) - l2*cos(y(2)) + 10*1e-3; % We want value = 0 when the swing foot hits the ground
value = value + abs(l1*sin(y(1)) - l2*sin(y(2))) - (l1*sin(y(1)) - l2*sin(y(2))); % We want x_swf > 0 when the swing foot hits the ground
isterminal = 1;  %We want the integration to terminate at a zero of this event action
direction = -1;   %We want all zeros are to be located

end

function newU = saturate(u)
    newU = u ;
    % Saturation of torques
    if u(1) > 30
        newU(1) = 30;
    end
    if u(2) > 30
        newU(2) = 30;
    end
    if u(1) < -30
        newU(1) = -30;
    end
    if u(2) < -30
        newU(2) = -30;
    end

end 
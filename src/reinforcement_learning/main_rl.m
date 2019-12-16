%name = './savedAgentsSuccess/savedAgents191126/Agent5750';
%name = './savedAgentsSuccess/savedAgents191127/Agent11173';
%name = './savedAgentsSuccess/savedAgents191212/Agent2640';
%name = './savedAgentsSuccess/savedAgents191214/Agent8041';
function sln_rl = main_rl(saved_agent)
    numObs = 9;
    numAct = 2;
    global u_with_noise;
    global u_noise;
    u_with_noise = [];
    u_noise = [];
    env = generateEnv(numObs, numAct);
    simOptions = rlSimulationOptions('MaxSteps',5000);
    disp("generating experience...");
    sln_rl = sim(env,saved_agent,simOptions);
    disp("animation start");
    animate_rl(sln_rl);
end



%name = 'savedAgentsSuccess/savedAgents19111501/Agent2160';
name = 'Agent2817';
load(name);
numObs = 9;
numAct = 2;
env = generateEnv(numObs, numAct);
simOptions = rlSimulationOptions('MaxSteps',5000);
disp("generating experience...");
experience = sim(env,saved_agent,simOptions);
disp("animation start");
animate_experience(experience)
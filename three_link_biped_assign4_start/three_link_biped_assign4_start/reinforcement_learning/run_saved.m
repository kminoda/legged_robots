name = 'Agent1944';
load(name);
numObs = 7;
numAct = 2;
env = generateEnv(numObs, numAct);
simOptions = rlSimulationOptions('MaxSteps',5000);
disp("generating experience...");
experience = sim(env,saved_agent,simOptions);
disp("animation start");
animate_experience(experience)
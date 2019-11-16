clear all;

numObs = 7;
numAct = 2;
[InitialObservation, LoggedSignals] = myResetFunction();
env = generateEnv(numObs, numAct);
agent = getDDPGAgent(numObs, numAct, env);

%% 6

maxepisodes = 5000;
maxsteps = ceil(LoggedSignals.Tf/LoggedSignals.Ts);
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes,...
    'MaxStepsPerEpisode',maxsteps,...
    'ScoreAveragingWindowLength',100,...
    'Verbose',false,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',20,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue', 20,...
    'SaveAgentCriteria', "EpisodeReward",...
    'SaveAgentValue',20,...
    'SaveAgentDirectory',"savedAgents");

%% 7
doTraining = true;
if doTraining
    % Train the agent.
    trainingStats = train(agent,env,trainOpts);
else
    % Load pretrained agent for the example.
    load('SimulinkPendulumDDPG.mat','agent')
end

%% 8
simOptions = rlSimulationOptions('MaxSteps',5000);
experience = sim(env,agent,simOptions);
save(opt.SaveAgentDirectory + "/finalAgent.mat", 'agent')
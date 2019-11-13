

numObs = 7;
numAct = 2;

env = generateEnv(numObs, numAct);

%% 1
statePath = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','observation')
    fullyConnectedLayer(256,'Name','CriticStateFC1')
    reluLayer('Name', 'CriticRelu1')
    fullyConnectedLayer(128,'Name','CriticStateFC2')];
actionPath = [
    imageInputLayer([numAct 1 1],'Normalization','none','Name','action')
    fullyConnectedLayer(128,'Name','CriticActionFC1','BiasLearnRateFactor',0)];
commonPath = [
    additionLayer(2,'Name','add')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(1,'Name','CriticOutput')];

criticNetwork = layerGraph();
criticNetwork = addLayers(criticNetwork,statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
criticNetwork = addLayers(criticNetwork,commonPath);
    
criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1');
criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');

%% 2
%figure
%plot(criticNetwork)

criticOpts = rlRepresentationOptions('Optimizer', 'adam', 'LearnRate',1e-03,'GradientThreshold',1);

obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);
critic = rlRepresentation(criticNetwork,obsInfo,actInfo,'Observation',{'observation'},'Action',{'action'},criticOpts);

%% 3
actorNetwork = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','observation')
    fullyConnectedLayer(256,'Name','ActorFC1')
    reluLayer('Name','ActorRelu1')
    fullyConnectedLayer(128,'Name','ActorFC2')
    reluLayer('Name','ActorRelu2')
    fullyConnectedLayer(numAct,'Name','ActorFC3')
    tanhLayer('Name','ActorTanh')
    scalingLayer('Name','ActorScaling','Scale',max(actInfo.UpperLimit))];

actorOpts = rlRepresentationOptions('Optimizer', 'adam', 'LearnRate',1e-04,'GradientThreshold',1);

actor = rlRepresentation(actorNetwork,obsInfo,actInfo,'Observation',{'observation'},'Action',{'ActorScaling'},actorOpts);

%% 4
[InitialObservation, LoggedSignal] = myResetFunction();
agentOpts = rlDDPGAgentOptions(...
    'SampleTime', LoggedSignal.Ts,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',1e7,...
    'DiscountFactor',0.99,...
    'MiniBatchSize',1024);
agentOpts.NoiseOptions.Variance = 0.6;
agentOpts.NoiseOptions.VarianceDecayRate = 1e-5;

%% 5
agent = rlDDPGAgent(actor,critic,agentOpts);


%% 6
maxepisodes = 5000;
maxsteps = ceil(LoggedSignal.Tf/LoggedSignal.Ts);
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes,...
    'MaxStepsPerEpisode',maxsteps,...
    'ScoreAveragingWindowLength',5,...
    'Verbose',false,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',20,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue', 20);

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
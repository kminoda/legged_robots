function agent = getPPOAgent(numObs, numAct, env)
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);

criticNetwork = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','state')
    fullyConnectedLayer(1,'Name','CriticFC')];
criticOpts = rlRepresentationOptions('LearnRate',8e-3,'GradientThreshold',1);
critic = rlRepresentation(criticNetwork,obsInfo,'Observation',{'state'},criticOpts);

actorNetwork = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','state')
    fullyConnectedLayer(2,'Name','action')];
actorOpts = rlRepresentationOptions('LearnRate',8e-3,'GradientThreshold',1);
actor = rlRepresentation(actorNetwork,obsInfo,actInfo,...
    'Observation',{'state'},'Action',{'action'},actorOpts);

agentOpts = rlPPOAgentOptions(...
    'ExperienceHorizon',1024, ...
    'DiscountFactor',0.95);
agent = rlPPOAgent(actor,critic,agentOpts);
end
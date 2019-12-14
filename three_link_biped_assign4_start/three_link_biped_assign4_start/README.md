# How to run reinforcement learning algorithm.
In order to run the simulation with the trained model, run the following command.
> \>\> !cd reinforcement_learning  
> \>\> load('saved_model/Agent_xx')   
> \>\> sln_rl = main_rl(saved_agent)  

You can also analyze the solution with the following command.  
> \>\> analyze_rl(sln_rl)  

Agent can be trained from scratch by the following command. Note that this may take a long time to converge.
> \>\> train_rl  
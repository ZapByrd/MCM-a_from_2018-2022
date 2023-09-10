function Dir=Jmdir(Dir1,Dir2)

Dir20=Dir2*(2*Dir1*Dir2');
Dir=Dir20-Dir1;
Dir=Dir/norm(Dir);



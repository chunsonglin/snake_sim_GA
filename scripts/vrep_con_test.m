clc;
clear all;
close all;

% Starting simulation bridge
[sim, clientID] = startSim();

% defining joint and individuals
joints = 10;
individuals = 10;

% joint handles initializations
jointHandles = zeros (joints, individuals);

% acquiring the joint handles from simulation
for i=1:individuals
    for j=1:joints
        jointName = sprintf('/snake0[%d]/Servo_joint_%d', i-1, j-1);
        [~, jointHandles(i,j)] = sim.simxGetObjectHandle(clientID,jointName,sim.simx_opmode_oneshot_wait);
    end
end

function [sim, clientID] = startSim()
    sim=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
    sim.simxFinish(-1); % just in case, close all opened connections
    clientID=sim.simxStart('127.0.0.1',19997,true,true,5000,5);
    if (clientID>-1)
        disp('Connected to remote API server');
    else
        disp('Failed connecting to remote API server');
        stopSim(sim, clientID)
    end
end

function stopSim(sim, clientID)
    sim.simxPauseSimulation(clientID,sim.simx_opmode_oneshot_wait); % pause simulation
    %sim.simxStopSimulation(clientID,sim.simx_opmode_oneshot_wait); % stop simulation
    sim.simxFinish(clientID);  % close the line if still open
    sim.delete();              % call the destructor!
    disp('simulation ended');
end
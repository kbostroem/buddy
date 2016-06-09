%% learning
%
% turn off certain (irrelevant) warnings
warning('off','Simulink:Engine:OutputNotConnected');
warning('off','Simulink:Engine:LineWithoutDst');

% init random generator
rng(0,'twister');

learn = 1; % switch on learning
nCycle = 6; % number of cycles per block
nBlock = 5; % number of blocks per target
learnSeq = repmat([repmat(1,1,nCycle) repmat(2,1,nCycle)],1,nBlock);
nLearn = length(learnSeq);

targetFunc = [];
inputFunc = [];
inputSigFunc = [];
for i=1:nLearn
	targetFunc = [targetFunc; targets{learnSeq(i)}];
	inputFunc = [inputFunc; repmat(inputVecs{learnSeq(i)},size(targets{learnSeq(i)},1),1)];
	inputSigFunc = [inputSigFunc; repmat(learnSeq(i),size(targets{learnSeq(i)},1),1)];
end

target.time = [];
target.signals.values = targetFunc;
target.signals.dimensions = size(targetFunc,2);
targetLength = size(targetFunc,1);
stopTime = targetLength*dt-dt;
input.time = [];
input.signals.values = inputFunc;
inputSig.time = [];
inputSig.signals.values = inputSigFunc;

simOutLearn = sim('Reafference_forward','StopTime',num2str(stopTime));

% store random generator state
rngstate = rng;

save(fullfile(resultsDir,'modelout_forward.mat')); 


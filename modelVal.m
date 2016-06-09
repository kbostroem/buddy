%% validate

% turn off certain (irrelevant) warnings
warning('off','Simulink:Engine:OutputNotConnected');
warning('off','Simulink:Engine:LineWithoutDst');

% setup folders
addpath('tools');
rootDir = '..';
resultsDir = fullfile(rootDir,'Results');
if ~exist(resultsDir, 'dir')
	mkdir(resultsDir);
end

load(fullfile(resultsDir,'modelout.mat'));
learn = 0;
W0_prelearn = W0;
W0 = simOutLearn.get('W');
q0_prelearn = q0;
q0 = simOutLearn.get('q');
P0 = simOutLearn.get('P');


%% recall input blocks

% init random generator
rng(1,'twister');

nCycle = 3; % number of cycles per block
nBlock = 10; % number of blocks per target
blockSeq = [ones(1,nBlock), 2*ones(1,nBlock)];
blockSeq = blockSeq(randperm(2*nBlock));
targetBlocks = cell(1,2);
for targetNr=1:2
	targetBlocks{targetNr} = repmat(targets{targetNr},nCycle,1);
end

valSeq = [];
for blockNr=1:2*nBlock
	valSeq = [valSeq; blockSeq(blockNr)*ones(nCycle,1)];
end

% for inputNr=1:2
% 	targetFuncs{inputNr} = repmat(targets{inputNr},nCycleTot,1);
% end

targetFunc = [];
inputFunc = [];
inputSigFunc = [];
for i=1:nLearn
	targetFunc = [targetFunc; targets{valSeq(i)}];
	inputFunc = [inputFunc; repmat(inputVecs{valSeq(i)},size(targets{valSeq(i)},1),1)];
	inputSigFunc = [inputSigFunc; repmat(valSeq(i),size(targets{valSeq(i)},1),1)];
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

timerVal = tic
simOutVal = sim('Reafference','StopTime',num2str(stopTime));
elapsedTime = toc(timerVal)

save(fullfile(resultsDir,'modelout'));


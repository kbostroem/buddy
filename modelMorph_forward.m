%% morph

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

load(fullfile(resultsDir,'modelout_forward.mat'));
learn = 0;
W0_prelearn = W0;
W0 = simOutLearn.get('W');
q0_prelearn = q0;
q0 = simOutLearn.get('q');
P0 = simOutLearn.get('P');
results = simOutLearn.get('results');
time = results.time;

% init random generator
rng(rngstate);

nSample = floor(size(time,1)/4);
targetFunc = [];
inputFunc = [];
inputSigFunc = [];
for i=1:nSample
	targetFunc(i,:) = (i-1)/nSample*targets{2}(1+mod(i,size(targets{2},1)),:)...
		+(1-(i-1)/nSample)*targets{1}(1+mod(i,size(targets{1},1)),:);
	inputFunc(i,:) = (i-1)/nSample*inputVecs{2}+(1-(i-1)/nSample)*inputVecs{1};
	inputSigFunc(i,:) = (i-1)/nSample*2+(1-(i-1)/nSample)*1;
end

targetFunc = [targetFunc; targetFunc; flipud(targetFunc); flipud(targetFunc)];
inputFunc = [inputFunc; inputFunc; flipud(inputFunc); flipud(inputFunc)];
inputSigFunc = [inputSigFunc; inputSigFunc; flipud(inputSigFunc); flipud(inputSigFunc)];

% nSample1 = floor(size(inputFunc,1)/2);
% for i=1:nSample1
% 	targetFunc(i,:) = (i-1)/nSample1*targets{2}(1+mod(i,size(targets{2},1)),:)...
% 		+(1-(i-1)/nSample1)*targets{1}(1+mod(i,size(targets{1},1)),:);
% 	inputFunc(i,:) = (i-1)/nSample1*inputVecs{2}+(1-(i-1)/nSample1)*inputVecs{1};
% 	inputSigFunc(i,:) = (i-1)/nSample1*2+(1-(i-1)/nSample1)*1;
% end
% nSample2 = floor(size(inputFunc,1)/2);
% for i=1:nSample2
% 	targetFunc(nSample1+i,:) = (i-1)/nSample2*targets{1}(1+mod(i,size(targets{1},1)),:)...
% 		+(1-(i-1)/nSample2)*targets{2}(1+mod(i,size(targets{2},1)),:);
% 	inputFunc(nSample1+i,:) = (i-1)/nSample2*inputVecs{1}+(1-(i-1)/nSample2)*inputVecs{2};
% 	inputSigFunc(nSample1+i,:) = (i-1)/nSample2*1+(1-(i-1)/nSample2)*2;
% end

target.time = [];
target.signals.values = targetFunc;
target.signals.dimensions = size(targetFunc,2);
targetLength = size(targetFunc,1);
stopTime = targetLength*dt-dt;
input.time = [];
input.signals.values = inputFunc;
inputSig.time = [];
inputSig.signals.values = inputSigFunc;

simOutMorph = sim('Reafference_forward','StopTime',num2str(stopTime));

save(fullfile(resultsDir,'modelout_forward.mat')); 

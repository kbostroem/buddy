recalc = 1;

addpath('tools');
% parameters
figWidth = 400;
figHeight = 300;
maxlag = 10; % max lag for cross correlation in seconds

saveDir = '..';

dataDirs = {'Results12_delay0.00', 'Results12_delay0.05',...
	'Results12_delay0.10','Results12_delay0.15',...
	'Results12_delay0.20','Results12_delay0.25'};

nDelays = length(dataDirs);
delays = [0, 0.05, 0.1, 0.15, 0.2, 0.25];

if recalc
	ccmaxLearn = zeros(nDelays,1);
	cctimeLearn = zeros(nDelays,1);
	ccmaxVal = zeros(nDelays,1);
	cctimeVal = zeros(nDelays,1);
	ccmaxMorph = zeros(nDelays,1);
	cctimeMorph = zeros(nDelays,1);
	for delayNr=1:nDelays
		dataDir = fullfile('..',dataDirs{delayNr});
		fprintf('processing %s...\n',dataDir);
		load(fullfile(dataDir,'modelout.mat'));
		% Learning
		results = simOutLearn.get('results');
		time = results.time;
		L = length(time);
		sampleRate = L/abs(time(end)-time(1));
		maxlag = floor(maxlag*sampleRate);
		x = results.signals(1).values(:,1)*180/pi;
		y = results.signals(1).values(:,2)*180/pi;
		[cc, lags] = kbxcorr(x,y,maxlag,'coeff');
		cctime = lags/sampleRate;
		[ccmax, ccind] = max(cc);
		ccmaxLearn(delayNr) = ccmax;
		cctimeLearn(delayNr) = cctime(ccind);
		% Validation
		results = simOutVal.get('results');
		time = results.time;
		L = length(time);
		sampleRate = L/abs(time(end)-time(1));
		maxlag = floor(maxlag*sampleRate);
		x = results.signals(1).values(:,1)*180/pi;
		y = results.signals(1).values(:,2)*180/pi;
		[cc, lags] = kbxcorr(x,y,maxlag,'coeff');
		cctime = lags/sampleRate;
		[ccmax, ccind] = max(cc);
		ccmaxVal(delayNr) = ccmax;
		cctimeVal(delayNr) = cctime(ccind);
		% Morphing
		results = simOutMorph.get('results');
		time = results.time;
		L = length(time);
		sampleRate = L/abs(time(end)-time(1));
		maxlag = floor(maxlag*sampleRate);
		x = results.signals(1).values(:,1)*180/pi;
		y = results.signals(1).values(:,2)*180/pi;
		[cc, lags] = kbxcorr(x,y,maxlag,'coeff');
		cctime = lags/sampleRate;
		[ccmax, ccind] = max(cc);
		ccmaxMorph(delayNr) = ccmax;
		cctimeMorph(delayNr) = cctime(ccind);
	end
end

titleStr = 'Cross correlation';
plot(delays,ccmaxLearn,'k*:');
hold on;
plot(delays,ccmaxVal,'kx--');
plot(delays,ccmaxMorph,'ko-.');
xlim([0 max(delays)]);
ylim([0 1]);
xlabel('Delay [s]');
ylabel('Cross correlation');
box off;
legendStr = {'Learning','Validation','Morphing'};
legend(legendStr,'Location','SouthWest');
set(gca,'fontsize', 16);
title(titleStr);

outFileName = sprintf('%s',titleStr);
fprintf('Save %s to %s\n',outFileName,saveDir);
saveCurrentFigure(gcf,outFileName,saveDir);
close(gcf);
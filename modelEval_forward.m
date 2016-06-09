%% plot learning
% parameters
figWidth = 1024;
figHeight = 768;

load(fullfile('..','Results','modelout_forward.mat'));
addpath('tools');
rootDir = '..';
resultsDir = fullfile(rootDir,'Results');
if ~exist(resultsDir, 'dir')
	mkdir(resultsDir);
end

titleStr = 'Learning';
legendStr = {'expected afference', 'true afference', 'target'};
results = simOutLearn.get('results');
time = results.time;
fig = setupFigure(figWidth,figHeight,titleStr);
cmap = colormap('lines');
nFig = 8;

% input
subplot(nFig,1,1);
input = results.signals(3).values(:,1);
plot(time,input);
xlim([0 time(end)]);
ylim([0.9 2.1]);
set(gca,'XTickLabel',[]);
ylabel('index');
% legend('Input');
title('Network input (index)');

% angle
subplot(nFig,1,[2:3]);
ang_pred = results.signals(1).values(:,1)*180/pi;
ang_prop = results.signals(1).values(:,2)*180/pi;
plot(time,ang_pred,time,ang_prop);
xlim([0 time(end)]);
ylim([1.1 2.4]*180/pi);
set(gca,'XTickLabel',[]);
ylabel('Angle [deg]');
legend('predicted angle', 'sensed angle');
title('Angle');

subplot(nFig,1,[4:5]);
angvel_pred = results.signals(2).values(:,1);
angvel_prop = results.signals(2).values(:,2);
plot(time,angvel_pred,time,angvel_prop);
xlim([0 time(end)]);
set(gca,'XTickLabel',[]);
ylabel('Angular velocity [deg/s]');
legend('predicted angular velocity', 'sensed angular velocity');
title('Angular velocity');

subplot(nFig,1,[6:8]);
dist = 0.05;
output = simOutLearn.get('output');
muscle1_targ = output.signals(1).values(:,2);
muscle2_targ = output.signals(2).values(:,2)-min(muscle1_targ)...
	-abs(max(muscle1_targ)-min(muscle1_targ))-dist;
muscle3_targ = output.signals(3).values(:,2)-min(muscle1_targ)...
	-abs(max(muscle2_targ)-min(muscle2_targ))-dist;
hold on;
plot(time,muscle1_targ,'Color',cmap(2,:));
plot(time,muscle2_targ,'Color',cmap(2,:));
plot(time,muscle3_targ,'Color',cmap(2,:));
xlim([0 time(end)]);
% set(gca,'XTickLabel',[]);
set(gca,'YTick',[]);
ylabel('Act [a.u.]');
legend('generated muscle activation', 'target muscle activation');
title('Muscle activation');
xlabel('Time [s]');

outFileName = sprintf('%s_forward',titleStr);
fprintf('Save %s to %s\n',outFileName,resultsDir);
saveCurrentFigure(gcf,outFileName,resultsDir);
close(gcf);

titleStr = 'Validation';
legendStr = {'expected afference', 'true afference', 'target'};
results = simOutVal.get('results');
time = results.time;
fig = setupFigure(figWidth,figHeight,titleStr);
cmap = colormap('lines');
nFig = 8;

% input
subplot(nFig,1,1);
input = results.signals(3).values(:,1);
plot(time,input);
xlim([0 time(end)]);
ylim([0.9 2.1]);
set(gca,'XTickLabel',[]);
ylabel('index');
% legend('Input');
title('Network input (index)');

% angle
subplot(nFig,1,[2:3]);
ang_pred = results.signals(1).values(:,1)*180/pi;
ang_prop = results.signals(1).values(:,2)*180/pi;
plot(time,ang_pred,time,ang_prop);
xlim([0 time(end)]);
ylim([1.1 2.4]*180/pi);
set(gca,'XTickLabel',[]);
ylabel('Angle [deg]');
legend('predicted angle', 'sensed angle');
title('Angle');

subplot(nFig,1,[4:5]);
angvel_pred = results.signals(2).values(:,1);
angvel_prop = results.signals(2).values(:,2);
plot(time,angvel_pred,time,angvel_prop);
xlim([0 time(end)]);
set(gca,'XTickLabel',[]);
ylabel('Angular velocity [deg/s]');
legend('predicted angular velocity', 'sensed angular velocity');
title('Angular velocity');

subplot(nFig,1,[6:8]);
dist = 0.05;
output = simOutVal.get('output');
muscle1_targ = output.signals(1).values(:,2);
muscle2_targ = output.signals(2).values(:,2)-min(muscle1_targ)...
	-abs(max(muscle1_targ)-min(muscle1_targ))-dist;
muscle3_targ = output.signals(3).values(:,2)-min(muscle1_targ)...
	-abs(max(muscle2_targ)-min(muscle2_targ))-dist;
hold on;
plot(time,muscle1_targ,'Color',cmap(2,:));
plot(time,muscle2_targ,'Color',cmap(2,:));
plot(time,muscle3_targ,'Color',cmap(2,:));
xlim([0 time(end)]);
% set(gca,'XTickLabel',[]);
set(gca,'YTick',[]);
ylabel('Act [a.u.]');
% legend('generated muscle activation', 'target muscle activation');
title('Muscle activation');
xlabel('Time [s]');

outFileName = sprintf('%s_forward',titleStr);
fprintf('Save %s to %s\n',outFileName,resultsDir);
saveCurrentFigure(gcf,outFileName,resultsDir);
close(gcf);

titleStr = 'Morphing';
legendStr = {'expected afference', 'true afference', 'target'};
results = simOutMorph.get('results');
time = results.time;
fig = setupFigure(figWidth,figHeight,titleStr);
cmap = colormap('lines');
nFig = 8;

% input
subplot(nFig,1,1);
input = results.signals(3).values(:,1);
plot(time,input);
xlim([0 time(end)]);
ylim([0.9 2.1]);
set(gca,'XTickLabel',[]);
ylabel('index');
% legend('Input');
title('Network input (index)');

% angle
subplot(nFig,1,[2:3]);
ang_pred = results.signals(1).values(:,1)*180/pi;
ang_prop = results.signals(1).values(:,2)*180/pi;
plot(time,ang_pred,time,ang_prop);
xlim([0 time(end)]);
ylim([1.1 2.4]*180/pi);
set(gca,'XTickLabel',[]);
ylabel('Angle [deg]');
legend('predicted angle', 'sensed angle');
title('Angle');

subplot(nFig,1,[4:5]);
angvel_pred = results.signals(2).values(:,1);
angvel_prop = results.signals(2).values(:,2);
plot(time,angvel_pred,time,angvel_prop);
xlim([0 time(end)]);
set(gca,'XTickLabel',[]);
ylabel('Angular velocity [deg/s]');
legend('predicted angular velocity', 'sensed angular velocity');
title('Angular velocity');

subplot(nFig,1,[6:8]);
dist = 0.05;
output = simOutMorph.get('output');
muscle1_targ = output.signals(1).values(:,2);
muscle2_targ = output.signals(2).values(:,2)-min(muscle1_targ)...
	-abs(max(muscle1_targ)-min(muscle1_targ))-dist;
muscle3_targ = output.signals(3).values(:,2)-min(muscle1_targ)...
	-abs(max(muscle2_targ)-min(muscle2_targ))-dist;
hold on;
plot(time,muscle1_targ,'Color',cmap(2,:));
plot(time,muscle2_targ,'Color',cmap(2,:));
plot(time,muscle3_targ,'Color',cmap(2,:));
xlim([0 time(end)]);
% set(gca,'XTickLabel',[]);
set(gca,'YTick',[]);
ylabel('Act [a.u.]');
% legend('generated muscle activation', 'target muscle activation');
title('Muscle activation');
xlabel('Time [s]');

outFileName = sprintf('%s_forward',titleStr);
fprintf('Save %s to %s\n',outFileName,resultsDir);
saveCurrentFigure(gcf,outFileName,resultsDir);
close(gcf);


function saveCurrentFigure(varargin)

fig = gcf;
fileName = 'Figure';
fileDir = '';
if length(varargin)==1
	fig = varargin{1};
elseif length(varargin)==2
	fig = varargin{1};
	fileName = varargin{2};
elseif length(varargin)==3
	fig = varargin{1};
	fileName = varargin{2};
	fileDir = varargin{3};
end

figPos = get(fig,'Position');
width = figPos(3);
height = figPos(4);
fileTypes = {'fig','pdf'};

set(fig,'PaperPositionMode','auto');
set(fig,'PaperUnits', 'points');
set(fig, 'PaperSize', [width height]);
set(fig,'renderer','painters');

% print resolution
% 72 : monitor resolution
% 300 : printer resolution
printResolution = 300;

for i=1:length(fileTypes)
% 	if ~exist(fullfile(fileDir,fileTypes{i}), 'dir')
% 		mkdir(fullfile(fileDir,fileTypes{i}));
% 	end
	filePath = fullfile(fileDir,fileName);
	saveFigure(fig,filePath,fileTypes{i},width,height);
end

end
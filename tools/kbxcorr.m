function [r, lags] = kbxcorr(x,y,varargin)

scaleType = 'none';

% bring both vectors to column form
x = x(:);
y = y(:);

xmean = mean(x);
xstd = std(x);
ymean = mean(y);
ystd = std(y);

% scale both variables to zero mean
x = x-xmean;
y = y-ymean;

% bring both vectors to the same length
% by padding the shorter one with zeros
Nx = length(x);
Ny = length(y);
N = max(Nx,Ny); % common length
maxlag = N-1; % max lag default
if Nx<Ny
	x = [x; zeros(N-Nx,1)];
else
	y = [y; zeros(N-Ny,1)];
end

switch nargin
	case 3
		if ischar(varargin{1})
			scaleType = varargin{1};
		else
			maxlag = min(varargin{1},maxlag);
		end
	case 4
		if ischar(varargin{1})
			scaleType = varargin{1};
		else
			maxlag = min(varargin{1},maxlag);
		end
		if ischar(varargin{2})
			scaleType = varargin{2};
		else
			maxlag = min(varargin{2},maxlag);
		end
end

% calc cross-correlation

% scaling factor
sf = @(m) 1;
if strcmp(scaleType,'biased')
	sf = @(m) 1/N;
elseif strcmp(scaleType,'unbiased')
	sf = @(m) 1/(N-m+1);
elseif strcmp(scaleType,'coeff') || strcmp(scaleType,'biasedcoeff')
	sf = @(m) 1/N/xstd/ystd;
elseif strcmp(scaleType,'unbiasedcoeff')
	sf = @(m) 1/(N-m+1)/xstd/ystd;
end

rplus = zeros(maxlag+1,1);
rminus = zeros(maxlag+1,1);
for m=1:maxlag+1
	xm = x(1:N-m+1);
	ym = y(m:N);
	rplus(m) = sum(xm .* ym)*sf(m);
end
for m=1:maxlag+1
	xm = x(m:N);
	ym = y(1:N-m+1);
	rminus(m) = sum(xm .* ym)*sf(m);
end
r = [flipud(rminus(1:maxlag)); rplus(1:maxlag+1)];
lags = (-maxlag:maxlag)';

end
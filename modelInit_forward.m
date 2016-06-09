%% init
%
clear
% turn off certain (irrelevant) warnings
warning('off','Simulink:Engine:OutputNotConnected');
% init random generator
rng(0,'twister');

% setup folders
addpath('tools');
rootDir = '..';
resultsDir = fullfile(rootDir,'Results');
if ~exist(resultsDir, 'dir')
	mkdir(resultsDir);
end

%% parameters
%
% muscles
% bifactor = 2.95;
% brfactor = 2.95;
% trifactor = 2.4;
% wfactor = 1;
% infactor = 1;
bifactor = 3;
brfactor = 3;
trifactor = 2.4;
wfactor = 1;
infactor = 1;

delay = 0.1; % delay of reafference in seconds

m_k = 120;
l_k = 206;

l_upper = 0.36;
r_upper = 0.05;
m_upper = 0.25+0.03012*m_k-0.0027*l_k;
m_upper = m_upper*wfactor;
I_upper_x = (-16.9+0.662*m_k+0.0453*l_k)/10000;
I_upper_y = (-250.7+1.56*m_k+1.512*l_k)/10000; 
I_upper_z = (-232+1.525*m_k+1.343*l_k)/10000; 

l_fore = 0.30;
r_fore = 0.05;
m_fore = (0.3185+0.01445*m_k-0.00114*l_k);
m_fore = m_fore*wfactor;
I_fore_x = infactor*(5.66+0.306*m_k-0.088*l_k)/10000;
I_fore_y = infactor*(-64+0.95*m_k+0.34*l_k)/10000;
I_fore_z = infactor*(-67.9+0.855*m_k+0.376*l_k)/10000;

l_hand = 0.20;
m_hand = -0.1165+0.0036*m_k+0.00175*l_k;
m_hand = m_hand*wfactor;
I_hand_x = infactor*(-6.26+0.0762*m_k+0.0347*l_k)/10000; 
I_hand_y = infactor*(-19.5+0.17*m_k+0.116*l_k)/10000;
I_hand_z = infactor*(-13.68+0.088*m_k+0.092*l_k)/10000; 


dt = 0.005;
nAssoc = 2;
dIn = 3;
dOut = 2;
N = 1000;
tau = 0.01;
p = 0.01;
g = 1.5;
alpha = 1.0;
M = full(sprandn(N,N,p)*g*1.0/sqrt(p*N));
F = 2.0*(rand(N,dOut)-0.5);
I = 2.0*(rand(N,dIn)-0.5);
q0 = 0.5*randn(N,1);
W0 = zeros(dOut,N);
P0 = (1.0/alpha)*eye(N,N);

inputVecs{1} = [0.5970, 0.0995, -0.7960];
inputVecs{2} = [0.5628, 0.1025, -0.8202];

load Smo100;
targets{1} = Smo100';
load Smo140;
targets{2} = Smo140';
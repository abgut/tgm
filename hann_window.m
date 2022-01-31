% Hann window function
% 
% Inputs:
%   K - number of frequency points
% 
% Outputs:
%   hw - Hann window over a specified interval from 0 to K-1 points

function hw = hann_window(K)
n=0:K-1; 
hw = 0.5-0.5*cos(2*pi*n/K);
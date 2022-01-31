% A function that extracts the number of frequency points (variable K) and
% calculates the time-domain resolution, as well as time-domain sweep. The
% function is required for time gating method (TGM) and calibration 
% algorihtm for TGM intervals.
% 
% Inputs:
%   omega - frequency sweep
% 
% Outputs:
%   dt      - time-domain step
%   tsweep  - time-domain sweep
%   N       - number of time-domain points
%   K       - number of frequency-domain points
% 
% Copyright (c) 2021, Adrian Bekasiewicz
% All rights reserved.
% 
% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function [dt,tsweep,N,K]=calculate_time_sweep_and_npts(omegam)
K=length(omegam);
nP=nextpow2(K)+3;
N=2^nP;
fmax=omegam(end);
fmin=omegam(1);
BW=(fmax-fmin);
dt=1/BW;
tsweep=linspace(0,K-1,N);
tsweep=tsweep*dt;
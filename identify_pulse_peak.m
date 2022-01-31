% A function that performs analysis of the impulse response over all
% considered angles of rotation in order to provide initial estimate of the
% time gating window intervals
% 
% Inputs:
%   Rf      - transmission between reference antenna and AUT for a given 
%             angle of rotation
%   N       - number of points in time domain
% 
% Outputs:
%   idx     - indices representing initial approximation of the time-gating 
%             intervals
%   peakIdx - vector of indices representing locations of peak impulse
%             responses over the given angles of rotation
% 
% Copyright (c) 2021, Adrian Bekasiewicz
% All rights reserved.
% 
% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function [idx,peakIdx]=identify_pulse_peak(Rf,N)
K=length(Rf);
Rtmp{K}=[];
peakIdx=zeros(K,1);
for k=1:K
    Rt=ifft(Rf{k},N,'symmetric');
    Rtmp{k}=abs(Rt);
    [~,peakIdx(k)]=max(Rtmp{k});
end
%correction oriented for removing outliers
maxVal=median(peakIdx)+2*std(peakIdx);
idx=[min(peakIdx); max(peakIdx(peakIdx<maxVal))];



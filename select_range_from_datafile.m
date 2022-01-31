% Selects a range of frequency points around the specified f0 and defined
% by the bandwidth.
% 
% Inputs:
%   f0      - center frequency of interest
%   BW      - bandwidth around the center frequency 
%   data    - structure with measurement data
% 
% Outputs:
%   Rm      - measured responses (transmission)
%   Wm      - frequency sweep
%   anglem  - angles for which measurements have been performed
% 
% Copyright (c) 2021, Adrian Bekasiewicz
% All rights reserved.
% 
% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function [Rm,Wm,anglem]=select_range_from_datafile(f0,BW,data)
omegam=data.omegam; 
S21mc=data.S21mc; 
anglem=data.anglem;

omegam=omegam*1e9;
fL=f0-BW;
fH=f0+BW;
[~,idxL]=min(abs(omegam-fL));
[~,idxH]=min(abs(omegam-fH));
N=length(S21mc);
Rm=zeros(idxH-idxL+1,N);
for k=1:N
    Rm(:,k)=S21mc{k}(idxL:idxH);
end
Rm=num2cell(Rm,1);
Wm=omegam(idxL:idxH);
if max(anglem)>180
    anglem=anglem-180;
end
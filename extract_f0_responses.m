% A function that extracts transmission responses between the reference
% antenna and AUT for a given center frequency f0 and performs conversion
% of the data according to the requirements.
% 
% Inputs:
%   f0      - center frequency of interest
%   omega   - frequency sweep of the data
%   Rin     - transmission between the reference antenna ant AUT over omega
%   mode    - conversion from omplex to dB
%   mode2   - normalization of the responses in dB
% 
% Outputs:
%   Rout    - transmission between the reference antenna and AUT at f0
% 
% Copyright (c) 2021, Adrian Bekasiewicz
% All rights reserved.
% 
% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function Rout=extract_f0_responses(f0,omega,Rin,mode,mode2)

% check the number of inputs
if nargin<5
    mode2=[];
    if nargin<4
        mode=[];
    end
end
% convert cell to matrix
if iscell(Rin)
    Rin=[Rin{:}];
end
% identify a frequency point that is closest to f0
[~,idx]=min(abs(f0-omega));
Rout=Rin(idx,:);
% perform additional operations
if strcmp(mode2,'complex')
    Rout=20*log10(abs(Rout));
end
if strcmp(mode,'norm')
    Rout=Rout-max(Rout);
end
if size(Rout,1)<size(Rout,2)
    Rout=transpose(Rout);
end

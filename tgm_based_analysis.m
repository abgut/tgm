% Analysis of the non-anechoic measurements using time-gating method. The
% function operates in two modes:
% - calibration - performs extraction of the time gating intervals
% - evaluation  - performs correction of the non-anechoic responses based
%                 on the intervals extracted in the course of calibration
% The function provides capability to plot the corrected/uncorrected and
% the reference responses.
%
% Inputs:
%   data    - non-anechoic measurements for correction
%   refData - reference data for calibration (calibration mode) or
%             comparison of responses (evaluation mode)
%   bw      - bandwidth around the center frequency
%   f00     - vector with center frequencies of interest
%   xCal    - calibration data (empty in calibration mode)
%   mode    - function operation mode
%
% Outputs:
%   xArch   - optimized gating window intervals obtained for each center
%             frequency of interest
%   eArch   - calculated errors for the given frequencies of interest
%
% Copyright (c) 2021, Adrian Bekasiewicz
% All rights reserved.
% 
% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function [xArch, eArch] = tgm_based_analysis(data,refData,bw,f00,xCal,mode)
% initialization function
count=1; xArch=zeros(2,length(f00)); eArch=zeros(length(f00),1);
wRef=refData.wRef; ffRef=refData.ffRef; fN=length(f00);
figN=findobj('type','figure'); if isempty(figN), figN=1; end;
% loop over center frequencies
for f0=f00
    % select frequency range of interest around f0
    [ffMeas,wMeas,angMeas]=select_range_from_datafile(f0,bw/2,data);
    % select radiation pattern (reference and uncorrected) for the given f0
    ffRefSel=extract_f0_responses(f0,wRef,ffRef,'norm');
    ffUnc=extract_f0_responses(f0,wMeas,ffMeas,'norm','complex');
    % select operation mode
    if strcmp(mode,'calibration')
        [x1,dt]=optimize_tgm_window(f0,wMeas,ffRefSel,ffMeas);
        xArch(:,count)=x1;
    elseif strcmp(mode,'evaluation')
        dt=calculate_time_sweep_and_npts(wMeas);
        x1=xCal;
    else
        error('Mode unsupported...')
    end
    % execute time gating for the given
    ffCorAll=time_gating(ffMeas,wMeas,x1(2)*dt,x1(1)*dt,[]);
    ffCor=extract_f0_responses(f0,wMeas,ffCorAll,'norm','complex');
    
    if strcmp(mode,'evaluation')
        % calculate root-square mean error
        E=20*log10(sqrt(sum((10.^(ffCor/20)-10.^(ffRefSel/20)).^2)/length(ffCor))); %RMSE
        eArch(count)=E;
        fprintf('Correction: f0 = %2.1f GHz; RMSE = %2.2f dB\n',f0/1e9,E)
    end
    
    % plot results
    if strcmp(mode,'evaluation')        
        if count==1
            figure(1)
            time_gating(ffMeas{1},wMeas,x1(2)*dt,x1(1)*dt,1);
        end       
        plot_results(ffCor,ffRefSel,ffUnc,angMeas,count,f0,fN,figN)
    end
    count=count+1;
end
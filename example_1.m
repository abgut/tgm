% Example correction of the planar antipodal Vivaldi antenna. The setup is
% as follows. Calibration of the non-anechoic measurements is performed
% w.r.t. EM simulation data obtained for the antenna. Then the extracted
% calibration data is used for correction of the same antenna at different
% frequencies. The resulting responses are compared against measurements
% performed in the anechoic chamber.
% 
% Copyright (c) 2021, Adrian Bekasiewicz
% All rights reserved.
% 
% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function example_1(setup,pth,dataset)  

ffRef=[]; ffAC=[];
% load and prepare EM simulation data
load([pth.EM,filesep,dataset.EM])
refdata.wRef=wSim; refdata.ffRef=[ffRef{:}]';
% perform calibration
data=load_datafile([pth.NA,filesep,dataset.NA]);
xArch = tgm_based_analysis(data,refdata,setup.BW,setup.f00_1,[],'calibration');
% calculate multi-frequency calibration results
xCal=mean(xArch,2);
xCal(1)=floor(xCal(1)); xCal(2)=ceil(xCal(2));
fprintf('Evaluation (vs EM simulations) at the calibration frequencies...\n')
tgm_based_analysis(data,refdata,setup.BW,setup.f00_1,xCal,'evaluation');

% AC measurements data
load([pth.AC,filesep,dataset.AC])
refdata.wRef=omegam*1e9;
refdata.ffRef=[ffAC{:}];

%evaluate data and plot results
fprintf('Evaluation (vs AC measurements) at different frequencies...\n')
[~,eArch] = tgm_based_analysis(data,refdata,setup.BW,setup.f00_2,xCal,'evaluation');
dt=calculate_time_sweep_and_npts([0 setup.BW]);
fprintf('\n----------------- Correction stats -----------------\n')
fprintf('Interval: t1: %2.1f ns; t2: %2.1f ns\n',xCal(1)*dt*1e9,xCal(2)*dt*1e9)
fprintf('Average RMSE: %2.2f\n',mean(eArch))
fprintf('-------------------------------------------------------\n')
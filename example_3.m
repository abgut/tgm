% Example implements calibration of the monopole antenna (antenna 1) and
% re-use of the obtained data for correction of the responses of another
% antenna (antenna 2) featuring similar dimensions. The calibration results
% are compared against anechoic chamber measurements of antenna 1, whereas
% corrected responses of the antenna 2 are compared against EM simulation
% results.
% 
% Copyright (c) 2021, Adrian Bekasiewicz
% All rights reserved.
% 
% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function example_3(setup,pth,dataset)

ffAC=[]; ffSim=[];
% AC measurements data
load([pth.AC,filesep,dataset.AC])
refdata.wRef=omegam*1e9; refdata.ffRef=[ffAC{:}];
% perform calibration for a compact monopole
fprintf('Calibration using antenna 1...\n')
data=load_datafile([pth.NA,filesep,dataset.NA]);
xArch=tgm_based_analysis(data,refdata,setup.BW,setup.f00_1,[],'calibration');
% calculate multi-frequency calibration results
xCal=mean(xArch,2);
xCal(1)=floor(xCal(1)); xCal(2)=ceil(xCal(2));
% evaluate calibration results
[~,eArch]=tgm_based_analysis(data,refdata,setup.BW,setup.f00_1,xCal,'evaluation');
dt=calculate_time_sweep_and_npts([0 setup.BW]);
% print stats
fprintf('\n----------- Calibration stats (antenna 1) -----------\n')
fprintf('Interval: t1: %2.1f ns; t2: %2.1f ns\n',xCal(1)*dt*1e9,xCal(2)*dt*1e9)
fprintf('Average RMSE: %2.2f\n',mean(eArch))
fprintf('-------------------------------------------------------\n')

% perform correction of another small antenna
fprintf('Correction of antenna 2 based on antenna 1 calibration data...\n')
load([pth.EM,filesep,dataset.EM])
refdata.wRef=wSim; refdata.ffRef=[ffSim{:}]';
% non-anechoic measurements
data=load_datafile([pth.NA,filesep,dataset.NA2]);
[~,eArch]=tgm_based_analysis(data,refdata,setup.BW,setup.f00_2,xCal,'evaluation');

fprintf('\n----------- Correction stats (antenna 2) ------------\n')
fprintf('Interval: t1: %2.1f ns; t2: %2.1f ns\n',xCal(1)*dt*1e9,xCal(2)*dt*1e9)
fprintf('Average RMSE: %2.2f\n',mean(eArch))
fprintf('-------------------------------------------------------\n')

% Calibration of the monopole antenna w.r.t. EM simulation data and re-use
% of the obtained calibration information for correction of the
% non-anechoic responses at other frequencies of interest. The results are
% also compared against EM simulation data.
% 
% Copyright (c) 2021, Adrian Bekasiewicz
% All rights reserved.
% 
% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function example_2(setup,pth,dataset)
ffSim=[];
% EM simulation data
load([pth.EM,filesep,dataset.EM])
refdata.wRef=wSim; refdata.ffRef=[ffSim{:}]';
% perform calibration w.r.t. EM simulation data
data=load_datafile([pth.NA,filesep,dataset.NA]);
xArch = tgm_based_analysis(data,refdata,setup.BW,setup.f00_1,[],'calibration');
% calculate multi-frequency calibration results
xCal=mean(xArch,2);
xCal(1)=floor(xCal(1)); xCal(2)=ceil(xCal(2));
% evaluate results for calibration frequencies
fprintf('Evaluation (vs EM simulations) at the calibration frequencies...\n')
[~,eArch]=tgm_based_analysis(data,refdata,setup.BW,setup.f00_1,xCal,'evaluation');
dt=calculate_time_sweep_and_npts([0 setup.BW]);
fprintf('\n------------- Correction stats (1st set) ------------\n')
fprintf('Interval: t1: %2.1f ns; t2: %2.1f ns\n',xCal(1)*dt*1e9,xCal(2)*dt*1e9)
fprintf('Average RMSE: %2.2f\n',mean(eArch))
fprintf('-------------------------------------------------------\n')
% evaluate results for different set of frequencies
fprintf('Evaluation (vs EM simulations) at other frequencies...\n')
[~,eArch]=tgm_based_analysis(data,refdata,setup.BW,setup.f00_2,xCal,'evaluation');
fprintf('\n------------- Correction stats (2nd set) ------------\n')
fprintf('Interval: t1: %2.1f ns; t2: %2.1f ns\n',xCal(1)*dt*1e9,xCal(2)*dt*1e9)
fprintf('Average RMSE: %2.2f\n',mean(eArch))
fprintf('-------------------------------------------------------\n')
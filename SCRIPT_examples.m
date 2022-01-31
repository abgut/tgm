% Numerical examples for the time-gating method with automated interval
% calibration algorithm. Three examples are considered here:
% 1. Calibration of a Vivaldi antenna against EM simulation results at
%    two selected frequencies followed by re-use of the obtained
%    calibration data for correction of the non-anechoic measurements at
%    different frequencies. The obtained resuls are validated against
%    measurements from the anechoic chamber.
% 2. Calibration of a compact monopole antenna w.r.t. EM simulations and
%    re-use of the obtained calibration data for correction of non-anechoic
%    measurements at different set of frequencies. The obtained results are
%    compared with EM simulation data.
% 3. Calibration of the compact monopole antenna (referred to as antenna 1)
%    w.r.t. measurements performed in anechoic chamber and re-use of the
%    obtained calibration data for correction of the non-anechoic
%    measurements of another radiator (antenna 2) of similar size at
%    different operating frequencies. The results obtained for the antenna
%    2 are compared with EM simulation data.
% 
% Copyright (c) 2021, Adrian Bekasiewicz
% All rights reserved.
% 
% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

clear variables
close all
clc

%select example 
example = 3;
%data paths
pth.AC='measurements_AC';
pth.NA='measurements_nAC';
pth.EM='simulations_EM';
switch example
    case 1
        % setup bandwidth and frequencies of interest
        setup.f00_1=[3 8]*1e9; % calibration
        setup.f00_2=[4 5]*1e9; % evaluation
        setup.BW=1e9;
        % set datasets names
        dataset.EM='vivaldi_copol_2GHz_12GHz_phi_90.mat';
        dataset.NA='vivaldi_nAC_copol_phi90.mat';
        dataset.AC='vivaldi_AC_copol_phi90.mat';
        % execute example
        example_1(setup,pth,dataset)
    case 2
        % setup bandwidth and frequencies of interest
        setup.f00_1=[3 5]*1e9;
        setup.f00_2=[6 7 9 10]*1e9;
        setup.BW=3e9;
        % set dataset names
        dataset.EM='mono_copol_3GHz_10GHz_phi_0.mat';
        dataset.NA='monopole_nAC_copol_phi0.mat';
        % execute example
        example_2(setup,pth,dataset)
    case 3
        % setup bandwidth and frequencies of interest
        setup.f00_1=[4 5 7]*1e9;
        setup.f00_2=[3 12]*1e9;
        setup.BW=3e9;
        % specify dataset names
        dataset.EM='suwb_copol_3GHz_12GHz_phi_0.mat';
        dataset.NA='monopole_nAC_copol_phi0.mat';
        dataset.NA2='suwb_nAC_copol_phi0.mat';
        dataset.AC='monopole_AC_copol_phi0.mat';
        % execute example
        example_3(setup,pth,dataset)
    otherwise
        error('Select examples from the range of 1 to 3...')
end

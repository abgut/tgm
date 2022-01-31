% A function that optimizes size of the time-gating window (TGM) based on
% impulse responses in time domain obtained for a range of angles of
% rotation of interest.
%
% Inputs:
%   f0      - frequency of interest (center frequency)
%   omegam  - frequency sweep around f0
%   Rref    - reference radiation pattern
%   Runc    - measured response obtained in non-anechoic conditions
%
% Outputs:
%   x1      - indices referring to the beginning and end of the TGM window
%   dt      - time-domain step
%
% Copyright (c) 2021, Adrian Bekasiewicz
% All rights reserved.
% 
% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function [x1,dt]=optimize_tgm_window(f0,omegam,Rref,Runc)

c=3e8; % speed of light
range=5; % range around the candidate indice

% extract time-domain step, sweep, and number of points
[dt,tsweep,N]=calculate_time_sweep_and_npts(omegam);
% identify response peak in time domain and calculate distance
peak=identify_pulse_peak(Runc,N); dist=tsweep(peak)*c;
% calculate indices of the gate interval
tlos=min(dist)/c; tnlos=max(dist)/c;
idx1=round(tlos/dt); idx2=round(tnlos/dt);
% enforce minimum distance of at least one sample
if idx1==idx2 && idx1>0
    idx1=idx2-1;
end
% define bounds for optimization of the indices
lb0=[0 idx2]; ub0=[idx1 2*idx2];

% setup algorithm and perform optimization
lb=lb0; ub=ub0; Eold=1e9;
while 1
    % define ranges of indices around currently best estimates
    x1=round(linspace(ub(1)-range+1,ub(1),range));
    x2=round(linspace(lb(2),lb(2)+range-1,range));
    x1=unique(x1); x2=unique(x2);
    x1=x1(x1<=ub0(1)); x1=x1(x1>=lb0(1));
    x2=x2(x2>=lb0(2)); x2=x2(x2<=ub0(2));
    % terminate algorithm if one of the vectors is empty
    if isempty(x1) || isempty(x2)
        break;
    end
    % define combination of intervals
    [X,Y]=meshgrid(x1,x2); Xdt=X*dt; Ydt=Y*dt;
    Npts=length(X(:)); E=zeros(Npts,1); stdx=E;
    %compare responses for all test cases Xdt Ydt
    for k=1:Npts
        Rfcell=time_gating(Runc,omegam,Ydt(k),Xdt(k),[]);
        Rf=extract_f0_responses(f0,omegam,Rfcell,'norm','complex');
        % revert responses from dB
        Rref1=10.^(Rref/20);
        Rf1=10.^(Rf/20);
        % calculate error
        E(k)=norm(Rf1-Rref1);
    end
    % determine the best response ans its corresponding indices
    [Emin,idx]=min(E);
    % select the best candidate intervals
    x=[X(idx) Y(idx)];
    %adjust lb ub if the design hits extremum defined by the range
    flag=0;
    if x(1)==min(x1)
        lb(1)=x(1)-floor(range/2); ub(1)=x(1)+floor(range/2);
        flag=1;
    end
    if x(2)==max(x2)
        lb(2)=x(2)-floor(range/2); ub(2)=x(2)+floor(range/2);
        flag=1;
    end
    % enforce termination when lower/upper bound is hit
    if x(1)==lb0(1) || x(2)==ub0(2)
        flag=0;
    end
    % termination condition
    if round(Emin)>=round(Eold) || flag==0
        x1=[X(idx),Y(idx)];
        dist=dt*c*x1;
        ti=x1*dt*1e9;
        % sr    - spatial resolution which increases with bandwidth
        % ti    - gating interval in ns
        % dist  - distance from reference antenna for which time gating window is active
        fprintf('Calibration: f0 = %2.1f GHz; sr=%2.2fm; ti=[%2.2f %2.2f] ns, d=[%2.2f %2.2f]m\n',f0/1e9,dt*c,ti,dist)
        break;
    else
        Eold=Emin;
    end
end
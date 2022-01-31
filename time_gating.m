% The core time-gating method algorithm. The implementation of the method
% is based on the following paper:
% 
% S. Loredo, M.R. Pino, F. Las-Heras, and T.K. Sarkar, “Echo identification 
% and cancellation techniques for antenna measurement in non-anechoic test 
% sites,” IEEE Ant. Prop. Mag., vol. 46, no. 1, pp. 100-107, 2004.
% 
% Inputs:
%   ffUnc   - uncorrected non-anechoic measurement data
%   omegam  - frequency sweep for the non-anechoic measurements
%   t2      - end of the time gate interval
%   t1      - beginning of the time gate interval
%   plt     - plot time gatting steps (optional)
% 
% Outputs:
%   ffCor   - corrected radiation pattern obtained for a range of angles
% 
% Adrian Bekasiewicz, 2021

function ffCor=time_gating(ffUnc,omegam,t2,t1,plt)

%check number of inputs
if nargin==4
    plt=[];
end
% extract time-domain step, sweep, and number of points
[~,tsweep,N,K]=calculate_time_sweep_and_npts(omegam);
% prepare data for conversion
if ~iscell(ffUnc)
    ffUnc={ffUnc};
end
% setup correction algorihtm
N1=length(ffUnc); ffCor{N1}=[];
%evaluate over N1 angles
for k=1:N1
    % kth angle transmission response
    Rf=ffUnc{k};
    % apply Hann window on a frequency-domain sweep
    fHann=hann_window(K);
    RfHann=Rf.*transpose(fHann);
    % convert frequency data to time domain 
    RtHann=ifft(RfHann,N,'symmetric');
    % apply Hann window on a time-domain sweep over [t1 t2] interval
    [~,idx1]=min(abs(tsweep-t1)); [~,idx2]=min(abs(tsweep-t2));
    tHann=hann_window(idx2-idx1+1);
    tHannRange=zeros(size(RtHann)); tHannRange(idx1:idx2)=tHann;
    RtHann2=RtHann.*tHannRange;
    % convert back to frequency domain
    RfHann2=fft(RtHann2,N);
    ffCor{k}=RfHann2(1:K);
end
if N1==1
    ffCor=ffCor{1};
end
%plot results
if ~isempty(plt)
   plot_tgm_steps(omegam,Rf,RfHann,ffCor,t1,t2,RtHann,tHannRange,RtHann2) 
end
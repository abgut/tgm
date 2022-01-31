% A function that plots steps of the time-gating method for a selected
% angle of rotation.
% 
% (c) Adrian Bekasiewicz, 2021

function plot_tgm_steps(omegam,Rf,RfHann,ffCor,t1,t2,RtHann,tHannRange,RtHann2)

[~,tsweep,N,K]=calculate_time_sweep_and_npts(omegam);

tswp=tsweep*1e9;
wswp=omegam/1e9;
t1=t1*1e9;
t2=t2*1e9;
Rt=ifft(Rf,N,'symmetric');

subplot(2,2,1)
plot(tswp,(Rt)/abs(max(Rt))); grid on
axis([0 2*t2 -1 1])
xlabel('Time [ns]')
ylabel('|h(t)|/max(|h(t)|)')

subplot(2,2,2)
plot(wswp,20*log10(abs(Rf))); hold on; grid on
plot(wswp,20*log10(abs(RfHann)),'r'); hold off
axis([min(wswp) max(wswp) -Inf Inf])
xlabel('Frequency [GHz]')
ylabel('|S_{21}| [dB]')
legend('Original','Windowed','location','south')

subplot(2,2,3)
plot(tswp,RtHann); hold on
plot(tswp,tHannRange,'r');
maxStp=max(abs(RtHann));
plot([-t2 -t2],[-maxStp maxStp],'g')
plot([t2 t2],[-maxStp maxStp],'g');
plot(tswp,RtHann2,'r'); hold off; grid on
axis([t1/2 2*t2 -max(abs(RtHann)) max(abs(RtHann))])
xlabel('Time [ns]')
ylabel('|h(t)|')
legend('Original','Windowed')

subplot(2,2,4)
plot(wswp,20*log10(abs(Rf))); hold on
plot(wswp,20*log10(abs(ffCor)),'r'); grid on; hold off
axis([min(wswp) max(wswp) -Inf Inf])
xlabel('Frequency [GHz]')
ylabel('|S_{21}| [dB]')
legend('Original','Windowed','location','south')
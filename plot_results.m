% Plots the results of time-gating method and compares the obtained
% corrected responses with reference and uncorrected data.
% 
% (c) Adrian Bekasiewicz, 2021 

function plot_results(ffCor,ffRef,ffUnc,angMeas,count,f0,fN,figN)

%open new window
figure(figN(1)+1)
% subplot size
rN=round(sqrt(fN));
cN=ceil(sqrt(fN));
if rN*cN<fN
    rN=rN+1;
end
% rotate angles for better visualization
ffRefSel=shift_angle(angMeas,ffRef,180);
ffCor=shift_angle(angMeas,ffCor,180);
ffUncor=shift_angle(angMeas,ffUnc,180);
% plot results
subplot(rN,cN,count)
plot(angMeas,ffCor,'color','k'); grid on; hold on
plot(angMeas,ffRefSel,'color','g');
plot(angMeas,ffUncor,'k:'); hold off
axis([-180 180 -Inf Inf])
xlabel('Angle [{^o}]')
ylabel(['Radiation pattern [dB]'])
title(['@f_0=',num2str(f0/1e9),' GHz'])
legend('Corrected','Reference','Uncorrected','location','south')
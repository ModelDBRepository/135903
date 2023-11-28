function figureanal(filename);
% this file is called by inputting the last 10 characters of the filename
% prior to ".dat"  For example, if you do a simulation with   driverthr=85
% and pyrthr=92, with a defined gapstyle of 15, this will make files with
% "_b100_p92_g15_f85.dat" in their names.  The basket cells were always
% 100, so I ignored them in this file.  I would call this function by
% typing

%figureanal('85_g15_f55')

%in the Matlab prompt.  It will produce the figure and data from Fig. 3




% 56000 long for 1.4 sec.  the sampling rate is 0.025 ms, so
%  4000/.1 sec.  
%  This file has 200 ms of no noise, then 200 ms of noise to driver-only, then 600
% both, then 400 neighbor-only.  So 16000, 24000, 16000 points

% so 24001 for 600 start, 48001 for 12000 end
%the Neighbor cells are called "passive" in this file

start_of_both=24001;  %for 600 ms
end_of_both=48000;   % for 1200 ms

driverearly=8001 + 1000;
driverlate=24000;
bothearly=24001 + 1000;
bothlate=48000;
passiveearly=48001 + 1000;
passivelate=64000;
noiselineplace=0;

sum1=load(['sum_b100_p' filename '.dat']);
spike1=load(['spikes_b100_p' filename '.dat']);
sumdrive=load(['sumdrive_b100_p' filename '.dat']);
sumpas=load(['sumpas_b100_p' filename '.dat']);
figure
subplot(2,2,1)
%plot(sum1(:,1), sum1(:,2), 'k')
title(filename)
driver=sum1(driverearly:driverlate,2);
driver_driveralone=sumdrive(driverearly:driverlate,2);
if (max(driver)<-55) 
    driver(:)=max(driver);
end
both=sum1(bothearly:bothlate,2); % could go until 40000
both_driveralone=sumdrive(bothearly:bothlate,2);
both_passivealone=sumpas(bothearly:bothlate,2);
passive=sum1(passiveearly:passivelate,2);
passive_passivealone=sumpas(passiveearly:passivelate,2);
hold on

%plot(sum1(driverearly:driverlate,1),driver,'k');
%plot(sum1(1:40000,1),sumdrive(1:40000,2)+30, 'g')

plot(sumdrive(:,1),sumdrive(:,2)+10, 'b')
%plot(sumdrive(start_of_both:end_of_both,1),sumdrive(start_of_both:end_of_both,2)+10,'g')


plot(sumpas(:,1),sumpas(:,2)-40, 'k')
%plot(sumpas(start_of_both:end_of_both,1),sumpas(start_of_both:end_of_both,2)-40,'r')

line([600 1200],[-70 -70],'Color','g','LineStyle','-')
line([600 1200],[-120 -120],'Color','r','LineStyle','-')
line([1200 1600],[-120 -120],'Color','k','LineStyle','-')


tricolorspikeraster(spike1)
axis([150 1350 -120 120])
axis off
hold off
botht=detrend(both);  %mixed file when both are one
botht_driveralone=detrend(both_driveralone);  % sumdrive file when both on
botht_passivealone=detrend(both_passivealone);  %sumpas file when both on
drivert=detrend(driver);   % sum file just driver
drivert_driveralone=detrend(driver_driveralone);  % sumdrive just driver
passivet=detrend(passive);   %sum file just passive
passivet_passivealone=detrend(passive_passivealone);  %sumpas just passive

[bp,bf]=pwelch(botht,10000,9000,40000,40000);
[b_pp,b_pf]=pwelch(botht_passivealone,10000,9000,40000,40000);
[b_dp,b_df]=pwelch(botht_driveralone,10000,9000,40000,40000);
[dp,df]=pwelch(drivert,10000,9000,40000,40000);
[d_dp,d_df]=pwelch(drivert_driveralone,10000,9000,40000,40000);
[pp,pf]=pwelch(passivet,10000,9000,40000,40000);
[p_pp,p_pf]=pwelch(passivet_passivealone,10000,9000,40000,40000);
subplot(2,3,4)
semilogy(bf,bp, 'b')
hold on
semilogy(d_df, d_dp, 'g')
hold off
axis([0 200 0 50])
title('Driver')
subplot(2,3,5)
%semilogy(bf,bp, 'b')

%semilogy(pf, pp,'r-')
%semilogy(df,dp, 'k')
semilogy(b_pf,b_pp,  'r', 'LineWidth', 2)
hold on
semilogy(b_df,b_dp, 'g')
semilogy(p_pf, p_pp, 'k')
hold off
axis([0 200 0 50])
title('Combined')
subplot(2,3,6)
semilogy(bf,bp, 'b')
hold on
semilogy(p_pf, p_pp, 'r')
hold off
axis([0 200 0 50])
title('Neighbors')

%now find the f that is closest to input freq
% for 30000,29000,30000,40000 f(16) is 20 Hz f(13) is 16 hz
[maxval,maxindex]=max(b_dp);  %picks the maximum freq in the drivers only when both are on
[maxpas,maxpasindex]=max(p_pp);
[maxpaswithdriver,maxpaswithdriverindex]=max(b_pp);

%[r,lags]=xcorr(botht_passivealone,botht_driveralone,'coeff');  %gives same
%answer if already detrended
[c,lags]=xcov(botht_passivealone,botht_driveralone,'coeff');  
[clone,lagslone]=xcov(passivet_passivealone,drivert_driveralone,'coeff');  
[maxcov, maxcovindex]=max(c);
[maxcov lags(maxcovindex) max(clone)]
subplot(2,2,2)
plot(lags,c,'g')
hold on
plot(lagslone,clone +2, 'r')

hold off
%signalfreqindex=maxindex
%mean([b_pp(maxindex-25:maxindex-15)' b_pp(maxindex+15:maxindex+25)'])
%b_pp(25:100)
snr=b_pp(maxindex)/mean([b_pp(maxindex-25:maxindex-15)' b_pp(maxindex+15:maxindex+25)']);
snrreal=b_pp(maxindex)/mean(p_pp(maxindex-3:maxindex+3));  %this would give the power at driving frequency when both are on / power there when Drivers are NOT on
snrdrive=b_dp(maxindex)/mean([b_dp(maxindex-25:maxindex-15)' b_dp(maxindex+15:maxindex+25)']);
freq=b_pf(maxindex);
if(maxpasindex>25)
    snrpas=p_pp(maxpasindex)/mean([p_pp(maxpasindex-25:maxpasindex-15)' p_pp(maxpasindex+15:maxpasindex+25)']);
else
    snrpas=p_pp(maxpasindex)/mean(p_pp(maxpasindex+15:maxpasindex+25));
end
pasfreq=p_pf(maxpasindex);
%snrvector(i)=snr;

%for j=1:3
    %if ((maxindex-6+j)>0)
       % baseline(j)=p(maxindex-6+j);
    %end
    %baseline(7-j)=p(maxindex+j+2);
%end  used this until 7/29/08


SNR=num2str(snr);
DRIVE=num2str(snrdrive);
FREQ=num2str(freq);
RATIO=num2str(snr/snrdrive);
PASFREQ=num2str(pasfreq);  %The freq with neighbor alone
SNRPAS=num2str(snrpas);
PEAKPASFREQ=num2str(b_pf(maxpaswithdriverindex));  %the peak frequency Neighbor f during both
subplot(2,3,5)
signallabel=strcat('SNR','-',SNR);
drivelabel=strcat('DRIVE', '-', DRIVE);
freqlabel=strcat('FREQ', '-', FREQ);
ratiolabel=strcat('RATIO', '-', RATIO);
pasfreqlabel=strcat('PAS FREQ', '-', PASFREQ);
snrpaslabel=strcat('PAS SNR', '-', SNRPAS);
peakpaslabel=strcat('Peak freq pas', '-', PEAKPASFREQ);
legend(signallabel, freqlabel, ratiolabel,  'location','southwest');
subplot(2,3,6)
legend(pasfreqlabel, snrpaslabel, 'location','southwest');
subplot(2,3,4)
legend(peakpaslabel,drivelabel, 'location','southwest');
hold off
%[filename ' driver' DRIVE ' neighbor' SNR]
end
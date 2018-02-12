% this code is a part of the developmant of my final
% project in the filed of audio signal processing
% its use is going to be as an onset detection function
% to estimate whan the player begins to play a note
% the code analyze a few seconds and plots the resolts


clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%variables
fs=44100;
w=1024;
hop=128;
%numseg=1000;
%time_inter=zeros(1,round(N/hop-hop));
timer_val=0;
seconds=6;
ft1=zeros(w);
ft2=zeros(w);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%audio device init


deviceReader = audioDeviceReader();
devices = getAudioDevices(deviceReader)
%%%init for zoom recorder
%deviceReader = audioDeviceReader('Device',devices{3},'SamplesPerFrame',hop, 'SampleRate',fs );
%%%init for default device
deviceReader = audioDeviceReader('SamplesPerFrame',hop, 'SampleRate',fs)
setup(deviceReader);
%devices = getAudioDevices(deviceReader);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%filter
fcL =500;
freq = [0 0.5*(fcL/fs) fcL/fs 1];
m = [0 0.1 1 1];
b1 = fir2(10,freq,m);

win=hann(w)';
% win = window(@nuttallwin,w)';
% win=1;
%%%variables
threshold=4;
i=0;
sound=zeros(1,fs*seconds);
overrun=zeros(1,round((seconds*fs)/hop));
passed_signal=zeros(w); 
sf=zeros(1,round((seconds*fs)/hop));
current_signal=zeros(w);
%sound=zeros(seconds*44100);
tic
while toc < seconds
    dr=deviceReader();
    current_signal = [passed_signal(hop+1:w) dr'];
   
    sound((1+hop*i):hop*i+(hop))=dr;
    %current_signal = [passed_signal(hop+1:w) deviceReader()'];
%      ft1 = abs( fft( filter(b1,1,passed_signal).*win  )) ;
%       need to fix the convolution with the filter
%     ft2 = abs( fft( filter(b1,1,current_signal).*win  )) ;
    
    ft1 = abs( fft( passed_signal.*win  )) ;
    ft2 = abs( fft( current_signal.*win  )) ;
    Max1= max(ft1(1:512));
    Max2= max(ft2(1:512));
    if(Max1 > threshold)||(Max2 > threshold)
        ft1=ft1./Max1;  %normalizing the function to eliminate amplitude effects
        ft2=ft2./Max2;  %normalizing the function to eliminate amplitude effects
    end
    sf(i+1) = (sum( ft2(1:512)-ft1(1:512) ));
     %sf(i) = sum( ft2(1:round(w/2)) - ft1(1:round(w/2)) );
    passed_signal= current_signal;
    i=i+1;
    %time_inter(i+1)= toc(timer_val);
end
% smoo=sf;
% 
d=[sf(1) zeros(1,hop-1)];
for i=1:length(sf)-1
    d=[d,[sf(i+1),zeros(1,hop-1)]];
end
    d=[d,zeros(1,hop-1)];
figure
subplot(2,1,1)       % add first plot in 2 x 1 grid
plot(0:1/fs:seconds-1/fs,sound)
xlabel("time[sec]")
ylabel("amplitude")
title('audio signal')

subplot(2,1,2)       % add second plot in 2 x 1 grid
                     % plot using + markers

plot(0:1/fs:seconds-1/fs,d(1:length(sound)))

title('spectral flux')
xlabel("time[sec]")
ylabel("spectral flux")

   %player=audioplayer(sound,44100,16,5);
   % player=audioplayer(sound,44100,16);
   %play(player)
release(deviceReader);

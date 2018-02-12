% this code is a part of the developmant of my final
% project in the filed of audio signal processing
% this code is a pitch estimation algorithm
% based upon the tysis of DR phillip maclaod and his 
% spatial normalized auto correlation function (snac) 

%% parameters declaretion
clear all
w=1024;%%buffer size
seconds = 6;%number of seconds to analyze
fs = 44100;

%% Create input and output objects

deviceReader = audioDeviceReader(fs,w)
devices = getAudioDevices(deviceReader)
deviceReader = audioDeviceReader('Device',devices{3})
%support = audiodevinfo(1,1,88200,16,1)

%%
t=0;
i=1;
my = zeros(1,260);
time = zeros(100,1);
%%

tic
while toc<seconds
    dr=deviceReader();
   
    mySignal =dr;
    sound((1+w*i):w*i+w)=mySignal;
   
    my(i)=snac_function(mySignal,w,fs);
   
    i=i+1;
end

%%
subplot(2,1,1)      
plot(0:1/fs:length(sound)/fs-1/fs,sound)
xlabel("time [sec]")
ylabel("amplitude")
title('audio signal')



subplot(2,1,2)     
plot(0:1:length(my)-1,my,'.');

title('frequency estimation')
xlabel("frame number")
xlim([0 length(my)])
ylim([0 400])
ylabel("f [Hz]")
  %player=audioplayer(sound,44100,16,5);%%for zoom recorder
  %player=audioplayer(sound,44100,16); 
  %play(player)
release(deviceReader);










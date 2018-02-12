function y=snac_function(x,buffer_size,fs)
%% function variables
Ts=1/fs;
nline=200;
%% auto correlation type2
acf_type2=acf_via_fft(x,buffer_size);%returns acf and power spectrum
plot(acf_type2)

%% computes the first normalizing factor
m1=0;
for i=1:buffer_size
    m1=m1+(2*x(i)^2);
end
%% snac function
m=[m1 zeros(1,buffer_size-1)];
n=zeros(1,buffer_size-1);
for i=1:buffer_size
    m(i+1)=m(i)-(x(i)^2+x(buffer_size+1-i)^2);
    n(i)=(2*acf_type2(i))/m(i);                 %normalizing evry elemant of the autocorr to get the snac  
end
% plot(n)
%% pick picking
i=5;
flag=0;
while 1&&i<(buffer_size-2)
    
  i=i+1;
    if (n(i+1)>n(i) && n(i+1)>n(i+2) && n(i+1)>0.95)
    
    px = polyfit(Ts*[(i-1) i (i+1) (i+2)],[n(i-1) n(i) n(i+1) n(i+2)],2);
    ex=linspace(i*Ts,i*Ts+Ts*2,nline);
    pval=polyval(px,ex);
    [max_y,xi] = max(pval);
    
    flag=1;
    break;
       
    end
  
end

%% calculating resolt for the window
if flag==0
    y=0;
else
    %Tperiod=Ts*( i-1 );
    Tperiod=Ts*( (i-1) + (xi)*2/nline );
    y=1/Tperiod;
end

end

clc
close all;
clear all;
load('grupo7_2s16.mat');
Fs = 20000;
len = 20;
 
K = 0;
vec=[];
for(K= 0:(length(g7)/len-1))
    fft_signal = abs(fft(g7((K*len+1):(K+1)*len)));
    freq_axis = (0:(len)-1)*Fs/len;
     
    figure(2);
    scatter(freq_axis(1:len/2+1),fft_signal(1:len/2+1));
    pause(1);
    a = fft_signal(fft_signal(1:len/2+1) > 0);
    res = 0;
    for(i=0:(length(a)-1))
        res = res + 2^(length(a)-2-i) *  (a(i+1) > 0.1);
    end
 
    vec(K+1) = char(res);
end
 
 
figure(1)
scatter(freq_axis(1:len/2+1),fft_signal(1:len/2+1));
grid on
s = char(vec)
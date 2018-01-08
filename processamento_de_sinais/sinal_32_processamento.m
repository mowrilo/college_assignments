close all;
clear all;
%Aluno: Marcos Paulo Quintao Fernandes- Matricula: 2013030880
load('Sinal_32.mat')

fs = 1/(t(2)-t(1));

saida(length(x)) = 1;

for i = 1:length(x)/100
    xAux = x(100*(i - 1) + 1:100*i);
    saidaAux = real(fft(xAux));
    [modulo, indice] = max(saidaAux(1:length(saidaAux)/2));
    saida(100*(i - 1) + 1:100*i) = (indice - 1) * fs / 100;
end

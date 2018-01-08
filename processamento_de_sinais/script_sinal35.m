%TP2 - Processamento de Sinais
%Aluno: Murilo Vale Ferreira Menezes - 2013030996

clear all;
load('Sinal_35.mat')

fs = 1/(t(2)-t(1));

tamanho = length(x);
saida(tamanho) = 1;

for i = 1:tamanho/100
    xAux = x(100*(i - 1) + 1:100*i);
    saidaAux = real(fft(xAux));
    [mod, indice] = max(saidaAux(1:length(saidaAux)/2));
    saida(100*(i - 1) + 1:100*i) = (indice - 1) * fs / 100;
end
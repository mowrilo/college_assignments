%	Trabalho Computacional 2 - Sistemas Nebulosos - UFMG - 2017/2
%	Professor Cristiano Leite de Castro
%	Alunos: André Gouthier Bicalho
%               Murilo Vale Ferreira Menezes
%               Renato Reis Brasil

clear
load 'mg';
X = x;
epocas = 20;

%separando os pontos
N = round(0.80*length(X));
Xt = X(1:N);
Xv = X(N+1:end);

input_data = zeros((length(Xt)-24), 5);
for i=1:(length(Xt)-24)
    input_data(i, 1) = Xt(0+i);
    input_data(i, 2) = Xt(6+i);
    input_data(i, 3) = Xt(12+i);
    input_data(i, 4) = Xt(18+i);
    input_data(i, 5) = Xt(24+i);
end

in_fis = genfis1(input_data, 2, 'gbellmf', 'linear');
out_fis = anfis(input_data, in_fis, epocas);

output_data = zeros((length(Xv)-18), 4);
for i=1:(length(Xv)-18)
    output_data(i, 1) = Xv(0+i);
    output_data(i, 2) = Xv(6+i);
    output_data(i, 3) = Xv(12+i);
    output_data(i, 4) = Xv(18+i);
end

previsao1 = evalfis(output_data, out_fis);%preve 6 passos a mais
previsao = previsao1(1:end-6);
real = Xv(25:end);
plot(previsao, 'b');
hold on
plot(real, 'r--');

%Erro quadratico medio
soma = sum((real - previsao).^2);
MSE = soma/(length(real))


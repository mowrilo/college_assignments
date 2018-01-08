%	Trabalho Computacional 2 - Sistemas Nebulosos - UFMG - 2017/2
%	Professor Cristiano Leite de Castro
%	Alunos: André Gouthier Bicalho
%               Murilo Vale Ferreira Menezes
%               Renato Reis Brasil

clc 
clear

x = (0:.1:2*pi)';

fisSug = readfis('senosugeno.fis');
anfisSug = anfis([x sin(x)], fisSug, 30);

sinSug = evalfis(x, anfisSug);

plot(x, sinSug, 'r');
hold on
plot(x, sin(x), 'b--');

%Erro quadratico medio
soma = sum((sin(x) - sinSug).^2);
MSE = soma/(length(sinSug))

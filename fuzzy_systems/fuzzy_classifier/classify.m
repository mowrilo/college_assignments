%	Trabalho Computacional 2 - Sistemas Nebulosos - UFMG - 2017/2
%	Professor Cristiano Leite de Castro
%	Alunos: Murilo Vale Ferreira Menezes
%			Renato Reis Brasil

pkg load statistics
pkg load fuzzy-logic-toolkit

clear all;
close all;
clc

%carrega a entrada
load dataset_2d.mat;

X = x;
Y = y;

N = size(X,1);
n = size(X,2);

acc = [];

%separa em treino e validacao
perm = randperm(N);
nVal = round(.3*N);
pt = perm(nVal+1:N);
pv = perm(1:nVal);

Xt = X(pt,:);
Yt = Y(pt);
Xv = X(pv,:);
Yv = Y(pv);

for nRules=2,

	%encontra os grupos via FCM
    [cent I] = find_groups(Xt,nRules);

    conseq = [];
    dispersions = [];
    weights = [];

	%encontra o consequente de cada regra,
	%as dispersoes das gaussianas e os pesos
    for i = 1:nRules,
        Xtc = Xt(I == i,:);
        dispersions = [dispersions std(Xtc)'];
        
        Ytc = Yt(I == i);
        conseq = [conseq mode(Ytc)];
        weights = [weights size(Ytc(Ytc == mode(Ytc)),1)/size(Ytc,1)];
    end;

    dispersions = dispersions';

    nErro = 0;
    resp = [];

	%avalia para cada padrao de validacao
    for i = 1:size(Xv,1),
        ws = [];

		%encontra os graus de ativacao
        for rule = 1:nRules,
            w = 1;
            for antec = 1:n,
                w = w*gaussmf(Xv(i,antec),[dispersions(rule,antec) cent(rule,antec)]);
            end;
            ws = [ws w];
        end;

        %para c = 0
        vc0 = 0;
        rules = find(conseq == 0);
        ws0 = ws(rules);
        wei0 = weights(rules);
        
        if (size(rules,2) > 0),
            sn = ws0(1)*wei0(1);
            ci = 1;
            for s = ws0(2:end),
                ci = ci+1;
                sn = sn + (s*wei0(ci)) - (sn * s*wei0(ci));
            end;
            vc0 = sn;
        endif;
        
        %para c = 1
        vc1 = 1;
        rules = find(conseq == 1);
        ws1 = ws(rules);
        wei1 = weights(rules);
        
        if (size(rules,2) > 0),
            sn = ws1(1)*wei1(1);
            ci = 1;
            for s = ws1(2:end),
                ci = ci+1;
                sn = sn + (s*wei1(ci)) - (sn * s*wei1(ci));
            end;
            vc1 = sn;
        endif;
        
		%aplica os valores encontrados para classificar
        if (vc0 > vc1),
            clas = 0;
        else
            clas = 1;
        endif;
        
        nErro = nErro + (clas != Yv(i));
        resp = [resp clas];
    end;

    erro = nErro/size(Xv,1);
    acc = [acc 1-erro];

end;

plot(2:8,acc)

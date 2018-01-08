%	Trabalho Computacional 2 - Sistemas Nebulosos - UFMG - 2017/2
%	Professor Cristiano Leite de Castro
%	Alunos: Murilo Vale Ferreira Menezes
%			Renato Reis Brasil

%faz a avaliacao da classe em cada ponto de um grid predefinido para gerar a superficie
[seqx seqy] = meshgrid(-1:.1:1,-.5:.1:1.5);
Z = seqx;

for i = 1:size(seqx,1),
for j = 1:size(seqx,2),
    ws = [];
    for rule = 1:nRules,
        w = gaussmf(seqx(1,i),[dispersions(rule,1) cent(rule,1)]) * ...
        gaussmf(seqy(j,1),[dispersions(rule,2) cent(rule,2)]);
        ws = [ws w];
    end;

    %para c = 0
    rules = find(conseq == 0);
    ws0 = ws(rules);
    vc0 = 0;
    if (size(rules,2) > 0),
        sn = ws0(1);
        for s = ws0(2:end),
            sn = sn + s - (sn * s);
        end;
        vc0 = sn;
    endif;

    %para c = 1
    rules = find(conseq == 1);
    ws1 = ws(rules);
    vc1 = 0;
    if (size(rules,2) > 0),
        sn = ws1(1);
        for s = ws1(2:end),
            sn = sn + s - (sn * s);
        end;
        vc1 = sn;
    endif;
    
    if (vc0 > vc1),
        clas = 0;
    else
        clas = 1;
    endif;
    
    Z(i,j) = clas;
end;
end;

surf(seqx,seqy,Z)
view(100,40)

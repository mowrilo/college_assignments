n = 8;
cap = 35;
mi = 30;
nmax = 2000;
probcross = .7;
probmut = .09;

peso = [10 18 12 14 13 11 8 6];
valor = [5 8 7 6 9 5 4 3];

sol = gerarand(n);
for i = 1:(mi-1)
	sol = vertcat(sol,gerarand(n));
end;

for i=1:mi
  sol(i, (n+1)) = fitness_ksp(sol(i, (1:n)),valor,peso,cap)
end;

sol = sortrows(sol,(n+1))

for i=1:mi
  sol(i, (n+2)) = sol(i, (n+1))/sum(sol(:, (n+1)))
end;

ger = 1;

maxfit = [];
medfit = [];

maxfit(ger) = max(sol(:,(n+1)));
medfit(ger) = mean(sol(:,(n+1)));

while ((maxfit(ger) != 21) && (ger<nmax))
  
  offs1 = zeros(1,(n+2));
	for i=1:(mi/2)
		asd1 = rand();
		asd2 = rand();
		p1 = 1;
		p2 = 1;
		cumula = cumsum(sol(:,(n+2)))
		while(cumula(p1) < asd1)
			p1 = p1 +1;
		end;
		peum(ger) = p1;
		asdes(ger) = asd1;
		while (cumula(p2) < asd2)
			p2 = p2+1;
		end;
		parents(1,:) = sol(p1,1:n);
		parents(2,:) = sol(p2,1:n);
		
		pr = rand();
		
		if (pr <probcross)
			npos = randi(n);
		else
			npos = n;
		end;

		offs(1,1:npos) = parents(1,1:npos);
		offs(1,(npos+1):n) = parents(2,(npos+1):n);
		
		offs(2,1:npos) = parents(2,1:npos);
		offs(2,(npos+1):n) = parents(1,(npos+1):n);
		
		for (i = 1:n)
			asd1 = rand();
			asd2 = rand();
			if (asd1 < probmut)
				offs(1,i) = not(offs(1,i));
			end;
			if (asd2 < probmut)
				offs(2,i) = not(offs(2,i));
			end;
		end;

		offs(:,(n+1):(n+2)) = 0;

		offs1 = vertcat(offs1,offs);
	end;

	offs1 = offs1(2:(mi+1),:);
	sol = offs1;

	for i=1:mi
  		sol(i, (n+1)) = fitness_ksp(sol(i, (1:n)),valor,peso,cap);
	end

	sol = sortrows(sol,(n+1));

	for i=1:mi
  		sol(i, (n+2)) = sol(i, (n+1))/sum(sol(:, (n+1)))
	end;

	ger = ger+1;


	maxfit(ger) = max(sol(:,(n+1)));
	medfit(ger) = mean(sol(:,(n+1)));
end

plot (maxfit, 'b')
hold on
plot (medfit, 'r')
print("grafico.png","-dpng")

N = 100;
Dim = 2;
lims = 2;
limi = -2;
banda = lims - limi;
C = .75;
F = .8;
germax = 100;
fun = @rastrigin; %peaks;

%inicializa
for i = 1:Dim
	sol = rand(Dim,1)*banda + limi;
end;
for i = 1:(N-1)
	bla = rand(Dim,1)*banda + limi;
	sol = horzcat(sol,bla);
end;

ger = 1;


repete = 0;
while (ger < germax && repete < 20)
	for i=1:N
		xablau = randperm(N);
		r = xablau(1:3);
		delta = randperm(Dim)(1);
		for j=1:Dim
			tiburcio = rand();
			if (tiburcio < C || j == delta)
				u(j) = sol(j,r(1)) + F*(sol(j,r(2)) - sol(j,r(3)));
			else
				u(j) = sol(j,i);
			end;
			u = u(:);
		end;
		if (fun(u) < fun(sol(:,i)))
			sol(:,i) = u;
		end;
	end;
	for j=1:N
		fitness(j) = fun(sol(:,j));
	end;
	plotar(fun,[limi limi],[lims lims],ger,sol,fitness);
	%if (min(fitness))
	ger = ger+1;
end;


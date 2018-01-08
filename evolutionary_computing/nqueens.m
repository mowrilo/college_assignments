clear all

mi = 50
n = 10
probmut = .8
geracao = 1
 %gera solucoes iniciais%
sol=randperm(n)
for i=1:(mi-1)
  sol=vertcat(sol,randperm(n))
end

for i=1:mi
  sol(i, (n+1)) = fitness_nq(sol(i, (1:n)))
end

sol = sortrows(sol,(n+1))

minfit(geracao) = min(sol(:,(n+1)))
medfit(geracao) = mean(sol(:,(n+1)))

while ((minfit(geracao) != 0)  && (geracao < 1000))
  pais = [sol(1) sol(2)]
  a1 = sol(pais(1),(1:n))
  a2 = sol(pais(2),(1:n))
  entrada = vertcat(a1,a2)
  filhos = CutAndCrossfill_Crossover(entrada)
  
  for i=1:2
    rando = rand()
    if (rando < probmut)
      pato = randperm(n)(1:2)
      aux = filhos(i,pato(1))
      filhos(i,pato(1)) = filhos(i,pato(2))
      filhos(i,pato(2)) = aux
    endif
  end
  
  filhos(1, (n+1)) = fitness_nq(filhos(1, (1:n)))
  filhos(2, (n+1)) = fitness_nq(filhos(2, (1:n)))
  
  sol=vertcat(sol,filhos)
  sol = sortrows(sol,(n+1))
  sol = sol((1:mi),:)
  
  geracao++
  
  minfit(geracao) = min(sol(:,(n+1)))
  medfit(geracao) = mean(sol(:,(n+1)))  
  
endwhile
  
plot (minfit, 'b')
hold on
plot (medfit, 'r')
print("grafico.png","-dpng")

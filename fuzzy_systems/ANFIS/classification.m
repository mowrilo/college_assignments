%	Trabalho Computacional 2 - Sistemas Nebulosos - UFMG - 2017/2
%	Professor Cristiano Leite de Castro
%	Alunos: André Gouthier Bicalho
%               Murilo Vale Ferreira Menezes
%               Renato Reis Brasil

clear all
clc

load dataset_2d.mat;

% separa os dados de teste para avaliacao posterior

index_test = randperm(size(x,1));

x_train = x;
x_train(index_test(1:30),:) = [];
x_test = x(index_test(1:30),:);
y_train = y;
y_train(index_test(1:30)) = [];
y_test = y(index_test(1:30));

% separa os folds para validacao cruzada

index_cv = randperm(size(x_train,1));
lr_range = 2.^(-10:2);
nrules_range = 2:10;
best_tune = [0 0];
best_acc = 0;

accuracies = []

for lr=lr_range, % lr eh a taxa de aprendizado (learning rate)
  for nr=nrules_range, % nr eh o numero de regras
    this_acc = [];
    train_acc = [];
    for fold=1:10,
      ind = index_cv(fold*7-6:fold*7); % sao definidas 7 amostras em cada fold
      xTrain = x_train;
      xTrain(ind,:) = [];
      yTrain = y_train;
      yTrain(ind) = [];
      xTest = x_train(ind,:);
      yTest = y_train(ind);
      [cent I] = find_groups(xTrain,nr);
      
      f=newfis('f1','FISType','sugeno'); %define o sistema

      f=addvar(f,'input','x1',[-1 2]); %variavel de entrada
      f=addvar(f,'input','x2',[-1 2]); %variavel de entrada
      f=addvar(f,'output','y',[-1 1]); %variavel de saida
      
      consequentes = [];
      
      rules = [];
      for i=1:nr,
        centro = cent(i,:);
        xTrainThis = xTrain(I==i,:);
        std1 = std(xTrainThis(:,1));
        std2 = std(xTrainThis(:,2));
        if (size(xTrainThis,1) == 1),
          std1 = .01;
          std2 = .01;
        end;
        f=addmf(f,'input',1,strcat('a',int2str(i)),'gaussmf',[std1,centro(:,1)]);
        f=addmf(f,'input',2,strcat('b',int2str(i)),'gaussmf',[std2,centro(:,2)]);
        consequentes = [consequentes mode(yTrain(I==i,:))];
      end;
    
      for i=1:nr,
        f=addmf(f,'output',1,strcat('o',int2str(i)),'linear',[0 0 consequentes(i)]);
        f=addrule(f,[i i i 1 1]);
      end;

      f=anfis([xTrain yTrain],f, [100 0.1 lr 0 0]); % 100 epocas
      pred=evalfis(xTest,f);
      pred = (pred > .5);
      acc = sum(pred==yTest)/length(pred); % acuracia de validacao
      this_acc = [this_acc acc];

      pred_train=evalfis(xTrain,f);
      pred_train=(pred_train > .5);
      acc_train=sum(pred_train==yTrain)/length(pred_train); % acuracia de treino
      train_acc = [train_acc acc_train];
    end;
    accuracies = [accuracies' [lr nr mean(this_acc) mean(train_acc)]']'
    if (mean(this_acc) > best_acc), % atualiza os melhores parametros
        best_acc = mean(this_acc);
        best_tune = [lr nr];
    end;
  end;
end;

csvwrite("accuracies.csv",accuracies);

lr = best_tune(1);
nr = best_tune(2);

[cent I] = find_groups(x_train,nr);
      
f=newfis('f1','FISType','sugeno'); %define o sistema

f=addvar(f,'input','x1',[-1 2]); %variavel de entrada
f=addvar(f,'input','x2',[-1 2]); %variavel de entrada
f=addvar(f,'output','y',[0 1]); %variavel de saida
      
consequentes = []
      
% constroi o sistema para o teste
for i=1:nr,
  centro = cent(i,:);
  xTrainThis = x_train(I==i,:);
  f=addmf(f,'input',1,strcat('a',int2str(i)),'gaussmf',[std(xTrainThis(:,1)),centro(:,1)]);
  f=addmf(f,'input',2,strcat('b',int2str(i)),'gaussmf',[std(xTrainThis(:,2)),centro(:,2)]);
  consequentes = [consequentes mode(y_train(I==i,:))];
end;
    
for i=1:nr,
  f=addmf(f,'output',1,strcat('o',int2str(i)),'linear',[0 0 consequentes(i)]);
  f=addrule(f,[i i i 1 1]);
end;

% treina e avalia no conjunto ateriormente separado

f=anfis([x_train y_train],f,[100 0.1 lr 0 0]);
pred=evalfis(x_test,f);
pred=(pred > .5);
acc = sum(pred==y_test)/length(pred);


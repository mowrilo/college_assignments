% Codigo do algoritmo Fuzzy C-Means - Sistemas Nebulosos UFMG 2017/2
% Murilo Vale Ferreira Menezes - 2013030996
% Renato Reis Brasil- 2013031127

clear all;
close all;
clc

% carregando e plotando os dados
load fcm_dataset.mat;
X = x;
    
figure(1);
hold on;
plot(X(:,1), X(:,2),'b.');
grid on;

%% ---------------------------------------
% Algoritmo fuzzy c-means

% Define o numero de grupos
    C = 4;

    % Define o expoente
    m = 2;


    n = size(X, 1); % n�mero de observacoes
    r = size(X, 2); % numero de dimensoes


    % Definindo graus de pertencimento aleatoriamente
    U = rand(n, C, 1);

    % Normalizacao de U
    sumU = sum(U, 2);
    U = bsxfun(@rdivide, U, sumU);


    iter = 1;
    changes = true;
    while (changes),
            
        % Computando os centroides
        centroids = zeros(C, r);
        for j = 1:C,
            Upeso = U(:, j) .^ m;
            dX = bsxfun(@times, X, Upeso);
            centroids(j, :) = sum(dX)/sum(Upeso);     
        end
        
        % Plotando os centroides
        xdata = centroids(:,1);
        ydata = centroids(:,2);
        pause(1)
        h = plot(xdata, ydata, 'ko', 'LineWidth', 2, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize', 10);
        set(h,'YDataSource','ydata')
        set(h,'XDataSource','xdata')
        refreshdata
        
        % Calculo da funcao objetivo J
        distance = zeros(n,C);
        for i = 1:n,
            pattern = X(i,:);
            for j = 1:C,
                gc = centroids(j,:);
                distance(i, j) = sum((pattern - gc) .^ 2); % distancia euclidiana ao quadrado
            end
        end
        J(iter) = sum(sum(((U .^ m) .* distance)));
        
        
        % Condicao de parada
        if iter == 1 || (abs(J(iter) - J(iter-1)) > 0.0001),
        
            % Calculo do U para a proxima iteracao
            newDistance = bsxfun(@rdivide, distance, sum(distance,2));
            U = (newDistance .^ (2/(m-1))) .^ (-1);
        
            % normalizacao de U
            sumU = sum(U, 2);
            U = bsxfun(@rdivide, U, sumU);
            
            iter = iter + 1;
            
        else
            changes = false;
        end

    end
    % Plotando J em funcao das iteracoes

    figure(2);
    hold on;
    plot(1:iter, J(1:iter), 'b--', 'LineWidth', 2);
    grid on;
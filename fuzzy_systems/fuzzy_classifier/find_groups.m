%	Trabalho Computacional 2 - Sistemas Nebulosos - UFMG - 2017/2
%	Professor Cristiano Leite de Castro
%	Alunos: Murilo Vale Ferreira Menezes
%			Renato Reis Brasil

function [centroids I] = find_groups(X,C)
    %% ---------------------------------------
    % Algoritmo fuzzy c-means, mesmo trecho de codigo implementado no TC1

    % Define o expoente
    m = 2;

    n = size(X, 1); % numero de observacoes
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
        if iter == 1 || (abs(J(iter) - J(iter-1)) > (.000001*J(iter-1))),
        
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
        
        if iter > 100,
            changes = false;
        end
        
    end

    %obtem os indices dos maiores graus de pertinencia
    [M, I] = max(U');
    
endfunction
    %iguala ao centroide correspondente ao indice, convertendo de volta para
    %inteiro de 8bits
%    XX = uint8(centroids(I,:));
%
%    %cria-se a imagem de saida
%    image2 = image;
%
%    %converte-se novamente os vetores para matrizes de pixels
%    image2(:,:,1) = reshape(XX(:,1),[size(image,1) size(image,2)]);
%    image2(:,:,2) = reshape(XX(:,2),[size(image,1) size(image,2)]);
%    image2(:,:,3) = reshape(XX(:,3),[size(image,1) size(image,2)]);
%
%    image2 = uint8(image2);
%
%    %salva
%    imwrite(image2,[path "ImagensTeste/photo00" mat2str(n_img) "CLUST.jpg"]);

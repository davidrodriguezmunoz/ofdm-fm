function lag = estLagZC(rSm,seqZCm)
% Estima el retardo de una se�al a partir de una secuencia Zadoff-Chu.
%
% El procedimiento seguido es el siguiente:
%   1� C�lculo de la correlaci�n cruzada entre la secuencia Zadoff-Chu 
%      que se espera recibir y la secuencia recibida.
%   2� Se divide adem�s por la norma de la secuencia ZC recibida y la norma
%      de la correlaci�n calculada, con lo que se obtiene phi.
%   3� El retardo (donde comienza la se�al) es el punto en el que phi es
%      mayor.

seqZC = seqZCm(:,1);
lag = zeros(size(rSm,2),1);
phi = zeros(size(rSm,1)-size(seqZCm,1)+1,size(rSm,2));

% Itero en cada s�mbolo
for i=1:size(rSm,2)
    rS = rSm(:,i);
    % C�lculo de la norma de cada secuencia CAZAC desplazada
    tmp = repmat(1:length(seqZC),length(rS)-length(seqZC)+1,1).';
    tmp2 = repmat(0:length(rS)-length(seqZC),length(seqZC),1);
    ind = tmp+tmp2;
    rS_CAZAC = rS(ind);
    rS_CAZACnorm = sqrt(sum(abs(rS_CAZAC).^2));

    % C�lculo de la correlaci�n
    corr = sum(rS_CAZAC.*conj(repmat(seqZC,1,length(rS_CAZACnorm))));
    phi(:,i) = corr./((rS_CAZACnorm).^2);

    % C�lculo del punto m�ximo
    [~,lag(i)] = max(abs(phi(:,i)));
end

end


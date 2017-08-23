function lag = estLagZC(rSm,seqZCm)
% Estima el retardo de una señal a partir de una secuencia Zadoff-Chu.
%
% El procedimiento seguido es el siguiente:
%   1º Cálculo de la correlación cruzada entre la secuencia Zadoff-Chu 
%      que se espera recibir y la secuencia recibida.
%   2º Se divide además por la norma de la secuencia ZC recibida y la norma
%      de la correlación calculada, con lo que se obtiene phi.
%   3º El retardo (donde comienza la señal) es el punto en el que phi es
%      mayor.

seqZC = seqZCm(:,1);
lag = zeros(size(rSm,2),1);
phi = zeros(size(rSm,1)-size(seqZCm,1)+1,size(rSm,2));

% Itero en cada símbolo
for i=1:size(rSm,2)
    rS = rSm(:,i);
    % Cálculo de la norma de cada secuencia CAZAC desplazada
    tmp = repmat(1:length(seqZC),length(rS)-length(seqZC)+1,1).';
    tmp2 = repmat(0:length(rS)-length(seqZC),length(seqZC),1);
    ind = tmp+tmp2;
    rS_CAZAC = rS(ind);
    rS_CAZACnorm = sqrt(sum(abs(rS_CAZAC).^2));

    % Cálculo de la correlación
    corr = sum(rS_CAZAC.*conj(repmat(seqZC,1,length(rS_CAZACnorm))));
    phi(:,i) = corr./((rS_CAZACnorm).^2);

    % Cálculo del punto máximo
    [~,lag(i)] = max(abs(phi(:,i)));
end

end


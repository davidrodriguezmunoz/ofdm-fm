function y=calcFrec(x,N,m,normalizar)
% Cálculo de la frecuencia instantánea. Equivale a un ifftnorm añadiéndole
% el índice de modulación y la normalización.
%
% Entradas:
%  - x: Señal de información (sigue criterio 3GPP)
%  - N: Longitud de la IFFT
%  - m: Índice de modulación
%  - normalizar: Aplicación (1) o no (0) de la normalización
%
% Salidas:
%  - y: IFFT normalizada de la señal x

% Realizo la ifft normalizada de la señal
yAux = ifftnorm(x,N,1);

% Normalización
if normalizar
    yMax = max(abs(yAux));
    yAux = yAux./repmat(yMax,N,1);
end

% Multiplico por el índice de modulación
y = m*yAux;

end
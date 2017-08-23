function y=calcFrec(x,N,m,normalizar)
% C�lculo de la frecuencia instant�nea. Equivale a un ifftnorm a�adi�ndole
% el �ndice de modulaci�n y la normalizaci�n.
%
% Entradas:
%  - x: Se�al de informaci�n (sigue criterio 3GPP)
%  - N: Longitud de la IFFT
%  - m: �ndice de modulaci�n
%  - normalizar: Aplicaci�n (1) o no (0) de la normalizaci�n
%
% Salidas:
%  - y: IFFT normalizada de la se�al x

% Realizo la ifft normalizada de la se�al
yAux = ifftnorm(x,N,1);

% Normalizaci�n
if normalizar
    yMax = max(abs(yAux));
    yAux = yAux./repmat(yMax,N,1);
end

% Multiplico por el �ndice de modulaci�n
y = m*yAux;

end
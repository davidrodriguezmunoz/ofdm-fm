function [tS]=introCP(tS_aux,longCP)
% Introducci�n del prefijo c�clico en una secuencia determinada
%
% Entradas:
%  - tS_aux: Secuencia a la que a�adir el CP. Parte �til del s�mbolo OFDM
%            (s�mbolos de informaci�n)
%  - longCP: Longitud del prefijo c�clico
%  - r: factor de sobremuestreo
%
% Salidas:
%  - tS: S�mbolo OFDM (CP+informaci�n)

% El CP est� formado por los �ltimos s�mbolos de informaci�n 
% (subportadoras) del s�mbolo OFDM
CP=tS_aux(end-longCP+1:end,:);

% Se a�ade al principio del s�mbolo OFDM (para evitar ISI y poder realizar
% la convoluci�n circular)
tS=vertcat(CP,tS_aux);

end
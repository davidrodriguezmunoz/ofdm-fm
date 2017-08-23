function [tS]=introCP(tS_aux,longCP)
% Introducción del prefijo cíclico en una secuencia determinada
%
% Entradas:
%  - tS_aux: Secuencia a la que añadir el CP. Parte útil del símbolo OFDM
%            (símbolos de información)
%  - longCP: Longitud del prefijo cíclico
%  - r: factor de sobremuestreo
%
% Salidas:
%  - tS: Símbolo OFDM (CP+información)

% El CP está formado por los últimos símbolos de información 
% (subportadoras) del símbolo OFDM
CP=tS_aux(end-longCP+1:end,:);

% Se añade al principio del símbolo OFDM (para evitar ISI y poder realizar
% la convolución circular)
tS=vertcat(CP,tS_aux);

end
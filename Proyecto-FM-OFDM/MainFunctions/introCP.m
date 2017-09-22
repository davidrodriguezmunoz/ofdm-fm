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
tS=cell(1,min(size(tS_aux)));
for i=1:length(longCP)
  
  CP_aux=tS_aux(end-longCP(i)+1:end,i);
  tS{1,i}=[CP_aux(:).' tS_aux(:,i).'];
end
% Se añade al principio del símbolo OFDM (para evitar ISI y poder realizar
% la convolución circular)


end
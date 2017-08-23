function rX=elimCP(rS, longCP, cpMargin, N)
% Eliminación del prefijo cíclico en una secuencia recibida determinada
%
% Entradas:
%  - rS: Secuencia a la que quitar el CP. Es el símbolo OFDM (CP+info)
%  - longCP: Posición del símbolo OFDM dentro del bloque
%  - cpMargin: Margen de retardo
%  - N: Longitud de la secuencia rX
%
% Salidas:
%  - rX: Parte útil del símbolo OFDM (información)

% Nos quedamos solo con las subportadoras a partir de longCP-cpMargin, de
% forma que exista una inmunidad de cpMargin instantes de atraso del sincronismo.
rX=rS(longCP-cpMargin+1:longCP-cpMargin+N,:);

end


function rX=elimCP(rS, longCP, cpMargin,N,ventanaCP)
% Eliminaci�n del prefijo c�clico en una secuencia recibida determinada
%
% Entradas:
%  - rS: Secuencia a la que quitar el CP. Es el s�mbolo OFDM (CP+info)
%  - longCP: Posici�n del s�mbolo OFDM dentro del bloque
%  - cpMargin: Margen de retardo
%  - N: Longitud de la secuencia rX
%  - ventanaCP: Longitud de la ventana del CP para correcci�n OFFSET. <1
%  sin efecto
% Salidas:
%  - rX: Parte �til del s�mbolo OFDM (informaci�n)

% Nos quedamos solo con las subportadoras a partir de longCP-cpMargin, de
% forma que exista una inmunidad de cpMargin instantes de atraso del sincronismo.
    if(ventanaCP<1)
        rX=rS(longCP-cpMargin+1:longCP-cpMargin+N,:);
    else
        rX=rS(longCP-ventanaCP-cpMargin+1:longCP-ventanaCP-cpMargin+N,:);
    end


end


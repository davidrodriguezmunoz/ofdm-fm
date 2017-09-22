function rX=elimCP(rS, longCP, cpMargin,N,ventanaCP,Nsc,Nsb)
% Eliminación del prefijo cíclico en una secuencia recibida determinada
%
% Entradas:
%  - rS: Secuencia a la que quitar el CP. Es el símbolo OFDM (CP+info)
%  - longCP: Posición del símbolo OFDM dentro del bloque
%  - cpMargin: Margen de retardo
%  - N: Longitud de la secuencia rX
%  - ventanaCP: Longitud de la ventana del CP para corrección OFFSET. <1
%  sin efecto
% Salidas:
%  - rX: Parte útil del símbolo OFDM (información)

% Nos quedamos solo con las subportadoras a partir de longCP-cpMargin, de
% forma que exista una inmunidad de cpMargin instantes de atraso del sincronismo.

rX=zeros(Nsc,Nsb);
for i=1:Nsb
    if(ventanaCP<1)
        rX(:,i)=rS{1,i}(longCP(i)-cpMargin+1:longCP(i)-cpMargin+N);
%         rX=rS(longCP-cpMargin+1:longCP-cpMargin+N,:);
    else
          rX(:,i)=rS{1,i}(longCP(i)-ventanaCP-cpMargin+1:longCP(i)-ventanaCP-cpMargin+N);
%         rX=rS(longCP-ventanaCP-cpMargin+1:longCP-ventanaCP-cpMargin+N,:);
    end
end

end


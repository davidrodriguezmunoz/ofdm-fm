function [dS,dSt] = dataGen(longB_phy,codificar,nCB,codeblock)
% Generaci�n del bloque de datos con bits aleatorios. Se puede elegir si
% hay codificaci�n o no. Si se elige, se debe indicar el n�mero de 
% codeblocks y su tama�o en bits.
% Se devuelve el n�mero de bits generados sin codificaci�n y el n�mero de
% bits con codificaci�n.

if nargin == 1
    codificar = 0;
end

if codificar
    dS = randi([0 1],1,nCB*codeblock);      % Se generan datos aleatorios
    % Codificaci�n turbo de los datos
    dSt = zeros(1,nCB*(3*codeblock+12));    % Redundancia de datos*3 + 12
    for i=1:nCB
        dSt((i-1)*(3*codeblock+12)+1:i*(3*codeblock+12)) = lteTurboEncode(dS((i-1)*codeblock+1:i*codeblock));
    end
else
    dS = randi([0 1],1,round(longB_phy));
    dSt = dS;                               % Los datos que se modulan son aleatorios 
end

end


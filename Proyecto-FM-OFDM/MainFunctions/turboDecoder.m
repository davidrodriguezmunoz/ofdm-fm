function [dSr,dSr_dec] = turboDecoder(dSr,longB_phy,nCB,codeblock)
% Turbo decodificador
% Argumentos de entrada:
%   -dSr: LLRs a decodificar
%   -longB_phy: Longitud del bloque f�sico
%   -nCB: N�mero de codeblocks
%   -codeblock: Tama�o en bits del decodificador

% Calculo las portadoras que se dejaron a 0 en transmisi�n con codif
longB_turbo=codeblock*3+12;
total_bits=longB_turbo*nCB;
dif=longB_phy-total_bits;

% Eliminaci�n los ceros al principio de la informaci�n
dSr = dSr(dif+1:end);
% Decodificaci�n
for i = 1:nCB
    dSr_dec((i-1)*codeblock+1:i*codeblock) = lteTurboDecode(-dSr((i-1)*longB_turbo+1:i*longB_turbo), 8); % convenio de signos en lteTurboDecode contrario al de 3GPP
end

end


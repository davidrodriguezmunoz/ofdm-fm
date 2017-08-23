function [nCB, sizeCodeblock] = codeblockParameters(Nsb, modo, Npb)
% Cálculo del número de codeblocks y de su tamaño
% nCB: Número
% sizeCodeblock: tamaño

if nargin == 2
    Npb=0;
end

if Nsb-Npb == 13
    if modo == 4
        nCB=1;                          
        sizeCodeblock = 2112;               
    elseif modo == 16
        nCB=1;                          
        sizeCodeblock = 4288;               
    else
        nCB=2;                          
        sizeCodeblock = 3200;               
    end
else %Nsb-Npb == 14
    if modo == 4
        nCB=1;                          
        sizeCodeblock = 2304;               
    elseif modo == 16
        nCB=1;                          
        sizeCodeblock = 4608;               
    else
        nCB=2;                          
        sizeCodeblock = 3456;               
    end
end


end


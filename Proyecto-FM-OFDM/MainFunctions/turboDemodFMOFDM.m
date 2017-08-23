function LLR = turboDemodFMOFDM(rX_simb,modo,Nsb,nCB,codeblock)
% Turbo demodulador para la tecnolog�a FM-OFDM
%
% Demodula las portadoras de informaci�n y devuelve los LLRs. En el caso de
% que no hubiera codificaci�n se pueden omitir los argumentos nCB y
% codeblock o indicar que su valor es 0.
%
% Argumentos de entrada
%   -rX_simb: Portadoras de informaci�n a demodular
%   -modo: Modulaci�n usada
%   -Nsb: N�mero de s�mbolos por bloque
%   -nCB: N�mero de codeblocks
%   -codeblock: Longitud del codeblock en bits
%
% Argumentos de salida
%   -LLR: LLRs de informaci�n

if nargin == 3
   nCB = 0; codeblock = 0;
end

% Inicializaciones
Nd = size(rX_simb,1); % N�mero de portadoras de datos
M = log2(modo);
LLR = zeros(M*Nd,Nsb);
rms = zeros(1,Nsb);   % Vector de valores del RMS

% C�lculo de las portadoras que se dejaron a 0 en transmisi�n con codif
longB_phy = blockgen(modo,Nd,Nsb);
if nCB ~= 0
    longB_turbo=codeblock*3+12;
    total_bits=longB_turbo*nCB;
    dif=longB_phy-total_bits;
else
    dif = 0;
end

% Iteraci�n en cada s�mbolo
for ind=1:Nsb
    % Demodulaci�n
    if ind==1 && nCB ~= 0
        % Calculo el rms
        rms(ind) = calcRMS(rX_simb(dif/M+1:Nd,ind));
        % Desnormalizo usando el rms
        rX_simb(dif/M+1:end,ind) = rX_simb(dif/M+1:end,ind)./rms(ind);
        % Demodulo
        switch modo
        case 4
            LLR(dif+1:end,ind)=QPSKdemod(rX_simb(dif/M+1:Nd,ind),Nd-dif/M);
        otherwise
            LLR(dif+1:end,ind)=QAMdemod(rX_simb(dif/M+1:Nd,ind),Nd-dif/M,modo);
        end
    else
        % Calculo el rms
        rms(ind) = calcRMS(rX_simb(:,ind));
        % Desnormalizo usando el rms
        rX_simb(:,ind) = rX_simb(:,ind)./rms(ind);
        switch modo
        case 4
            LLR(:,ind)=QPSKdemod(rX_simb(1:Nd,ind),Nd);
        otherwise
            LLR(:,ind)=QAMdemod(rX_simb(1:Nd,ind),Nd,modo);
        end
    end
end

end


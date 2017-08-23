function dPm_simb = turboModOFDM(dSt,modo,Nsb,Nd,longB_phy)
% Turbomodulador para OFDM.
%
% Argumentos de entrada:
%   -dSt: N�mero de bits a modular
%   -modo: modulaci�n
%   -Nsb: N�mero de s�mbolos por bloque
%   -Nd: N�mero de subportadoras de datos
%   -longB_phy: Longitud del bloque f�sico
%
% Argumentos de salida:
%   -dPm_simb: S�mbolos de informaci�n

dPm_simb = zeros(Nd,Nsb);

% Calculo los bits que faltan para rellenar el bloque f�sico
numb = size(dSt,2);
dif = longB_phy-numb;

% Modulaci�n de la primera subportadora
switch modo
case 4
    L = log2(modo);
    dPm_simb(dif/L+1:end,1) = QPSKmod(dSt(1:longB_phy/Nsb-dif));
otherwise
    L = log2(modo);
    dPm_simb(dif/L+1:end,1) = QAMmod(dSt(1:longB_phy/Nsb-dif),(Nd-dif/L),modo);
end

% Modulaci�n del resto de subportadoras
for ind=2:Nsb
    switch modo
    case 4
        % Crea la constelaci�n QPSK
        dPm_simb(:,ind)=QPSKmod(dSt(longB_phy/Nsb*(ind-1)-dif+1:longB_phy/Nsb*ind-dif));
    otherwise
        %Crea la constelaci�n 16QAM y 64QAM
        dPm_simb(:,ind)=QAMmod(dSt(longB_phy/Nsb*(ind-1)-dif+1:longB_phy/Nsb*ind-dif),Nd,modo);
    end  
end


end


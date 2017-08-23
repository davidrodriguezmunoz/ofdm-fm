function [dPm,dSt,dS,bitTotal,bitTotal_cod]=FMOFDMtransFreq(sim,longB_phy,bitTotal,bitTotal_cod)
%   OFDMtransFreq: Generador de s�mbolos OFDM a transmitir
% Transmisor OFDM a nivel de TTI, en frecuencia.
%
% Entradas:
% - Na: n� portadoras activas
% - Nsc: longitud FFT
% - Nsb: n� s�mbolos OFDM
% - modo: modulaci�n
% - nCB: n� codeblocks
% - codeblock: longitud de codeblock (bits)
% - longB_phy: longitud del bloque f�sico a mapear en tiempo-frecuencia
% - bitTotal: n� bits de usuario transmitidos hasta ese TTI
% - bitTotal_cod: n� bits codificados transmitidos hasta ese TTI
% - k0: N�mero de portadoras que desechamos para combatir imperfecciones
%       del canal
% - dft: Utilizaci�n de dft para suavizar la se�al
% - codificar: Indica si se usa o no codificaci�n
%
% Salidas:
% - bitTotal: n� bits de usuario transmitidos
% - dPm: se�al a transmitir en el dominio de la frecuencia
% - dSt: datos de usuario tras la codificaci�n turbo

% Extracci�n de datos del objeto
Na        = sim.Na;
Nsc       = sim.Nsc;
Nsb       = sim.Nsb;
% Npb       = sim.Npb;
Nd        = sim.Nd;
modo      = sim.modo;
k0        = sim.k0;
dft       = sim.dft;
codificar = sim.codificar;
nCB       = sim.nCB;
codeblock = sim.codeblock;
valPil    = sim.valPil;
posPil    = sim.posPil;
sinc      = sim.sinc;
Nssb      = sim.Nssb;
Nps       = sim.Nps;
Ndp       = Nd+Nps;

% Inicializaciones
dPm = zeros(Nsc,Nssb);
dPm_simbP = zeros(Ndp,Nssb);

% Generaci�n del bloque datos. Se diferencia si se usa codificaci�n o no.
[dS,dSt] = dataGen(longB_phy,codificar,nCB,codeblock);

% C�lculo del n�mero de bits que se van a transmitir
if codificar
    bitTotal=bitTotal+nCB*codeblock;
    bitTotal_cod = bitTotal_cod + nCB * (3*codeblock+12); %Redundancia de datosx3 +12 que introduce la codificaci�n turbo
else
    bitTotal=bitTotal+length(dSt);
end

% Turbo modulador de OFDM
dPm_simb = zeros(Nd,Nssb);
dPm_simb(:,1+sinc:end) = turboModOFDM(dSt,modo,Nsb,Nd,longB_phy);

% Adici�n del primer bloque para el sincronismo
if sinc
    longS_phy = blockgen(modo,Nd,1);
    [~,dStFirst] = dataGen(longS_phy,codificar,nCB,codeblock);
    dPm_simb(:,1) = turboModOFDM(dStFirst,modo,1,Nd,longS_phy);
end

% Adici�n de los pilotos
if sinc
    if modo == 4
        div=sqrt(2);
    elseif modo == 16
        div=sqrt(10);
    else
        div=sqrt(42);
    end
    mPilots = repmat(valPil,1,Nssb)/div;
    posPil = [0;posPil];
    for ind = 1:length(posPil)-1
        pos = posPil(ind);
        posNext = posPil(ind+1);
        dPm_simbP(pos+1:posNext,:) = [dPm_simb(pos-ind+2:posNext-ind,:);mPilots(ind,:)];
    end
    dPm_simbP(posPil(end)+1:end,:) = dPm_simb(posPil(end)-length(posPil)+2:end,:);
else
    dPm_simbP = dPm_simb;
end

% DFT si es necesario de orden Nd
if dft
    for ind=1:Nssb
        dPm_simbP(:,ind) = fftnorm(dPm_simbP(:,ind),Ndp);
    end
end

% Ubicaci�n de cada s�mbolo en su subportadora. La parte negativa son los
% s�mbolos conjugados y dados la vuelta para que sea herm�tico.
for ind=1:Nssb
    dPm(:,ind) = [zeros((Nsc-Na)/2,1); fliplr(dPm_simbP(:,ind)').'; zeros(2*k0+1,1); dPm_simbP(:,ind); zeros(((Nsc-Na)/2)-1,1)];                                                                                                                                                    
end

end
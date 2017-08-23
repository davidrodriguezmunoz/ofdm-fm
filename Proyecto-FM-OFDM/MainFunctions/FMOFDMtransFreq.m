function [dPm,dSt,dS,bitTotal,bitTotal_cod]=FMOFDMtransFreq(sim,longB_phy,bitTotal,bitTotal_cod)
%   OFDMtransFreq: Generador de símbolos OFDM a transmitir
% Transmisor OFDM a nivel de TTI, en frecuencia.
%
% Entradas:
% - Na: nº portadoras activas
% - Nsc: longitud FFT
% - Nsb: nº símbolos OFDM
% - modo: modulación
% - nCB: nº codeblocks
% - codeblock: longitud de codeblock (bits)
% - longB_phy: longitud del bloque físico a mapear en tiempo-frecuencia
% - bitTotal: nº bits de usuario transmitidos hasta ese TTI
% - bitTotal_cod: nº bits codificados transmitidos hasta ese TTI
% - k0: Número de portadoras que desechamos para combatir imperfecciones
%       del canal
% - dft: Utilización de dft para suavizar la señal
% - codificar: Indica si se usa o no codificación
%
% Salidas:
% - bitTotal: nº bits de usuario transmitidos
% - dPm: señal a transmitir en el dominio de la frecuencia
% - dSt: datos de usuario tras la codificación turbo

% Extracción de datos del objeto
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

% Generación del bloque datos. Se diferencia si se usa codificación o no.
[dS,dSt] = dataGen(longB_phy,codificar,nCB,codeblock);

% Cálculo del número de bits que se van a transmitir
if codificar
    bitTotal=bitTotal+nCB*codeblock;
    bitTotal_cod = bitTotal_cod + nCB * (3*codeblock+12); %Redundancia de datosx3 +12 que introduce la codificación turbo
else
    bitTotal=bitTotal+length(dSt);
end

% Turbo modulador de OFDM
dPm_simb = zeros(Nd,Nssb);
dPm_simb(:,1+sinc:end) = turboModOFDM(dSt,modo,Nsb,Nd,longB_phy);

% Adición del primer bloque para el sincronismo
if sinc
    longS_phy = blockgen(modo,Nd,1);
    [~,dStFirst] = dataGen(longS_phy,codificar,nCB,codeblock);
    dPm_simb(:,1) = turboModOFDM(dStFirst,modo,1,Nd,longS_phy);
end

% Adición de los pilotos
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

% Ubicación de cada símbolo en su subportadora. La parte negativa son los
% símbolos conjugados y dados la vuelta para que sea hermítico.
for ind=1:Nssb
    dPm(:,ind) = [zeros((Nsc-Na)/2,1); fliplr(dPm_simbP(:,ind)').'; zeros(2*k0+1,1); dPm_simbP(:,ind); zeros(((Nsc-Na)/2)-1,1)];                                                                                                                                                    
end

end
function [dSr,dSr_dec]=FMOFDMrecepFreq(sim,rX_freq)
%%   OFDMrecep: Receptor  OFDM de bloques de Nsb símbolos OFDM
% Receptor OFDM a nivel de TTI, en frecuencia.
%
% Entradas:
% - Na: nº portadoras activas
% - Nsc: longitud FFT
% - Nsb: nº símbolos OFDM
% - nCB: nº codeblocks
% - codeblock: longitud de codeblock (bits)
% - longB_phy: longitud del bloque físico a mapear en tiempo-frecuencia
% - modo: modulación
% - rX_freq: señal recibida en frecuencia, matriz de dimensión Nsc x Nsb 
% - ch: tipo de canal ('gaus', 'ray')
% - H: respuesta en frecuencia del canal
% - snr: SNR (dB)
% - codificar: Si se usa codificación
%
% Salidas:
% - dSr_dec: bits recibidos a la salida del decodificador
% - dSr: soft bits recibidos (LLRs) a la entrada del decodificador

% Extracción de parámetros del objeto
Nsc = sim.Nsc;
Nsb = sim.Nsb;
Npb = sim.Npb;
modo = sim.modo;
codeblock = sim.codeblock;
nCB = sim.nCB;
k0 = sim.k0;
dft = sim.dft;
codificar = sim.codificar;
Nd = sim.Nd;
Nps = sim.Nps;
Ndp = Nd+Nps;
posPil = sim.posPil;
longB_phy = blockgen(modo,Nd,Nsb);
sinc = sim.sinc;

% Inicialización de variables
dSr_dec = zeros(1,nCB*codeblock);

% Eliminación de portadora DC y de las que no son activas
rX_simb = rX_freq(Nsc/2+k0+2:Nsc/2+k0+Ndp+1,1:end);

% IFFT adicional
if dft
    for ind = 1:Nsb
        rX_simb(:,ind) = ifftnorm(rX_simb(:,ind),Ndp);
    end
end

if sinc
    % Eliminación de pilotos
    rX_simb(posPil,:) = [];
end

if ~codificar
   nCB = 0; codeblock = 0; 
end

% Demodulación para calcular los LLR
LLR = turboDemodFMOFDM(rX_simb,modo,Nsb,nCB,codeblock);

% Reordenación de LLRs
dSr=reshape(LLR,1,longB_phy);   % LLRs recibidos

% Si se realizó codificación se decodifican los LLRs
if codificar
    [dSr,dSr_dec] = turboDecoder(dSr,longB_phy,nCB,codeblock);
end

end
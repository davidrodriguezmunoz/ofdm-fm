function [berS,blerS,berS_canal,blerS_canal,lag]= sistemaFMOFDM(sim)
% Script de un sistema OFDM con modulaci�n en frecuencia. En este script se
% estudian los efectos de cada imperfecci�n por separado.

NO = 0; CFO = 1; PN = 2; CH=3;

%% Definici�n de las variables

% -------------------------------------------------------------------------
% Extracci�n de datos del objeto

blockErSim = sim.blockErSim;                % N�mero de bloques err�neos a simular
SNR = sim.iSNR;                             % SNR del canal
modo = sim.modo;                            % Modulaci�n usada
speedKMH = sim.speedKMH;                    % Velocidad en Km/h
tau = sim.tau;                              % Perfil de retardos del canal
pdb = sim.pdb;                              % Perfil de amplitudes del canal
efecto = sim.efecto;                        % Tipo de efecto a�adido
codificar = sim.codificar;                  % Uso (1) o no (0) de codificacion
Nd = sim.Nd;                                % N�mero de subportadoras de datos
Nsc = sim.Nsc;                              % Longitud de la FFT
Nsb = sim.Nsb;                              % N�mero de s�mbolos por bloque
Npb = sim.Npb;                              % N�mero de s�mbolos con pilotos por bloque
k0  = sim.k0;                               % Subportadora de corte
fc = sim.fc;                                % Frecuencia de la portadora
sampleR = sim.sampleR;                      % Frecuencia de muestreo
m = sim.m;                                  % �ndice de modulaci�n
longCP = sim.longCP;                        % Vector de longitudes del prefijo c�clico
longCAZAC = sim.longCAZAC;                  % Vector de longitudes del CAZAC
tipo = sim.tipo;                            % Si se introducen los efectos juntos o separados
normalizar = sim.normalizar;                % Si se aplica normalizaci�n o no
wdwSync = sim.wdwSync;                      % N� de bloques de la ventana inicial de sincronizaci�n
cpMargin = sim.cpMargin;                    % Margen de muestras que se escogen del CP (25%)
posPil = sim.posPil;                        % Posiciones de los pilotos
valPil = sim.valPil;                        % Valores de los pilotos
delay = sim.delay;                          % Retardo absoluto
sinc = sim.sinc;                            % Uso de sincronismo (1) o no (0).
Nssb = sim.Nssb;                            % N�mero de s�mbolos simulados por bloque
dft = sim.dft;                              % Indica si se usa o no la DFT
eq_type=sim.eq_type;
% -------------------------------------------------------------------------
% Relacionadas con la informacion (bits tx, bloques tx y erroneos, BER y BLER)

bitTotal = 0;                               % Bits totales enviados
bitTotal_cod = 0;                           % Bits totales codificados enviados
BitEr_canal = 0;                            % Bits err�neos sin codificaci�n
BitEr=0;                                    % Bits err�neos con codificaci�n
nblocks = 0;                                % N� bloques transmitidos
nblocks_min = 0;                            % N� m�nimo de bloques a transmitir
BlockER_canal=0;                            % Bloques err�neos antes de decodificar
berS_canal=0;                               % BER de canal (sin codificaci�n)
blerS_canal=0;                              % BLER de canal (sin codificaci�n)
BlockER=0;                                  % Bloques err�neos despues de decodificar
berS=0;                                     % BER de canal (con codificaci�n)
blerS=0;                                    % BLER de canal (con codificaci�n)
longB_phy = blockgen(modo,Nd,Nsb-Npb);      % Tama�o del bloque f�sico contenido en portadoras de datos
juntos = strcmp(tipo,'juntos');             % Logical que es 1 cuando se introducen todos los efectos
lag = zeros(blockErSim,1);

% C�lculo del CAZAC
if longCAZAC ~= 0
    CAZAC = lteZadoffChuSeq(25,longCAZAC);
    CAZAC = repmat(CAZAC,1,Nssb);
else
    CAZAC = [];
end

% Ajuste de las variables de efecto para eliminar los strings
switch efecto
    case 'CH'
        efecto = CH;
    case 'CFO'
        efecto = CFO;
    case 'PN'
        efecto = PN;
    otherwise
        efecto = NO;
end

% -------------------------------------------------------------------------
% Relacionadas con los efectos que se introducen

if efecto == CFO || juntos
    Foff = 7.5e3; % Offset de frecuencia del CFO
end
if efecto == PN || juntos
    Pot_PN = GenerarPotenciaPN(fc); % Potencia del ruido de fase
end
if efecto == CH || juntos
    [chan, nblocks_min] = rayChanGen(fc,sampleR,speedKMH,tau,pdb);
    
end
                       
%% Sistema

SNR

% -------------------------------------------------------------------------
% Simulaci�n

Nt = Nsc+longCP+longCAZAC;          % Longitud total del s�mbolo
Ncp = Nsc+longCP;                   % Longitud sin CAZAC

% if sinc
%     % ETAPA DE SINCRONIZACI�N
%     disp('FASE DE SINCRONIZACI�N');
%     disp('----------------------');
%     mLagEst = zeros(wdwSync,Nssb);
%     for ind=1:wdwSync
%         % -----------------------------------------------------------------
%         %                              TRANSMISOR             
% 
%         % Generaci�n del bloque OFDM a transmitir
%         dPm=FMOFDMtransFreq(sim,longB_phy,0,0);
%         % C�lculo de la frecuencia instant�nea
%         tF = calcFrec(dPm,Nsc,m,normalizar);
%         % Construcci�n de la fase instant�nea
%         tP = calcFase(tF);
%         % Generaci�n de la se�al discreta y en banda base
%         tS_d_aux = exp(1i.*tP);
%         % Adici�n del prefijo c�clico
%         tS_d = introCP(tS_d_aux,longCP);
%         % Adici�n del CAZAC
%         tSp = introCAZAC(tS_d,CAZAC);
%         % Conversor P/S
%         tS = reshape(tSp,Nssb*Nt,1);
% 
%         % -----------------------------------------------------------------
%         %                                CANAL   
% 
%         % Introducci�n del efecto pertinente
%         if efecto == CFO || juntos
%             tS = introCFO(tS,Foff,sampleR);
%         end
%         if efecto == PN || juntos
%             tS = introPN(tS,Pot_PN);
%         end
%         if efecto == CH || juntos
%             tS = filter(chan,tS);
%         end
% 
%         % Adici�n de ruido Gaussiano
%         rS_n = awgn(tS,SNR);  
% 
%         % Retardar la se�al
%         rS_n = delaySignal(rS_n,delay,Nssb);
% 
%         % -----------------------------------------------------------------
%         %                               RECEPTOR                               
% 
%         % Conversor S/P
%         rSp = reshape(rS_n,Nt,Nssb);
%         % Estimaci�n de los retardos usando el CAZAC
%         mLagEst(ind,:) = estLagZC(rSp, CAZAC);
% 
%         fprintf(1,[num2str(ind), ' ']);
%     end
% 
%     % Calculo el valor que m�s se repite en la ventana de sincronizaci�n
%     vLagEst = reshape(mLagEst,wdwSync*Nssb,1);
%     lagEst = mode(vLagEst);
% 
% 
%     fprintf(1,['\nSincronizaci�n en el instante ',num2str(lagEst),'\n\n']);
% end

% ETAPA DE RECEPCI�N DE DATOS
disp('FASE DE RECEPCI�N DE DATOS');
disp('--------------------------');
varBlockER = 0;
mLagEst = zeros(wdwSync,Nssb);
if(nblocks_min>2000)
    nblocks_min=2000;
end
while (varBlockER<blockErSim || nblocks < nblocks_min)

    % -----------------------------------------------------------------
    %                              TRANSMISOR             
    
    % Generaci�n del bloque OFDM a transmitir
    [dPm,dSt,dS,bitTotal,bitTotal_cod]=FMOFDMtransFreq(sim,longB_phy,bitTotal,bitTotal_cod);
    % C�lculo de la frecuencia instant�nea
    tF = calcFrec(dPm,Nsc,m,normalizar);
    % Construcci�n de la fase instant�nea
    tP = calcFase(tF);
    % Generaci�n de la se�al discreta y en banda base
    tS_d_aux = exp(1i.*tP);
    % Adici�n del prefijo c�clico
    tS_d = introCP(tS_d_aux,longCP);
    % Adici�n del CAZAC
    tSp = introCAZAC(tS_d,CAZAC);
    % Conversor P/S
    tS = reshape(tSp,Nssb*Nt,1);
        
    % -----------------------------------------------------------------
    %                                CANAL   

    % Introducci�n del efecto pertinente
    if efecto == CFO || juntos
        tS = introCFO(tS,Foff,sampleR);
    end
    if efecto == PN || juntos
        tS = introPN(tS,Pot_PN);
    end
    if efecto == CH || juntos
        tS=filter(chan,tS.').';
    end

    % Adici�n de ruido Gaussiano
    rS_n = awgn(tS,SNR);

    % Retardar la se�al
    if sinc
        rS_n = delaySignal(rS_n,delay,Nssb);
    end

    % -----------------------------------------------------------------
    %                               RECEPTOR                               

    % Conversor S/P
    rSp_n = reshape(rS_n,Nt,Nssb);
    if sinc
%         % Estimaci�n de los retardos usando el CAZAC
%         iLags = estLagZC(rSp_n, CAZAC);
%         mLagEst(mod(nblocks,wdwSync)+1,:) = iLags;
%         if mod(nblocks,wdwSync) == 0 && nblocks > 0
%             vLagEst = reshape(mLagEst,wdwSync*Nsb,1);
%             lagEst = mode(vLagEst);
%         end
        % Apunto al comienzo del s�mbolo
        rS = rS_n(lagEst:end-(Nt-lagEst)-1,:);
        rSp = reshape(rS,Nt,Nsb);
    else
        rSp = rSp_n;
    end
    % Eliminaci�n del CAZAC
    rS_d_aux = elimCAZAC(rSp,length(CAZAC));
    
    %% Introducir y compensar offset de sincronismo (si efecto == 'offset')
    % 1. introducir un offset en la se�al, seg�n un n� muestras configurable n_off que indican el retardo introducido 
    % 2. eliminar el prefijo, contando como comienzo de s�mbolo el instante inicial estimado + longCP - ventanaCP, donde ventanaCP es una ventana configurable 
    % 3. desplazar la respuesta al impulso seg�n h[n + n_off - ventanaCP], donde h es la respuesta ideal
    % 4. ecualizar con h[n + n_off - ventanaCP]
    %%
    
    % Eliminaci�n del prefijo c�clico (si efecto ~= 'offset')
    rS_d = elimCP(rS_d_aux,longCP,cpMargin,Nsc);
    
    %% Ecualizaci�n de la se�al
    
    if efecto == CH || juntos
        
          h_n_matrix=channel_estimation(chan,Nssb,Nt,sampleR,speedKMH);
          rS_d=channelEq( h_n_matrix,rS_d,Nsc,SNR,eq_type,Nsb);
    end
    % reconstruir la respuesta al impulso y aplicar ZF/MMSE
    %%

    % Extracci�n de la fase
    rP = unwrap(angle(rS_d));
    % Recuperaci�n de la frecuencia instant�nea
    rF_aux = recFrec(rP);  
%     % Acotaci�n de la se�al
%     rF_aux = acotarSignal(rF_aux,m);
    % Recuperaci�n de las portadoras
    rX_freq = calcEspectroFrec(rF_aux,Nsc,m);
    % C�lculo y compensaci�n de la fase progresiva
    if sinc
        [rX_freq,vLag] = estPhaseProg2(rX_freq,valPil,posPil,Nsc,k0,Nd,dft);
        lag(nblocks*Nsb+1:Nsb*(nblocks+1)) = vLag.';
    end
    % Realizo el procesamiento de la se�al recibida (eq, demod...)
    [dSr,dSr_dec]=FMOFDMrecepFreq(sim,rX_freq); 
    
    
    nblocks = nblocks+1;
    
    % ---------------------------------------------------------------------
    % C�lculos de BER y BLER
    
    %BER/BLER antes de decodificar
    bitsRx = dSr<0;
    nErrors = sum(bitsRx ~= dSt);
    BitEr_canal = BitEr_canal + nErrors;
    flagBlockER = nErrors > 0;

    if codificar
        berS_canal = BitEr_canal/bitTotal_cod;
    else
        berS_canal = BitEr_canal/bitTotal;
    end

    if flagBlockER
        BlockER_canal=BlockER_canal+1;
        if ~codificar
            fprintf(1,[num2str(BlockER_canal), ' ']);
        end
    end
    blerS_canal= BlockER_canal/nblocks;

    % BER/BLER despu�s de decodificar
    if codificar
        nErrors = sum(dSr_dec ~= dS);
        BitEr = BitEr + nErrors;
        flagBlockER = nErrors > 0;

        berS = BitEr/bitTotal;

        if flagBlockER
            BlockER=BlockER+1;
%             fprintf(1,[num2str(BlockER), ' ']);
        end
        blerS= BlockER/nblocks;
    end
    
    % ---------------------------------------------------------------------
    % Control de ejecuci�n

    % Cambio la variable de iteraci�n del bucle en funci�n de si se aplica
    % codificaci�n
    if codificar
        varBlockER = BlockER;
    else
        varBlockER = BlockER_canal;
    end
    
    % Fichero de estado de ejecuci�n
    if mod(nblocks,500)==0
        results = [berS_canal,blerS_canal,berS,blerS];
        storeExecResults(sim,results,nblocks,varBlockER);
    end 

end

%% Display de resultados
 
% Resultados num�ricos
disp(['Bloques transmitidos: ',num2str(nblocks)]);
if codificar
    disp(['BER: ', num2str(berS),'    BLER: ',num2str(blerS)]);
    disp(['N� bloques err�neos: ',num2str(BlockER)]);
end
disp(['BER canal: ',num2str(berS_canal),'    BLER canal: ',num2str(blerS_canal)]);
disp(['N� bloques canal err�neos: ',num2str(BlockER_canal)]);


end
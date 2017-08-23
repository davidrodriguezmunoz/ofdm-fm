function [chan,nblocks_min] = rayChanGen(fc,sampleR,speedKMH,tau,pdb)
% Genera el canal

% Cálculo de otras variables
c = 3e8;                             % Velocidad de la luz en m/s
NumCiclosTaps = 10;                  % Número de ciclos de los taps a la frecuencia más pequeña, 
                                     % para evaluar la condición de terminación en Rayleigh
NumSinusMin = 7;                     % Número mínimo de sinusoides para la generación de los taps Rayleigh
Tsubframe = 1e-3;                    % Duración de una subframe (TTI) = 1 ms
speed=speedKMH/3.6;                  % Velocidad del usuario en m/s
fmaxdop=fc*speed/c;                  % Desplazamiento doppler máximo
tau=round(tau*sampleR)/sampleR;      % Ajuste de los retardos a la frecuencia de muestreo
                                     % para que el retardo sea un número entero de muestras
                                     
% Generación del canal
chan = rayleighchan(1/sampleR,fmaxdop,tau,pdb); %Creación del objeto que simulará el canal
chan.ResetBeforeFiltering = 0;       % No reiniciamos el canal
chan.StorePathGains = 1;             % Guardaremos las ganancias para la reconstrucción de la respuesta
chan.StoreHistory = 0;               % No se almacena la historia del canal
chan.NormalizePathGains=1;           % Se normalizan las ganancias

% Nº de bloques mínimo para que se ejecuten al menos NumCiclosTaps
% ciclos doppler a la frecuencia más pequeña de los taps
if speed == 0
    nblocks_min = 0;
else
    nblocks_min = (NumCiclosTaps/(fmaxdop*sin(pi/(4*NumSinusMin))))/Tsubframe;
end

end


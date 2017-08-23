function [chan,nblocks_min] = rayChanGen(fc,sampleR,speedKMH,tau,pdb)
% Genera el canal

% C�lculo de otras variables
c = 3e8;                             % Velocidad de la luz en m/s
NumCiclosTaps = 10;                  % N�mero de ciclos de los taps a la frecuencia m�s peque�a, 
                                     % para evaluar la condici�n de terminaci�n en Rayleigh
NumSinusMin = 7;                     % N�mero m�nimo de sinusoides para la generaci�n de los taps Rayleigh
Tsubframe = 1e-3;                    % Duraci�n de una subframe (TTI) = 1 ms
speed=speedKMH/3.6;                  % Velocidad del usuario en m/s
fmaxdop=fc*speed/c;                  % Desplazamiento doppler m�ximo
tau=round(tau*sampleR)/sampleR;      % Ajuste de los retardos a la frecuencia de muestreo
                                     % para que el retardo sea un n�mero entero de muestras
                                     
% Generaci�n del canal
chan = rayleighchan(1/sampleR,fmaxdop,tau,pdb); %Creaci�n del objeto que simular� el canal
chan.ResetBeforeFiltering = 0;       % No reiniciamos el canal
chan.StorePathGains = 1;             % Guardaremos las ganancias para la reconstrucci�n de la respuesta
chan.StoreHistory = 0;               % No se almacena la historia del canal
chan.NormalizePathGains=1;           % Se normalizan las ganancias

% N� de bloques m�nimo para que se ejecuten al menos NumCiclosTaps
% ciclos doppler a la frecuencia m�s peque�a de los taps
if speed == 0
    nblocks_min = 0;
else
    nblocks_min = (NumCiclosTaps/(fmaxdop*sin(pi/(4*NumSinusMin))))/Tsubframe;
end

end


function tS_CFO = introCFO(tS_aux,Foff,Fs)
% Introducción del Carrier Frequency Offset (CFO) a una señal
%
% Entradas:
%  - tS_aux: Señal a la que añadir el CFO
%  - Foff:  Offset de frecuencia
%  - Fs: Frecuencia de muestreo de la señal
%  - NtS: Longitud de la FFT de la señal
%
% Salidas:
%  - tS_CFO: Señal con CFO


% Creo el vector temporal
n = 0:length(tS_aux)-1;
% Genero el CFO
cfo = exp(1i*2*pi*Foff*n/Fs).';
% Lo añado a la señal
tS_CFO = tS_aux .* cfo;

end
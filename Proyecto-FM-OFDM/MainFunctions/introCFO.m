function tS_CFO = introCFO(tS_aux,Foff,Fs)
% Introducci�n del Carrier Frequency Offset (CFO) a una se�al
%
% Entradas:
%  - tS_aux: Se�al a la que a�adir el CFO
%  - Foff:  Offset de frecuencia
%  - Fs: Frecuencia de muestreo de la se�al
%  - NtS: Longitud de la FFT de la se�al
%
% Salidas:
%  - tS_CFO: Se�al con CFO


% Creo el vector temporal
n = 0:length(tS_aux)-1;
% Genero el CFO
cfo = exp(1i*2*pi*Foff*n/Fs).';
% Lo a�ado a la se�al
tS_CFO = tS_aux .* cfo;

end
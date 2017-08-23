function y = calcEspectroFrec(sRx,N,m)
% FFT normalizada con índice de modulación
% 
% Entradas:
%  - x: Señal a la que hacer la FFT (sigue criterio Matlab)
%  - N: Longitud de la IFFT
%  - m: Índice de modulación
%
% Salidas:
%  - y: FFT normalizada de la señal s (sigue criterio 3GPP)

% FFT normalizada
y = fftnorm(sRx/m,N);

end
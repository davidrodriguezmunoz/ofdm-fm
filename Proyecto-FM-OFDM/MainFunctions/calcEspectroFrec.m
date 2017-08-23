function y = calcEspectroFrec(sRx,N,m)
% FFT normalizada con �ndice de modulaci�n
% 
% Entradas:
%  - x: Se�al a la que hacer la FFT (sigue criterio Matlab)
%  - N: Longitud de la IFFT
%  - m: �ndice de modulaci�n
%
% Salidas:
%  - y: FFT normalizada de la se�al s (sigue criterio 3GPP)

% FFT normalizada
y = fftnorm(sRx/m,N);

end
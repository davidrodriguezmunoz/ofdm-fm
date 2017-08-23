function Xnorm=fftnorm(x,N,dim)
% FFT normalizada
% 
% Entradas:
%  - x: Señal a la que hacer la FFT (sigue criterio Matlab)
%  - N: Longitud de la IFFT
%  - dim: Dimensión a lo largo de la que se calcula la IFFT
%
% Salidas:
%  - y: FFT normalizada de la señal s (sigue criterio 3GPP)

if nargin==2
    dim=1;
end

% FFT de la señal
Xaux = fft(x,N,dim);

% Paso a convenio de MatLab
X = fftshift(Xaux,dim);

% Normalizo el resultado
Xnorm = X/sqrt(N);

end
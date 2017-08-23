function Xnorm=fftnorm(x,N,dim)
% FFT normalizada
% 
% Entradas:
%  - x: Se�al a la que hacer la FFT (sigue criterio Matlab)
%  - N: Longitud de la IFFT
%  - dim: Dimensi�n a lo largo de la que se calcula la IFFT
%
% Salidas:
%  - y: FFT normalizada de la se�al s (sigue criterio 3GPP)

if nargin==2
    dim=1;
end

% FFT de la se�al
Xaux = fft(x,N,dim);

% Paso a convenio de MatLab
X = fftshift(Xaux,dim);

% Normalizo el resultado
Xnorm = X/sqrt(N);

end
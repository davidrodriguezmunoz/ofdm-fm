function xNorm=ifftnorm(X,N,dim)
% Cálculo de la frecuencia instantánea. Equivale a un ifftnorm añadiéndole
% el índice de modulación.
%
% Entradas:
%  - x: Señal de información (sigue criterio 3GPP)
%  - N: Longitud de la IFFT
%  - dim: Dimensión a lo largo de la que se calcula la IFFT
%
% Salidas:
%  - y: IFFT normalizada de la señal x

if nargin==2
    dim=1;
end

% Paso a convenio de MatLab
Xaux = ifftshift(X,dim);

% IFFT de la señal
x = ifft(Xaux,N,dim);

% Normalizo el resultado
xNorm = sqrt(N)*x;

end
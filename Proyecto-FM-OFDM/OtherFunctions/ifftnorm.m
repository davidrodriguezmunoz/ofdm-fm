function xNorm=ifftnorm(X,N,dim)
% C�lculo de la frecuencia instant�nea. Equivale a un ifftnorm a�adi�ndole
% el �ndice de modulaci�n.
%
% Entradas:
%  - x: Se�al de informaci�n (sigue criterio 3GPP)
%  - N: Longitud de la IFFT
%  - dim: Dimensi�n a lo largo de la que se calcula la IFFT
%
% Salidas:
%  - y: IFFT normalizada de la se�al x

if nargin==2
    dim=1;
end

% Paso a convenio de MatLab
Xaux = ifftshift(X,dim);

% IFFT de la se�al
x = ifft(Xaux,N,dim);

% Normalizo el resultado
xNorm = sqrt(N)*x;

end
function xDelayed = delaySignal(x, delay,Nssb)
% Retarda una señal delay muestras

% Se añade al final la parte del principio para mantener las dimensiones
len = size(x,1)/Nssb;
xDelayed = [x(len-delay+1:end,:);x(1:len-delay,:)];


end


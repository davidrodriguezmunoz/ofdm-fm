function tP=calcFase(tF)
% Función para calcular la fase instantánea (tP) a partir de la frecuencia
% instantánea (tF)

phi_init = 0; % Fase inicial
tP = phi_init+2*pi*cumsum(tF); % Cálculo de la fase instantánea

end
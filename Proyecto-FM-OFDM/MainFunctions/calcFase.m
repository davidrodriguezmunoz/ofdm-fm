function tP=calcFase(tF)
% Funci�n para calcular la fase instant�nea (tP) a partir de la frecuencia
% instant�nea (tF)

phi_init = 0; % Fase inicial
tP = phi_init+2*pi*cumsum(tF); % C�lculo de la fase instant�nea

end
function rF = recFrec(rP)
% Recuperación de la frecuencia instantánea (rF) a partir de la fase
% instantánea (rP)

% Inicializaciones
phi_init = zeros(1,size(rP,2)); % Fase inicial
rP_aux = [phi_init;rP];

%% Prueba dientes de sierra

% rPdiff = diff(rP_aux);
% rPsaw = zeros(size(rPdiff));
% for n=1:length(rPdiff)
%     if rPdiff(n) > pi/2
%         rPsaw(n) = pi-rPdiff(n);
%     elseif rPdiff(n) < -pi/2
%         rPsaw(n) = -pi-rPdiff(n);
%     else
%         rPsaw(n) = rPdiff(n);
%     end
% end
% 
% rF = rPsaw/(2*pi);

%% Recuperación de la frecuencia

rF = diff(rP_aux)/(2*pi);

end

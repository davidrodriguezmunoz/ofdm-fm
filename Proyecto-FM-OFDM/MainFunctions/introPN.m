function tS_PN = introPN(tS_aux,Pot_PN)
% Introducción del ruido de fase siguiendo el modelo de Leeson. Utiliza el
% script add_phase_noise.
%
% Entradas:
%  - tS_aux: Señal a la que añadir el ruido de fase
%  - Pot_PN: Potencia del espectro de ruido de fase
%
% Salidas:
%  - tS_PN: Señal con ruido de fase


% Inicializaciones
F=10.^(3:0.1:9); % Rango de frecuencias para el que queremos tener el espectro de PN

% Añado el ruido de fase a la señal y extraigo sus valores en el dominio
% temporal (pn)
tS_PN = add_phase_noise(tS_aux,F(end)*10,F,10*log10(Pot_PN));

% figure();
% set(figure(1),'Name','Espectro de ruido de fase')
% plot(0:2*2208-1,10*log10(abs(fftnorm(pn,length(pn),0.1)).^2))
% title('Espectro de ruido de fase')
% axis([0 2*2208-1 -100 25]);
% xlabel('N')
% ylabel('dB');
% grid on;


%% Representaciones

% % Represento el espectro de potencias
% figure(3)
% semilogx(F,10*log10(P0_low),clr_low,'LineWidth',1.5);
% hold on
% semilogx(F,10*log10(P0_high),clr_high,'LineWidth',1.5);
% xlabel('Hz');
% ylabel('dBc');
% title('Phase noise spectrum');
% legend('Low PN','High PN');
% grid

end


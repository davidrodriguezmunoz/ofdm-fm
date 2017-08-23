function tS_CAZAC=introCAZAC(tS_d,CAZAC)
% Función para introducir la señal de Constant Amplitude Zero 
% Autocorrelation (CAZAC) en la señal discreta
%
% Entradas:
%  - tS_d: Señal discreta a la que añadir el CAZAC
%  - CAZAC: Secuencia de CAZAC
%
% Salidas:
%  - tS_CAZAC: Señal a la que se ha añadido el CAZAC

% Añado la secuencia al principio de la señal
tS_CAZAC = vertcat(CAZAC,tS_d);

end


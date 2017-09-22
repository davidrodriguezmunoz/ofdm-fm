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
tS_CAZAC=cell(1,min(size(tS_d)));
for i=1: length(tS_d)
    tS_CAZAC{1,i}=[tS_d{1,i}(:).' CAZAC(:).'];
end

end


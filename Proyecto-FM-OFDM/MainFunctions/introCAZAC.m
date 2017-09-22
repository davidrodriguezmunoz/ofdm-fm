function tS_CAZAC=introCAZAC(tS_d,CAZAC)
% Funci�n para introducir la se�al de Constant Amplitude Zero 
% Autocorrelation (CAZAC) en la se�al discreta
%
% Entradas:
%  - tS_d: Se�al discreta a la que a�adir el CAZAC
%  - CAZAC: Secuencia de CAZAC
%
% Salidas:
%  - tS_CAZAC: Se�al a la que se ha a�adido el CAZAC

% A�ado la secuencia al principio de la se�al
tS_CAZAC=cell(1,min(size(tS_d)));
for i=1: length(tS_d)
    tS_CAZAC{1,i}=[tS_d{1,i}(:).' CAZAC(:).'];
end

end


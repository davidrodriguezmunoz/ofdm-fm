function rS_d = elimCAZAC(rS_CAZAC,longCZ)
% Funci�n para eliminar la se�al de Constant Amplitude Zero 
% Autocorrelation (CAZAC) de la se�al. Una vez conocida la longitud del 
% CAZAC se puede eliminar de forma directa.
%
% Entradas:
%  - rS_CAZAC: Se�al discreta recibida a la que quitar el CAZAC
%  - longCZ: Longitud del CAZAC
%
% Salidas:
%  - rS_d: Se�al discreta sin CAZAC

% Elimino el CAZAC de la se�al
rS_d = rS_CAZAC(longCZ+1:end,:);

end


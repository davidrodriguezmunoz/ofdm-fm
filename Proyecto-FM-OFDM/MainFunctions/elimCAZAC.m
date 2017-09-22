function rS_d = elimCAZAC(rS_CAZAC,longCZ)
% Función para eliminar la señal de Constant Amplitude Zero 
% Autocorrelation (CAZAC) de la señal. Una vez conocida la longitud del 
% CAZAC se puede eliminar de forma directa.
%
% Entradas:
%  - rS_CAZAC: Señal discreta recibida a la que quitar el CAZAC
%  - longCZ: Longitud del CAZAC
%
% Salidas:
%  - rS_d: Señal discreta sin CAZAC

% Elimino el CAZAC de la señal
rS_d=cell(1,min(size(rS_CAZAC)));
for i=1:length(rS_CAZAC)
  
  rS_d{1,i} = rS_CAZAC{1,i}(longCZ+1:end);
end


end


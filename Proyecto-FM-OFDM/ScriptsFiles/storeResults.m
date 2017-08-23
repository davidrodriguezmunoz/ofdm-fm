function storeResults(sim,results)
% Almacena los resultados de la simulación en un fichero
%
%   - sim: Estructura de la simulación
%   - results: Array del tipo:
%               [BER,BLER,codBER,codBLER]

BER = results(1);
BLER = results(2);
if sim.codificar
    codBER = results(3);
    codBLER = results(4);
end

pathName = 'ResultsFiles/';
nameFile = nameResultsFile(sim);
nameFile = [pathName,nameFile];

f1=fopen(nameFile,'a');
if sim.codificar
    fprintf(f1,'%6s %12s %12s\n','snr','BER','BLER');
    fprintf(f1,'%6.1f %12.6E %12.5E\n',sim.iSNR,codBER,codBLER);
else
    fprintf(f1,'%6s %12s %12s\n','snr','BER canal','BLER canal');
    fprintf(f1,'%6.1f %12.6E %12.5E\n',sim.iSNR,BER,BLER);
end
fclose(f1);


end


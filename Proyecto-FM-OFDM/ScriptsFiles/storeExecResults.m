function storeExecResults(sim,results,nBlocks,nBlocksErr)
% Almacena los resultados del estado de ejecución de la simulación en un 
% fichero
%
%   - sim: Estructura de la simulación
%   - results: Array del tipo:
%               [BER,BLER,codBER,codBLER]
%   - nblocks: Número de bloques que se han ejecutado

BER = results(1);
BLER = results(2);
if sim.codificar
    codBER = results(3);
    codBLER = results(4);
end

pathName = 'ExecutionFiles/';
nameFile = [pathName,'Estado-',nameResultsFile(sim)];
f1 = fopen(nameFile,'w');
fprintf(f1,['SNR=',num2str(sim.iSNR),' nblocks=',num2str(nBlocks),...
            ' ErrBlock=',num2str(nBlocksErr),' BERcanal=',num2str(BER),...
            ' BLERcanal=',num2str(BLER),'\n']);
if sim.codificar
    fprintf(f1,[' BERcod=',num2str(codBER),' BLERcod=',num2str(codBLER),'\n']);
end
fclose(f1);

end


function [ tS_sync ] = introOFFSET_SYNC( tS, offset_sync )
    %desplazar la señal tanto como el offset de sync
    tS_sync=[tS(offset_sync+1:end);zeros(offset_sync,1)];

end


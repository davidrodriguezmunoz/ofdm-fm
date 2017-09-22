function [ tS_sync ] = introOFFSET_SYNC( tS, offset_sync )
    %introducir a la señal un offset de sync
    if iscolumn(tS)
        tS_sync=[tS(offset_sync+1:end);zeros(offset_sync,1)];
    elseif isrow(ts)
        tS_sync=[tS(offset_sync+1:end) zeros(1,offset_sync)];
    else
        error('error al usar la funcion introOFFSET_SYNC')
    end

end


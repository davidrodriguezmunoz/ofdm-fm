function seq = pilotGen(seqLength)
% Genera una secuencia de pilotos de la longitud especificada

enb = lteRMCDL('R.6');
enb.NDLRB = 100;    % 100 Resource Blocks correspondientes a 1200 portadoras activas
enb.TotSubframes=1;
sym = lteCellRS(enb);   % Símbolos de la secuencia
seq = sym(1:seqLength);

end


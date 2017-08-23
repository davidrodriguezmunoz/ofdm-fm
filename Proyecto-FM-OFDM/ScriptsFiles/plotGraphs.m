function ind = plotGraphs(graphName,SNR,vSNR,BER,codBER,codBLER)
% Representa las gráficas necesarias
codificar = codBER(1) == 0;

% Representación
ind = 1;
figure(ind)
semilogy(SNR,BER,'r-X'); % BER sin codificacion
hold on;
if codificar
    semilogy(SNR,codBER,'g-s');   % BER codificada
    h1=semilogy(SNR,codBLER,'m'); % BLER codificada
    set(h1,'linewidth',1.5)
end
hold off;

% Ajuste de ejes y otros parámetros
set(gcf,'Name',graphName)
set(gcf,'Position',[40 500 600 400]);
axis tight;
xlim([vSNR(1) vSNR(end)]);
if ~codificar
    ylim([min(BER) 1]);
else
    ylim([min([codBER BER]) 1]);
end
title(graphName);
ylabel('BER & BLER');
xlabel('SNR (dB)');
if codificar
    legend('BER simulation','BER uncoded','BLER uncoded','Location','SouthWest');
else
    legend('BER simulation','Location','SouthWest');
end
grid on;
drawnow();

end


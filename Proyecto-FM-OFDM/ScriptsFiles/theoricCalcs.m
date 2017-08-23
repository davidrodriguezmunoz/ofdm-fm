function [BERteo,BLERteo] = theoricCalcs(sim)
% C�lculos te�ricos de OFDM

% Extraci�n de datos del objeto
modo=sim.modo;
efecto=sim.efecto;
SNR=sim.vSNR;
Nsc=sim.Nsc;
Nsb=sim.Nsb;

% C�lculo de la longitud del bloque f�sico
longB=blockgen(modo,Nsc,Nsb);

% C�lculos
L=log2(modo);
ebno = SNR - 10*log10(L);
BERteo=berawgn(ebno,'qam',modo);        %Gauss
BERteoR=berfading(ebno,'qam',modo,1);   %Rayleigh
BLERteo=1-((1-BERteo).^longB);   

% Ajusto la BER devuelta en funci�n del efecto utilizado
if strcmp('CH',efecto)
    BERteo = BERteoR;
end

if modo == 4
    modo = 'QPSK';
elseif modo == 16
    modo = '16QAM';
else
    modo = '64QAM';
end

% Almaceno los resultados te�ricos
f1=fopen(['ResultsFiles/OFDM te�rico ', modo, ' ',efecto,'.txt'],'w');
for n=1:length(SNR)
    fprintf(f1,'%6s %12s %12s\n','snr','BER canal','BLER canal');
    fprintf(f1,'%6.1f %12.6E %12.5E\n',SNR(n),BERteo(n),BLERteo(n));
end
fclose(f1);

end
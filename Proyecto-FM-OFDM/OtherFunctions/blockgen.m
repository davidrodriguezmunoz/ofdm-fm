function longB=blockgen(modo,N,Nsb)
% Generador del tama�o de bloque f�sico (longB) para el proyecto OFDM-FM. 
% Depende de la modulaci�n usada (modo) y el n�mero de portadoras N que
% contienen informaci�n (Na-2*k0). El n�mero de bloques por s�mbolo es Nsb

longB = log2(modo)*N*Nsb;

end
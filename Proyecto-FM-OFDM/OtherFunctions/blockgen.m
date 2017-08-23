function longB=blockgen(modo,N,Nsb)
% Generador del tamaño de bloque físico (longB) para el proyecto OFDM-FM. 
% Depende de la modulación usada (modo) y el número de portadoras N que
% contienen información (Na-2*k0). El número de bloques por símbolo es Nsb

longB = log2(modo)*N*Nsb;

end
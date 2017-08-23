% function dSr=QPSKdemod(rX,Nsc,snr)
% %   QPSKdemod Demodula QPSK según el estandar 3GPP para LTE
% %
% %   rX    - simbolos de entrada
% %   Nsc   - N de portadoras de datos
% %
% dSr=[];
% rX=rX*sqrt(2);
% for s=1:Nsc
%     if real(rX(s))>0 && imag(rX(s))>0
%         dSr=[dSr 0 0];
%     elseif real(rX(s))>0 && imag(rX(s))<0
%         dSr=[dSr 0 1];
%     elseif real(rX(s))<0 && imag(rX(s))>0
%         dSr=[dSr 1 0];
%     elseif real(rX(s))<0 && imag(rX(s))<0
%         dSr=[dSr 1 1];
%     end
% end
% end


function dSr=QPSKdemod(rX,Na)
%   QPSKdemod Demodula QPSK según el estandar 3GPP para LTE. La salida son
%   los LLR de bit en forma de vector columna
% 
%   rX    - simbolos complejos de entrada
%   Nsc  - nº portadoras totales
%   Na   - N de portadoras de datos
%   snr   - SNR (dB)
%   H     - respuesta en frecuencia
% 

% representaciones en binario QPSK (sumadas 1 para indexar)
b00 = 1;
b01 = 2;
b10 = 3;
b11 = 4;

dSr=zeros(2*Na, 1);
c = 1/sqrt(2);
rX=rX/c;
aux1 = [1 1 -1 -1];     % parte real de los símbolos de la constelación 00, 01, 10, 11
aux2 = [1 -1 1 -1];     % parte imaginaria de los símbolos de la constelación 00, 01, 10, 11

%% Cálculo de la potencia de ruido

% % Primer bucle. Calculo las distancias a todos los símbolos y me quedo con
% % la mínima.
% for s=1:Na
%     % Calculo la distancia cuadrática a todos los símbolos de la
%     % constelación
%     dcuad = (real(rX(s))*c-aux1*c).^2 + (imag(rX(s))*c-aux2*c).^2; 
%     % Me quedo con la mínima
%     min_dist(s) = min(dcuad);
% end

% Cálculo de la distancia a todos los símbolos
rX = repmat(rX,1,4);
aux1=repmat(aux1,Na,1);
aux2=repmat(aux2,Na,1);
dcuad=(real(rX)-aux1).^2+(imag(rX)-aux2).^2;
dcuad_simb =(c^2)*dcuad;
min_dist = min(dcuad_simb,[],2);

% Cálculo de la media de las mínimas distancias, que será la potencia de ruido
N_AWGN = mean(min_dist);

%% Demodulación y recuperación de los bits

N_post = N_AWGN;

% bit 0
min_0 = min( dcuad(:,b00), dcuad(:,b01) );
min_1 = min( dcuad(:,b10), dcuad(:,b11) );
lambda_0 = (min_1-min_0)/N_post;

% bit 1
min_0 = min( dcuad(:,b00), dcuad(:,b10) );
min_1 = min( dcuad(:,b01), dcuad(:,b11) );
lambda_1 = (min_1-min_0)/N_post;

dSr(1:2:end-1) = lambda_0;
dSr(2:2:end) = lambda_1;

% % Segundo bucle. Se demodula y se recuperan los bits.
% for s=1:Na
%     dcuad = (real(rX(s))-aux1).^2 + (imag(rX(s))-aux2).^2;
% %    indice = (Nsc-Na)/2 + s + (s > Na/2);
% %    N_post = N_AWGN / (H(indice)*H(indice)');   % ruido de post-detección con ZF
%     N_post = N_AWGN; 
% 
%     %bit 0
%     min_0 = min( dcuad(b00), dcuad(b01) );
%     min_1 = min( dcuad(b10), dcuad(b11) );
%     lambda_0=(min_1-min_0)/N_post;
%     
%     %bit 1
%     min_0 = min( dcuad(b00), dcuad(b10) );
%     min_1 = min( dcuad(b01), dcuad(b11) );
%     lambda_1=(min_1-min_0)/N_post;
%     
%     dSr(2*(s-1)+1) = lambda_0;
%     dSr(2*(s-1)+2) = lambda_1;
% end

end


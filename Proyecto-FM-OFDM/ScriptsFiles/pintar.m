clc;
clear;
close all;

v_vector=[ 250];
m_vector={'QPSK'};


% archivos_pintar=cell(1,2);
for m_aux=1:length(m_vector)
    for velocidad=v_vector
        modulacion=m_vector{m_aux};
%           text{2}='mmse canal awgn con dft';
        text{1}= 'mmse canal awgn sin dft';
%           text{3}='zfe canal awgn con dft';
%          text{4}= 'zfe canal awgn sin dft';

        for i=1:length(text)
            
            archivos_pintar{i}=['FM ',modulacion,' ',num2str(velocidad),' kmh Eq ',text{i}];

        end
        colorVec = hsv(length(archivos_pintar));
        figure;

        BER_Vect=[];
        for i=1:length(archivos_pintar)
            
            [SNR,BER]=importfile([archivos_pintar{1,i},'.txt']);
             BER_Vect=[BER_Vect BER' ];
            h=semilogy(SNR,BER,'-X','Color',colorVec(i,:)); % BER sin codificacion
            set(h,'linewidth',1.5)
            leg_vec{i}=['equalizacion ' text{1,i}];
            hold on;
            
                
            
        end
        ylim([min(BER_Vect) 1]);
        legend(leg_vec);
        title(['FM-OFDM ', num2str(velocidad),' kmh ', modulacion]);
    end
end
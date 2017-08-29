clc;
clear;
close all;

v_vector=[50 120 250 500];
m_vector{1}='QPSK';m_vector{2}='16QAM';m_vector{3}='64QAM';


% archivos_pintar=cell(1,2);
for m_aux=1:length(m_vector)
    for velocidad=v_vector
        modulacion=m_vector{m_aux};
        text{1}='mmse con dft';
        text{2}= 'mmse sin dft';
        text{3}='zf con dft';
        text{4}= 'zf sin dft';

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
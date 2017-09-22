function [ output ] = channelEq( h_n_matrix,rx_matrix,L,SNR,type,Nsb)
%% Equalización del canal

output=zeros(size(rx_matrix));
N0=1/(10^(SNR/10));

 
 for simbolo=1:Nsb 
    rx=rx_matrix(:,simbolo).';
    h_n=h_n_matrix(simbolo,:);
    h_f=fft([h_n zeros(1,abs(length(h_n)-max(size(rx_matrix))))]); 
    rx_f=fft(rx);
    
    
    if strcmp(type,'mmse')
%         h_f_mmse=conj(h_f)./(h_f.*conj(h_f) + N0);
%         rx_rec_mmse=(ifft(rx_f.*h_f_mmse));
        h_n=[h_n zeros(1,abs(length(h_n)-max(size(rx_matrix))))];
        output(:,simbolo)=rx_rec_mmse(1:L).';
    elseif strcmp(type,'zfe');  
        h_f_zfe=1./h_f;
        rx_rec_zfe=(ifft(rx_f.*h_f_zfe));
        output(:,simbolo)=rx_rec_zfe(1:L).';
        
    elseif strcmp(type,'none')
        output(:,simbolo)=rx(1:L);
   
    else
      
       error('error en la eleccion del tipo de equalizacion, las opciones pueden ser zfe, mmse o none')
     
    end    

 end

end


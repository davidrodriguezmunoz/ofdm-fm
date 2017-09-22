function [ output ] = channelEq( h_n_matrix,rx_matrix,L,SNR,type,Nsb)
%% Equalización del canal

output=zeros(size(rx_matrix));
N0=1/(10^(SNR/10));

 
 for simbolo=1:Nsb 
    rx=rx_matrix(:,simbolo).';
    h_n=[ h_n_matrix(simbolo,:) zeros(1,abs(length(h_n_matrix(simbolo,:))-L))];
    h_f=fftshift(fft(h_n));
%      rx_f=fft(rx);
%      h_f_norm=fftnorm(h_n,length(h_f),2); 
     rx_f_norm=fftnorm(rx,L,2);
    
    
    if strcmp(type,'mmse')
%          median_hfsq=median(conj(h_f).*h_f);
%         h_f_mmse=(median_hfsq/(median_hfsq + N0))*h_f;
%         h_f_mmse=1./h_f_mmse;
        h_f_mmse=conj(h_f)./(h_f.*conj(h_f) + N0);
        rx_rec_mmse=ifftnorm(rx_f_norm.*h_f_mmse,L,2);
        output(:,simbolo)=rx_rec_mmse(1:L).';
    elseif strcmp(type,'zfe');  
        h_f_zfe=1./h_f;
        rx_rec_zfe=ifftnorm(rx_f_norm.*h_f_zfe,L,2);
        output(:,simbolo)=rx_rec_zfe(1:L).';
        
    elseif strcmp(type,'none')
        output(:,simbolo)=rx(1:L);
   
    else
      
       error('error en la eleccion del tipo de equalizacion, las opciones pueden ser zfe, mmse o none')
     
    end    

 end

end


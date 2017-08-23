function [ H_matrix ] = channel_estimation( chan,Nssb,Nt,sampleR,speedKMH )
    %estimación del canal
    total_gains= chan.PathGains;
    path_delays=chan.PathDelays*sampleR+1; 
    H_matrix=zeros(Nssb,max(path_delays));
    
    
   
    %se estima mediante el primer dato que tenemos del canal
    for symbol=1:Nssb
        if(speedKMH>0)
            symbol_gains=total_gains((symbol-1)*Nt+1:symbol*Nt,:);
            caracteristic_gain=symbol_gains(1,:);
        else
            caracteristic_gain=total_gains;
        end
        
        for k=1:length(path_delays)
           H_matrix(symbol,path_delays(k))=H_matrix(symbol,path_delays(k))+caracteristic_gain(k);
        end
        
        
    end


end


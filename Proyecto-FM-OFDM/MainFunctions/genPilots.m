function [values, positions] = genPilots(Ndp)
% Genera los valores y las posiciones de los pilotos en función de si se
% introducen o no los pilotos

sequence = [1+1i,1-1i,-1+1i,-1-1i];

% positions
positions = (1:Ndp).';

% values
values = zeros(Ndp,1);
for i=positions-1
   val = sequence(mod(i,length(sequence))+1);
   values(i+1) = val;
end

end


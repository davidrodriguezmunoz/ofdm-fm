function [values, positions] = genPilots2(Na,len)
% Genera los valores y las posiciones de los pilotos en función de la
% longitud introducida

if nargin == 1
    beginning = 1;      % place pilots at the beginning
else
    beginning = 0;
end

sequence = [1+1i,1-1i,-1+1i,-1-1i];

% positions
if beginning
    positions = 1:len;
else
    positions = 1:Na/len:Na;
end
positions = round(positions.');

% values
values = zeros(len,1);
for i=1:len
   val = sequence(mod(i-1,length(sequence))+1);
   values(i) = val;
end

end


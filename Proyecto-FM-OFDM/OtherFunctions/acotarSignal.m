function y = acotarSignal(x,m)
% Funci�n que acota una se�al x entre m y -m. El resultado es y.

for i=1:size(x,2)
    for j=1:size(x,1)
       if abs(x(j,i)) > m
           x(j,i) = m*x(j,i)/abs(x(j,i));
       end
    end
end

y = x;

end


function storeGraph(indFig,nameFig)
% Almacena la figura que se le pasan en formato .jpg y .fig

% if length(indFig) ~= length(nameFig)
%     error('The number of elements of indFig and nameFig must be equal')
% end
% 
% numIterations = length(indFig);

pathName = 'ResultsFigures/';
nameFig = [pathName,nameFig];

% for i=1:numIterations
saveas(figure(indFig),nameFig,'fig');
saveas(figure(indFig),nameFig,'jpg');
% end

end
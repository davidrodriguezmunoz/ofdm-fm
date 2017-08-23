function dPm=QAMmod(dS,Nsc,M)
%   QAMmod Mapeo M-QAM según el estandar 3GPP para LTE
%
%   dS    - bitStream de entrada
%   Nsc   - N de portadoras (flujos de salida) de datos
%   M     - Tipo de modulación {16,64}
%
dPm=zeros(Nsc,1);
switch M
    case 16
        c = 1/sqrt(10);
        modI = [1 1 3 3 1 1 3 3 -1 -1 -3 -3 -1 -1 -3 -3];     % parte real de los símbolos de la constelación 0000 .. 1111
        modQ = [1 3 1 3 -1 -3 -1 -3 1 3 1 3 -1 -3 -1 -3];     % parte imaginaria de los símbolos de la constelación 0000 .. 1111

        ind = 8*dS(1:4:end-3) + 4*dS(2:4:end-2) + 2*dS(3:4:end-1) + dS(4:4:end) + 1;
        dPm = c*(modI(ind) + modQ(ind)*1i).';

%         for n=1:Nsc
%             ind = 8*dS(4*(n-1)+1) + 4*dS(4*(n-1)+2) + 2*dS(4*(n-1)+3) + dS(4*(n-1)+4) + 1;
%             dPm(n,1) = c*(modI(ind) + modQ(ind)*1i);
%         end
    case 64
        c = 1/sqrt(42);
        % parte real de los símbolos de la constelación 000000 .. 111111
        modI = [3 3 1 1 3 3 1 1 5 5 7 7 5 5 7 7 3 3 1 1 3 3 1 1 5 5 7 7 5 5 7 7 -3 -3 -1 -1 -3 -3 -1 -1 -5 -5 -7 -7 -5 -5 -7 -7 -3 -3 -1 -1 -3 -3 -1 -1 -5 -5 -7 -7 -5 -5 -7 -7];
        % parte imaginaria de los símbolos de la constelación 000000 .. 111111
        modQ = [3 1 3 1 5 7 5 7 3 1 3 1 5 7 5 7 -3 -1 -3 -1 -5 -7 -5 -7 -3 -1 -3 -1 -5 -7 -5 -7 3 1 3 1 5 7 5 7 3 1 3 1 5 7 5 7 -3 -1 -3 -1 -5 -7 -5 -7 -3 -1 -3 -1 -5 -7 -5 -7];
 
        ind = 32*dS(1:6:end-5) + 16*dS(2:6:end-4) + 8*dS(3:6:end-3) + 4*dS(4:6:end-2) + 2*dS(5:6:end-1) + dS(6:6:end) + 1;
        dPm = c*(modI(ind) + modQ(ind)*1i).';

%         for n=1:Nsc
%             ind = 32*dS(6*(n-1)+1) + 16*dS(6*(n-1)+2) + 8*dS(6*(n-1)+3) + 4*dS(6*(n-1)+4) + 2*dS(6*(n-1)+5) + dS(6*(n-1)+6) + 1;
%             dPm(n,1) = c*(modI(ind) + modQ(ind)*1i);
%         end
    otherwise
        disp('Modulación no válida');
        return
end
end
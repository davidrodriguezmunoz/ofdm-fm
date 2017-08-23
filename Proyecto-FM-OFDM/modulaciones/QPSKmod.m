function dPm=QPSKmod(dS)
%   QPSKmod Mapeo QPSK según el estandar 3GPP para LTE
%
%   dS    - bitStream de entrada
%   Nsc   - N de portadoras (flujos de salida)
%

dS(dS==1) = -1;
dS(dS==0) = 1;
dPm = (dS(1:2:end-1)+1i*dS(2:2:end)).'/sqrt(2);

% dPm=zeros(Nsc,1);
% for n=1:Nsc
%     bit1 = dS(2*(n-1)+1);
%     bit2 = dS(2*(n-1)+2);
%     if bit1==0 && bit2==0
%         dPm(n,1)=1+1i;
%     elseif bit1==0 && bit2==1
%         dPm(n,1)=1-1i;
%     elseif bit1==1 && bit2==0
%         dPm(n,1)=-1+1i;
%     elseif bit1==1 && bit2==1
%         dPm(n,1)=-1-1i;
%     end
% end
% dPm=dPm/sqrt(2);

end
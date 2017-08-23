function [rXout,lag,lag2] = estPhaseProg(rXin,pilots,posPil,Nsc,k0,Nd)
% Estimación y compensación de la fase progresiva


Nsb = size(rXin,2);
Nps = length(posPil);

% Extracción de los pilotos
rXpil = rXin(Nsc/2+k0+2:Nsc/2+k0+Nd+Nps+1,1);

% Cálculo de la fase
phi = angle(rXpil);

% Extracción de la fase de los pilotos
phasePilRx = phi(posPil);
phasePilTx = angle(pilots);

% Estimación la fase progresiva
phaseProg = phasePilRx-phasePilTx;
unwPhProg = unwrap(phaseProg);

n = [ones(length(posPil),1) posPil];
b = n \ unwPhProg;
I = b(1); m = b(2);  %vI se ignora puesto que empezara en DC

% figure;plot(n(:,2),unwPhProg(:,2));hold on;plot(n(:,2),n(:,2)*vM(2),'r');
% t2 = 1:length(rXdata);
% figure;plot(t2,phi(:,2));hold on;plot(t2,t2*vM(2),'r');

% Compensación de la fase progresiva
t = repmat([Nsc/2:Nsc-1 0:Nsc/2-1].',1,Nsb);
vM = repmat(m,Nsc,Nsb);
rXout = rXin.*exp(-1i*vM.*t);

% Cálculo del offset de retardo en función de la pendiente
lag = -m*Nsc/(2*pi);

%% Lags con 25 pilotos

pil = pilots(1:10:250);
phasePilRx2 = phi(1:10:250);
phasePilTx2 = angle(pil);
phaseProg2 = phasePilRx2-phasePilTx2;
unwPhProg2 = unwrap(phaseProg2);
n = [ones(length(1:10:250),1) [1:10:250].'];
b = n \ unwPhProg2;
I = b(1); m2 = b(2);
lag2 = -m2*Nsc/(2*pi);

vM2 = repmat(m,Nsc,Nsb);
rXout = rXin.*exp(-1i*vM2.*t);

end


function [rXout,lag] = estPhaseProg2(rXin,pilots,posPil,Nsc,k0,Nd,dft)
% Estimaci�n y compensaci�n de la fase progresiva


Nsb = size(rXin,2);
Nps = length(posPil);
Ndp = Nd+Nps;

% Extracci�n de la parte de informaci�n
rXdata = rXin(Nsc/2+k0+2:Nsc/2+k0+Ndp+1,:);

% IFFT adicional en el caso de que se hiciera en transmisi�n
if dft
    for ind = 1:Nsb
        rXdata(:,ind) = ifftnorm(rXdata(:,ind),Ndp);
    end
end

% C�lculo de la fase
phi = angle(rXdata);

% Extracci�n de la fase de los pilotos
phasePilRx = phi(posPil,:);
phasePilTx = repmat(angle(pilots),1,Nsb);

% Estimaci�n la fase progresiva
phaseProg = phasePilRx-phasePilTx;
unwPhProg = unwrap(phaseProg);

n = [ones(length(posPil),1) posPil];
vM = zeros(1,size(rXdata,2));
for i=1:Nsb
    b = n \ unwPhProg(:,i);
    vI(i) = b(1); vM(i) = b(2);  %vI se ignora puesto que empezara en DC
end
% figure;plot(n(:,2),unwPhProg(:,2));hold on;plot(n(:,2),n(:,2)*vM(2),'r');
% t2 = 1:length(rXdata);
% figure;plot(t2,phi(:,2));hold on;plot(t2,t2*vM(2),'r');

% Compensaci�n de la fase progresiva
t = repmat([Nsc/2:Nsc-1 0:Nsc/2-1].',1,Nsb);
m = repmat(vM,Nsc,1);
rXout = rXin.*exp(-1i*m.*t);

% C�lculo del offset de retardo en funci�n de la pendiente
lag = -vM*Nsc/(2*pi);

end


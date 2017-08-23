function P0 = GenerarPotenciaPN(fc)
% funcion GenerarPotenciaPN.m
%
% Genera la potencia del espectro de ruido de fase P0 a partir de una
% frecuencia de portadora fc. 

% Inicializaciones
F=10.^(3:0.1:9); % Rango de frecuencias para el que queremos tener el espectro de PN
P0=zeros(size(F));

% Divido el espectro en dos partes (una hasta 1MHz, otra a partir de eso)
ix_lower=find(F<1e6); 
ix_higher=find(F>=1e6);
Navg=10;

% First we focus on the higher part of the spectrum. 
Ns=30e5; %% Number of samples per run.

% Ts = 1/10*frec mayor del espectro a modelar
Ts=inv(1e10);
% Hay dos clases, cada una basada en un tipo de oscilador. Uno tiene poco
% ruido de fase ('low') y otro alto ruido de fase ('high').
% Hay una parte donde se definen los parámetros de cada oscilador. Se
% definen los del oscilador de referencia, los del VCO y los del PLL.
m=phase_noise_class('high',fc,Ts); % Rakon RPT7050A 

% Calculo el espectro del ruido de fase promediado en Navg realizaciones
for i1=1:Navg

    p0=m.generate_phase_noise(Ns);
    
    P=m.plotting_phase_noise(p0,Ts,F(ix_higher));

    P0(ix_higher)=P0(ix_higher)+P;
        
end;

P0(ix_higher)=P0(ix_higher)/Navg;

% Now we focus on the lower part of the spectrum.
Ns=30e5; %% Number of samples per run.

Ts=inv(1e7);
m=phase_noise_class('high',fc,Ts);

for i1=1:Navg
    
    p0=m.generate_phase_noise(Ns);
    
    P=m.plotting_phase_noise(p0,Ts,F(ix_lower));

    P0(ix_lower)=P0(ix_lower)+P;
        
end;

P0(ix_lower)=P0(ix_lower)/Navg;


end


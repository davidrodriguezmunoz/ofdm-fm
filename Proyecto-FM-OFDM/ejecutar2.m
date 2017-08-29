clc;
clear;
close all;
borrado=input('Presiione 1 si quieres eliminar todo lo de la carpeta ResultFiles y ResultsFigures:');

if borrado==1
    recycle('on');
    delete('.\ResultsFiles\*.txt')
    delete('.\ResultsFigures\*')
    delete('.\ExecutionFiles\*');
end

speed=[ 5 50 120 250 500 ];
dft=0;
% QPSK
for k=1:length(speed);
    variacionSNR('QPSK',0,'separados',{'CH'},dft,0,speed(k),'mmse');
    close all;
end

for k=1:length(speed);
    variacionSNR('QPSK',0,'separados',{'CH'},dft,0,speed(k),'zfe');
     close all;
end

 dft=1;
for k=1:length(speed);
    variacionSNR('QPSK',0,'separados',{'CH'},dft,0,speed(k),'mmse');
    close all;
end

for k=1:length(speed);
    variacionSNR('QPSK',0,'separados',{'CH'},dft,0,speed(k),'zfe');
     close all;
end

% 16QAM
dft=0;
for k=1:length(speed);
    variacionSNR('16QAM',0,'separados',{'CH'},dft,0,speed(k),'mmse');
    close all;
end

for k=1:length(speed);
    variacionSNR('16QAM',0,'separados','CH',dft,0,speed(k),'zfe');
     close all;
end

dft=1;
for k=1:length(speed);
    variacionSNR('16QAM',0,'separados','CH',dft,0,speed(k),'mmse');
    close all;
end

for k=1:length(speed);
    variacionSNR('16QAM',0,'separados','CH',dft,0,speed(k),'zfe');
     close all;
end

% 64QAM

dft=0;
for k=1:length(speed);
    variacionSNR('64QAM',0,'separados','CH',dft,0,speed(k),'mmse');
    close all;
end

for k=1:length(speed);
    variacionSNR('64QAM',0,'separados','CH',dft,0,speed(k),'zfe');
     close all;
end

dft=1;
for k=1:length(speed);
    variacionSNR('64QAM',0,'separados','CH',dft,0,speed(k),'mmse');
    close all;
end

for k=1:length(speed);
    variacionSNR('64QAM',0,'separados','CH',dft,0,speed(k),'zfe');
     close all;
end



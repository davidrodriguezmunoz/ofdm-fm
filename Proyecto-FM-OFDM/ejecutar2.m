clc;
clear;
close all;
borrado=input('Presiione 179 si quieres eliminar todo lo de la carpeta ResultFiles y ResultsFigures:');

if borrado==179
    recycle('on');
    delete('.\ResultsFiles\*.txt')
    delete('.\ResultsFigures\*')
    delete('.\ExecutionFiles\*');
end

speed_aux=[120 250 500];
modulacion_aux={'QPSK'};
ecualizacion_aux={'mmse'};
dft_aux=[0 1];


    for modulacion=modulacion_aux
        for ecualizacion=ecualizacion_aux
            for speed=speed_aux
                for dft=dft_aux
                    variacionSNR(modulacion{1},0,'separados',{'CH'},dft,0,speed,ecualizacion{1},0.1);
                end
            end
        end
    end
    
    
    speed_aux=[50 120 250 500];
modulacion_aux={'16QAM'};
ecualizacion_aux={'zfe','mmse'};
dft_aux=[0 1];


    for modulacion=modulacion_aux
        for ecualizacion=ecualizacion_aux
            for speed=speed_aux
                for dft=dft_aux
                    variacionSNR(modulacion{1},0,'separados',{'CH'},dft,0,speed,ecualizacion{1},0.1);
                end
            end
        end
    end
   

        
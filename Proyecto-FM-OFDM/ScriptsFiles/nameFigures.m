function f_name= nameFigures(sim,thr,introducir_path)
% Crea el nombre de las graficas

% Extracción de datos del objeto
speedKMH = sim.speedKMH;
tipo = sim.tipo;
efecto = sim.efecto;
modo = sim.modo;
codificar = sim.codificar;
dft = sim.dft;
eq_type= sim.eq_type;

if modo == 4
    modo = 'QPSK';
elseif modo == 16
    modo = '16QAM';
else
    modo = '64QAM';
end

% Si no se pasa el argumento introducir_path, lo asigno el valor 0
if nargin == 1
    thr = 0;
    introducir_path = 0;
elseif nargin==2
    introducir_path=0;
end

txt_thr = '';
if thr
    txt_thr = 'Throughput ';
end

% Genero el path a partir de los argumentos
if introducir_path
    path = 'graficas/';
else
    path = '';
end

% Si se usa codificación, habrá que indicarlo en el nombre
if codificar
    txt_cod = 'codificado ';
else
    txt_cod = '';
end

% En función del efecto se mostrará un texto u otro
txt_efecto = '';
if max(strcmp(efecto,'CH')) || max(strcmp(tipo,'juntos'))
     txt_efecto1 = [num2str(speedKMH), ' kmh'];
     txt_efecto2= [' ', 'Eq ',eq_type,' canal awgn'];
     txt_efecto=[txt_efecto1,txt_efecto2];
elseif max(strcmp(efecto,'NO'))
    txt_efecto = ' canal AWGN';
    
end

if max(strcmp(efecto,'PN'))
    txt_efecto = [txt_efecto,', con PN'];
end

if max(strcmp(efecto,'CFO'))
    txt_efecto = [txt_efecto,', con CFO'];
end

if max(strcmp(efecto,'OFFSET'))
    txt_efecto = [txt_efecto,', con offset de sinc '];
end

%con dft o sin dft
txt_dft = ' sin dft';
if dft
    txt_dft = ' con dft';
end


% Concateno todos los textos para formar el nombre de la gráfica
if strcmp(tipo,'juntos')
    f_name = [path, txt_thr, 'FM ', txt_cod, modo, ' todos los efectos ', txt_efecto,txt_dft];
else
    f_name = [path, txt_thr, 'FM ', txt_cod, modo, ' ', txt_efecto,txt_dft];
end
    
end
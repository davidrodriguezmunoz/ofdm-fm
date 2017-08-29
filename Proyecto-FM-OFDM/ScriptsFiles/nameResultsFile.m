function f_name= nameResultsFile(sim)
% Crea el nombre del fichero de resultados

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


% Si se usa codificación, habrá que indicarlo en el nombre
txt_cod = '';
if codificar
    txt_cod = 'codificado ';
end

% Para la dft
txt_dft = ' sin dft';
if dft
    txt_dft = ' con dft';
end

posPil = sim.posPil;
if isempty(posPil)
    txt_pil='';
else
    txt_pil = ['pilotos ',num2str(posPil(1)),' ',num2str(posPil(end)),' '];
end

% Concateno todos los textos para formar el nombre del fichero
if strcmp(tipo,'juntos')
    f_name = ['FM ', txt_cod, modo, ' todos los efectos ', txt_efecto, txt_dft, '.txt'];
else
    f_name = ['FM ', txt_cod, modo, ' ', txt_pil, txt_efecto, txt_dft, '.txt'];
    %f_name = ['FM ', txt_cod, modo, ' ', txt_efecto, txt_dft, '.txt'];
end

end


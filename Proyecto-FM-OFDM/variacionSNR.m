function []=variacionSNR(modo,codificar,tipo,efecto,dft,sinc,speed,eq_type,TTI)
% Script variacionSNR
%
% Argumentos de entrada:
%
%  - modo: Modulaci�n utilizada. Puede ser 'QPSK','16QAM' o '64QAM'.
%  - codificar: Indica si se realizan o no los c�lculos de codificaci�n.
%               Puede valer 0 � 1.
%  - tipo: Aplicar todos los efectos o uno en particular. Para que se 
%    apliquen todos hay que poner 'juntos', para uno solo 'separados'.
%  - efecto: Tipo de efecto a aplicar. Puede ser: 
%           o 'NO':  Aplicar s�lo un AWGN.
%           o 'PN':  Aplicar un ruido de fase.
%           o 'CFO': Aplica un offset a la frecuencia de portadora. Valor 
%                    por defecto de 7.5 KHz.
%           o 'CH': Pasa la se�al por un canal Rayleigh. Al iniciar la 
%                   simulaci�n se pedir� el valor de la velocidad.
%  - dft: Indica si se usa la DFT adicional (1) o no (0).
%  - sinc: Indica si se realiza sincronismo (1) o no (0).
%  - speed: Indica la velocidad a la que se mueve el usuario. 
%  - eq_type: Indica el tipo de equalizacci�n.
 % -TTI: Transmision Time Interval (ms)
% Los par�metros de la simulaci�n se modifican en este script.
%
% Ejemplo de uso:
%       variacionSNR('16QAM',0,'separados','CH',0);

close all;

addpath('./ScriptsFiles')
addpath('./OtherFunctions')
addpath('./MainFunctions')
addpath('./modulaciones');

rng('shuffle','twister');           % Inicializaci�n del generado

%% Comprobaci�n de los argumentos de entrada y lectura de valores necesarios

% Compruebo el n�mero de argumentos introducidos
narginchk(3,9);

% Si se introduce solo un argumento asigno el valor por defecto
switch nargin
    case 3
        efecto='NO';
        dft = ~strcmp(modo,'QPSK'); % En QPSK dft=0, dft=1 en el resto
        sinc = 0;
    case 4
        dft = ~strcmp(modo,'QPSK'); % En QPSK dft=0, dft=1 en el resto
        sinc = 0;
    case 5
        sinc = 0;
end


% Comprueba que se hayan introducido correctamente los argumentos
if ~exist('speed','var')
    speed=-1;
end
if ~exist('eq_type','var')
    eq_type='no equalization written';
end
if ~exist('TTI','var')
    TTI=1;
end
checkArgs(tipo,efecto,modo,speed,eq_type);

% Comprueba que existan los directorios para guardar los resultados
checkFolders();

% Leo el valor de velocidad en los casos que se requiera
if strcmp(tipo,'juntos') || sum(strcmp(efecto,'CH'))==1
%     speedKMH = input('Introduce el valor de la velocidad (km/h): ');
      speedKMH=speed;
else
    speedKMH=0;
end

% Ajuste de las variables de modulaci�n para eliminar los strings
switch modo
    case 'QPSK'
        modo = 4;
    case '16QAM'
        modo = 16;
    otherwise
        modo = 64;
end

%% Par�metros de la simulaci�n

% Valores globales de la tecnolog�a
blockErSim = 400;                             % Bloques erroneos a simular (Para Rayleigh se recomiendan 400, para Gauss 200)
SNR = 0:3:28;       % [primSNR:step:ultSNR] para simulaci�n (dB)
tau = (1e-9)*[0 30, 70, 90, 115, 190]%, %410];   % Perfil de retardos del canal Rayleigh (s)
pdb = [0 -1, -2, -3, -8, -17.2]%, -20.8];       % Perfil de amplitudes del canal Rayleigh
r = 1;                                        % Factor de sobremuestreo
fc = 3.5e9;                                    % Frecuencia de la portadora (10 GHz)
Nsc=r*2048;                                   % Longitud IFFT (subportadoras) por simbolo
k0 = 1;                                       % Subportadora de corte
Ndp = 250;                                     % N�mero de portadoras de datos y pilotos
Na=2*(Ndp+k0);                               % N�mero de portadoras activas
Nsb=14;                                       % N�mero de s�mbolos por bloque
normalizar = 1;                               % Normalizaci�n de las subportadoras
mList = [0.33,0.3];                           % Lista de posibles valores de m
m = mList(dft+1);                             % Valor de m
longCP = ones(1,Nsb)*144;                     % Vector de longitudes del prefijo c�clico
longCP([1 8])=160;                            %LTE s�mbolo 0 y 7 tienen longitud CP de 160
longCAZAC = 0;                                % Vector de longitudes del CAZAC
Npb = 0;                                      % N�mero de s�mbolos dedicados a pilotos por bloque
eq_type=eq_type;                              %tipo de equalizacion
ventanaCP=longCP/2;                             %Tama�o de la venta para solucionaer el OFFSET de sincronismo 
sampleR=(r*sum(Nsc+longCP))/(TTI*10^-3);                            % Frecuencia de muestreo
disp(['SampleR= ' num2str(sampleR/(1E6)) ' MHz']);
% Valores dependientes del uso de sincronismo
if sinc
    Nps = 10;                                 % N�mero de pilotos por s�mbolo
    [valPil,posPil] = genPilots2(Ndp,Nps);    % Secuencias de pilotos y sus posiciones
    Nssb = Nsb+1;                             % N�mero de s�mbolos simulados por bloque (incluyendo uno para el retardo)
    wdwSync = 10;                             % N� de bloques de la ventana inicial de sincronizaci�n del retardo absoluto
    cpMargin = 10;                            % Margen de muestras que se escogen del CP (25%)
    delay = 100;                                % Retardo absoluto
else
    Nps = 0;
    valPil=[]; posPil=[];
    Nssb = Nsb;
    wdwSync = 0;
    cpMargin = 0;
    delay = 0;
end
Nd = Ndp-Nps;

% Valores para la codificaci�n
[nCB, codeblock] = codeblockParameters(Nsb,modo,Npb); % N�mero y tama�o de los codeblocks

% mLag = zeros(2000,length(SNR));
% mLag2 = zeros(2000,length(SNR));

%% Creaci�n de la estructura en funci�n de los par�metros

sim = struct('modo',modo,...
             'codificar',codificar,...
             'tipo',tipo,...
             'dft',dft,...
             'blockErSim',blockErSim,...
             'vSNR',SNR,...
             'iSNR',0,...
             'tau',tau,...
             'pdb',pdb,...
             'speedKMH',speedKMH,...
             'fc',fc,...
             'sampleR',sampleR,...
             'Nsc',Nsc,...
             'valPil',valPil,...
             'posPil',posPil,...
             'Nd',Nd,...
             'k0',k0,...
             'Na',Na,...
             'Nsb',Nsb,...
             'Nssb',Nssb,...
             'Npb',Npb,...
             'Nps',Nps,...
             'normalizar',normalizar,...
             'm',m,...
             'longCP',longCP,...
             'longCAZAC',longCAZAC,...
             'nCB',nCB,...
             'codeblock',codeblock,...
             'wdwSync',wdwSync,...
             'cpMargin',cpMargin,...
             'delay',delay,...
             'eq_type',eq_type,...
             'ventanaCP',ventanaCP,...
             'sinc',sinc,...
             'oversampling',r);
sim.efecto=efecto;
%% C�lculos te�ricos

[BERteo, BLERteo] = theoricCalcs(sim);

%% Simulaci�n del sistema

%Reseteo el fichero de resultados
nameFile = nameResultsFile(sim);
resetFile(['ResultsFiles/',nameFile]);

% Inicializaci�n de par�metros para la simulaci�n
BER=zeros(1,length(SNR));              % BER sin codificaci�n
BLER=zeros(1,length(SNR));             % BLER sin codificaci�n
codBER=zeros(1,length(SNR));           % BER con codificaci�n
codBLER=zeros(1,length(SNR));          % BLER con codificaci�n

% ocurrencias = zeros(length(sim.vSNR),2188);
for i=1:length(sim.vSNR)
    
    % ---------------------------------------------------------------------
    % Obtenci�n de valores de BER y BLER
    sim.iSNR = sim.vSNR(i);
    [codBER(i),codBLER(i),BER(i),BLER(i),lag]=sistemaFMOFDM(sim);

%     mLag2(:,i) = lag2;
%     save(['retardos 25 pilotos ',num2str(sim.cpMargin),'.mat'],'mLag2');
    
    % ---------------------------------------------------------------------
    % Representaci�n de los resultados
    nameGraph = nameFigures(sim);
    indFig = plotGraphs(nameGraph,SNR(1:i),sim.vSNR,BER(1:i),codBER(1:i),codBLER(1:i));

    % ---------------------------------------------------------------------
    % Almacenamiento de las figuras y resultados
    storeGraph(indFig,nameGraph);
    storeResults(sim,[BER(i),BLER(i),codBER(i),codBLER(i)]);
    close all;

%     mLag(:,i) = lag;
%     save(['retardos ',num2str(Nps),' pilotos ',num2str(sim.cpMargin),'.mat'],'mLag');
    
end

end

function checkArgs(tipo, efecto, modo,speed,eq_type)
    % Inicializaciones

    tipos_permitidos = {'juntos','separados'};    % Tipos de simulaci�n permitidos
    efectos_permitidos = {'NO','CH','PN','CFO','OFFSET'};  % Efectos a simular permitidos
    modos_permitidos = {'QPSK','16QAM','64QAM'};  % Modulaciones permitidas
    equalizaciones_permitidas ={'mmse','zfe','none'};
    
    

    % Compruebo que los tipos son los correctos
    if ~max(strcmp(tipo,tipos_permitidos))
        error('Tipo solo puede ser {juntos, separados}');
    end

    % Compruebo que los efectos son los correctos
    
    for efecto_aux=efecto
        if ~max(strcmp(efecto_aux,efectos_permitidos))
             error('Efecto solo puede ser {CH, PN, CFO, OFFSET,NO}');
        end
    end
 
    % Compruebo que los modos son los correctos
    if ~max(strcmp(modo,modos_permitidos))
        error('Modo solo puede ser {QPSK, 16QAM, 64QAM}');
    end
    if  max(strcmp(efecto,'CH'))||max(strcmp(efecto,'juntos'))
        if ~max(strcmp(eq_type,equalizaciones_permitidas))
            error('Equalizacion solo puede ser {mmse, zfe, none}');
        elseif(speed<0)
            error('La velocidad debe ser mayor o igual a 0');
        end
    end
    % Me aseguro de que si tipo='juntos' entonces efecto='NO'
    if strcmp(tipo,'juntos') && ~strcmp(efecto,'NO')
        warning(['El argumento efecto no se considera puesto que se ',...
                 'simular�n todos los efectos juntos'])
    end
    
    
end

function checkFolders()
    if exist('ResultsFigures','dir') ~= 7
        mkdir('ResultsFigures');
    end
    if exist('ResultsFiles','dir') ~= 7
        mkdir('ResultsFiles')
    end
    if exist('ExecutionFiles','dir') ~= 7
        mkdir('ExecutionFiles')
    end
end
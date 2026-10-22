%% #######################################################
%%         Control de cargas y balance energético
%% #######################################################

%% #######################################################
%%         Sistema de generacion híbrido
%% #######################################################

horas_dia = 1:24; %% Perfil horario de Funcionamiento de  la red
%% Generacion solar
ventana_solar = 6:18; %% ventana de generación del SFV
perfil_solar = zeros(size(horas_dia));
generacion_solar = 0.25 * sin(pi * (horas_dia - 6) / 12); % Calculo de generación solar estimada por hora 

%% Generación eolica
Pmax_eolica = 15; % Potencia maxima generadda por el sistema elolico
generacion_eolica = Pmax_eolica* rand(size(horas_dia)); % Perfil de generación durante el dia del sistema eolíco

%% Generacion Hibrida

generacion_hibrida = generacion_eolica + generacion_solar; %% Perfil de generación  híbridad hora por hora

%% Perfil de Consumo
demanda = zeros(size(horas_dia)); %% Demanda energetica por perfil horario
P_Max_demanda = 15; % Pico de consumo de la comunidad energetica 



demanda(1:5) =2 + (4-2) * rand(1,5); % Perfil de consumo  variable durante las primeras horas del dia
                                     % El valor 2 se asegura que el consumo nunca baje de 2

demanda( 22:24)= 2 + (4-2) * rand(1, 3);%Perfil de consumo durante las ultimas horas de la noche


demanda(6:17)= 6 +(10-6) * rand(1,12);%% Consumo diurno variable entre las 6 y 17 horas

%% Consumo máximo del diseño
demanda(18:21) = P_Max_demanda; % Pico Máximo de Demanda (Horas 18 a 21)

%% Parametros de la bateria y del estado de carga SOC
SOC = 50;   % Estado de carga inicial de la batería (%)
cap_bateria =100; % Capacidad nominal de la batería


%% Balance energetico entre Generacion y demanda

balance = generacion_hibrida - demanda; % superhabít o deficít energético por hora 

%% Encabezado del informe
fprintf('                           #######################################################\n')
fprintf('                                  Control de cargas y balance energético\n')       
fprintf('                           #######################################################\n')
fprintf('\n')
fprintf('%-8s %-13s %-11s%-15s %-10s %-13s %-14s %-12s %-10s\n', ...
    'Hora','Generacion','Demanda','balance_estado','SOC','Estado','Alumbrado','Bombeo','Escuela');

%% Bucle de seguimiento cada hora
for h= 1:24
    % Registrar el estado de la batería y los servicios para cada hora
    SOC= SOC + (balance(h)/cap_bateria)*100;
    % Ruta de seguridad para porteger la bateria
    if SOC >=100;
        SOC=100;
    % Ruta de alerta para evitar descarga profunda
    elseif SOC<0;
        SOC = 0;
    end
    %% Rutas para determinar que sistemas mantiene activos segun estado SOC
    if SOC>40 
        Estado  = 'Seguro';
        Alumbrado= 'Activo';
        Bombeo= 'Activo';
        Escuela= 'Activo';
        
    elseif SOC>20
        Estado = 'Alerta';
        Alumbrado= "Suspendido";
        Bombeo= 'Activo';
        Escuela= 'Activo';
        
    else 
        Estado  = 'Emergencia';
        Alumbrado= 'Suspendido';
        Bombeo='Suspendido';
        Escuela= 'Activo';
    end
    %% Ruta para informar estado de balance energetico
    if generacion_hibrida(h)>demanda(h)
        balance_estado = "Superhabit";
    else
        balance_estado = "Deficit";
    end

    %% Informe por consola
       
    fprintf('%-8s %-13.2f %-11.2f %-15s %-10.2f %-13s %-14s %-12s %-10s\n', ...
    sprintf('%02d:00',h), generacion_hibrida(h), demanda(h), ...
    balance_estado, SOC, Estado, Alumbrado, Bombeo, Escuela);
    
end
fprintf('Fin de reporte\n')



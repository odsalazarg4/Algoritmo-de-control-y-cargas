%% Control de cargas y balance energetico
%% Perfil horario de uncionamie to de  la red
horas_dia = 1:24;
%% ventana de generacion del SFV
ventana_solar = 6:18;
perfil_solar = zeros(size(horas_dia));
generacion_solar = 0,25 * sin(pi * (horas_dia - 6) / 12)
%% Potencia maxima generadda por el sistema elolico
Pmax_eolica = 15;
%% Perfil de generacion durante el dia del sistema eolico
generacion_eolica = Pmax_eolica* rand(size(horas_dia))
%% Perfil de generacion  hibridad hora por hora
generacion_hibrida = generacion_eolica + generacion_solar
%% Cuantificacion de la generacion hibrida al dia 
egent = sum(generacion_hibrida)
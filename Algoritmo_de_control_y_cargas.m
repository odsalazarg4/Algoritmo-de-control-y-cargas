%% Control de cargas y balance energetico
horas_dia = 1:24;
ventana_solar = 6:18;
perfil_solar = zeros(size(horas_dia));
generacion_solar = 0,25 * sin(pi * (horas_dia - 6) / 12)
Pmax_eolica = 15;
generacion_eolica = Pmax_eolica* rand(size(horas_dia))

generacion_hibrida = generacion_eolica + generacion_solar
egent = sum(generacion_hibrida)
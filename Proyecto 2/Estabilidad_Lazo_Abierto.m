% Función que analiza la estabilidad de un sistema de control a partir
% de los polos y ceros de la planta G(s).

function Estabilidad_Lazo_Abierto()

    fprintf('===============================================\n');
    fprintf('       Analisis de estabilidad del sistema\n');
    fprintf('===============================================\n\n');
    
    %% ------------------------------------------------
    % 1. Solicitud de ceros y polos
    % -------------------------------------------------
    
    fprintf('Ingrese los ceros de G(s).\n');
    fprintf('Ejemplo: [0 -2 -5]\n');
    fprintf('Si no existen ceros, escriba [].\n\n');
    
    ceros = input('Ceros = ');
    
    fprintf('\nIngrese los polos de G(s).\n');
    fprintf('Ejemplo: [0 -1 -3]\n');
    fprintf('Los polos pueden ser reales o complejos.\n\n');
    
    polos = input('Polos = ');
    
    fprintf('\n');
    
    %% ------------------------------------------------
    % 2. Solicitud de la ganancia K
    % -------------------------------------------------
    
    K = input('Ingrese el valor de la ganancia K = ');
    
    %% ------------------------------------------------
    % 3. Construccion de G(s)
    % -------------------------------------------------
    
    G = zpk(ceros, polos, 1);

    fprintf('\n===============================================\n');
    fprintf('          Funcion de transferencia G(s)\n');
    fprintf('===============================================\n\n');

    G = tf(G)
    
    [num, den] = tfdata(G, 'v');
    
    %% ------------------------------------------------
    % 4. Ecuacion caracteristica
    % -------------------------------------------------
    
    % G(s) = N(s)/D(s)
    %
    % 1 + K G(s) = 0
    %
    % 1 + K N(s)/D(s) = 0
    %
    % D(s) + K N(s) = 0
    
    longitud = max(length(den), length(num));
    
    den_ext = [zeros(1, longitud-length(den)), den];
    num_ext = [zeros(1, longitud-length(num)), num];
    
    % Polinomio caracteristico
    pol_car = den_ext + K*num_ext;
    
    % Eliminar posibles ceros numericos iniciales
    pol_car = pol_car(find(abs(pol_car) > 1e-12, 1):end);
    
    grado = length(pol_car)-1;
    
    fprintf('\n===============================================\n');
    fprintf('          Ecuacion caracteristica\n');
    fprintf('===============================================\n\n');
    
    fprintf('1 + K*G(s) = 0\n\n');
    
    fprintf('Polinomio caracteristico:\n');
    
    mostrarPolinomio(pol_car, 'P(s)');
    
    fprintf('\nGrado de la ecuacion caracteristica: %d\n', grado);
    
    %% ------------------------------------------------
    % 5. Coeficientes
    % -------------------------------------------------
    
    fprintf('\n===============================================\n');
    fprintf('             Coeficientes\n');
    fprintf('===============================================\n\n');
    
    disp(pol_car);
    
    %% ------------------------------------------------
    % 6. Matriz de Routh-Hurwitz
    % -------------------------------------------------
    
    R = tablaRouth(pol_car);
    
    fprintf('\n===============================================\n');
    fprintf('          Matriz de Routh-Hurwitz\n');
    fprintf('===============================================\n\n');
    
    disp(R);
    
    %% ------------------------------------------------
    % 7. Polos de lazo cerrado
    % -------------------------------------------------
    
    T = feedback(K*G, 1);
    
    polos_lazo_cerrado = pole(T);
    
    fprintf('\n===============================================\n');
    fprintf('        Polos de lazo cerrado\n');
    fprintf('===============================================\n\n');
    
    disp(polos_lazo_cerrado);
    
    %% ------------------------------------------------
    % 8. Lugar de las raices
    % -------------------------------------------------
    
    figure('Name','Lugar de las raices', ...
           'NumberTitle','off');
    
    % Lugar de las raices
    rlocus(G);
    
    grid on;
    hold on;
    
    %% ------------------------------------------------
    % Polos de lazo abierto
    % -------------------------------------------------
    
    if ~isempty(polos)
    
        plot(real(polos), imag(polos), ...
            'x', ...
            'MarkerSize', 13, ...
            'LineWidth', 2.5);
    
    end
    
    %% ------------------------------------------------
    % Ceros de lazo abierto
    % -------------------------------------------------
    
    if ~isempty(ceros)
    
        plot(real(ceros), imag(ceros), ...
            'o', ...
            'MarkerSize', 11, ...
            'LineWidth', 2.5);
    
    end
    
    %% ------------------------------------------------
    % Eje imaginario
    % -------------------------------------------------
    
    xline(0, '--', ...
          'Eje imaginario', ...
          'LineWidth', 1.2);
    
    %% ------------------------------------------------
    % Eje real
    % -------------------------------------------------
    
    yline(0, '--', ...
          'Eje real', ...
          'LineWidth', 1.2);
    
    %% ------------------------------------------------
    % Etiquetas de polos de lazo abierto
    % -------------------------------------------------
    
    for i = 1:length(polos)
    
        texto = sprintf('  P%d = %.3g %+.3gj', ...
                        i, real(polos(i)), imag(polos(i)));
    
        text(real(polos(i)), ...
             imag(polos(i)), ...
             texto, ...
             'FontSize', 9, ...
             'VerticalAlignment','bottom');
    
    end
    
    %% ------------------------------------------------
    % Etiquetas de ceros de lazo abierto
    % -------------------------------------------------
    
    for i = 1:length(ceros)
    
        texto = sprintf('  Z%d = %.3g %+.3gj', ...
                        i, real(ceros(i)), imag(ceros(i)));
    
        text(real(ceros(i)), ...
             imag(ceros(i)), ...
             texto, ...
             'FontSize', 9, ...
             'VerticalAlignment','top');
    
    end
    
    %% ------------------------------------------------
    % Configuracion de la grafica
    % -------------------------------------------------
    
    xlabel('Parte real');
    ylabel('Parte imaginaria');
    
    title(sprintf('Lugar de las raices - K = %.4g', K));
    
    axis equal;
    
    % Leyenda
    if ~isempty(ceros)
    
        legend('Lugar de las raices', ...
               'Polos de lazo abierto', ...
               'Ceros de lazo abierto', ...
               'Eje imaginario', ...
               'Eje real', ...
               'Location','best');
    
    else
    
        legend('Lugar de las raices', ...
               'Polos de lazo abierto', ...
               'Eje imaginario', ...
               'Eje real', ...
               'Location','best');
    
    end
    
    hold off;
    
    
    %% ------------------------------------------------
    % 9. Analisis de estabilidad mediante Routh
    % -------------------------------------------------
    
    primera_columna = R(:,1);
    
    % Eliminar valores muy pequenos
    primera_columna(abs(primera_columna) < 1e-10) = 0;
    
    % Signos de la primera columna
    signos = sign(primera_columna);
    
    % Eliminar ceros para contar cambios de signo
    signos_sin_ceros = signos(signos ~= 0);
    
    if length(signos_sin_ceros) > 1
    
        cambios_signo = sum(signos_sin_ceros(1:end-1) ...
                            ~= signos_sin_ceros(2:end));
    
    else
    
        cambios_signo = 0;
    
    end
    
    if cambios_signo == 0
    
        resultado_routh = true;
    
    elseif cambios_signo > 0
    
        resultado_routh = false;
    
    else
    
        resultado_routh = false;
    
    end
    
    
    %% =================================================
    % 10. Analisis de estabilidad mediante los polos
    % =================================================
    
    % Tolerancia para considerar un polo sobre el eje imaginario
    tolerancia = 1e-7;
    
    partes_reales = real(polos_lazo_cerrado);
    
    % Numero de polos en el semiplano derecho
    polos_derecha = sum(partes_reales > tolerancia);
    
    % Numero de polos sobre el eje imaginario
    polos_eje = sum(abs(partes_reales) <= tolerancia);
    
    % Numero de polos en el semiplano izquierdo
    polos_izquierda = sum(partes_reales < -tolerancia);
    
    if polos_derecha > 0
    
        resultado_polos = false;
        estado_polos = 'inestable';
    
    elseif polos_eje > 0
    
        resultado_polos = false;
        estado_polos = 'marginal / caso critico';
    
    else
    
        resultado_polos = true;
        estado_polos = 'estable';
    
    end
    
    
    %% =================================================
    % 11. Mensajes finales de estabilidad
    % =================================================
    
    fprintf('\n\n');
    fprintf('========================================================\n');
    fprintf('                 Analisis final\n');
    fprintf('========================================================\n\n');
    
    
    %% ------------------------------------------------
    % Analisis mediante Routh
    % -------------------------------------------------
    
    fprintf('1. Analisis mediante Routh-Hurwitz\n');
    fprintf('----------------------------------------\n\n');
    
    fprintf('Primera columna de la tabla de Routh:\n');
    
    disp(primera_columna);
    
    fprintf('Numero de cambios de signo = %d\n', ...
            cambios_signo);
    
    if resultado_routh
    
        fprintf('\nConclusion mediante Routh:\n');
        fprintf('El sistema es estable.\n');
    
    else
    
        fprintf('\nConclusion mediante Routh:\n');
        fprintf('El sistema es inestable.\n');
    
        fprintf(['La cantidad de cambios de signo indica que ' ...
                 'existen %d polo(s) en el semiplano derecho.\n'], ...
                 cambios_signo);
    
    end
    
    
    %% ------------------------------------------------
    % Analisis mediante polos
    % -------------------------------------------------
    
    fprintf('\n\n');
    fprintf('2. Analisis mediante los polos de lazo cerrado\n');
    fprintf('----------------------------------------\n\n');
    
    fprintf('Polos de lazo cerrado:\n');
    
    for i = 1:length(polos_lazo_cerrado)
    
        fprintf('P%d = %.8f %+.8fj\n', ...
                i, ...
                real(polos_lazo_cerrado(i)), ...
                imag(polos_lazo_cerrado(i)));
    
    end
    
    fprintf('\n');
    
    fprintf('Polos en el semiplano izquierdo : %d\n', ...
            polos_izquierda);
    
    fprintf('Polos en el semiplano derecho   : %d\n', ...
            polos_derecha);
    
    fprintf('Polos sobre el eje imaginario   : %d\n', ...
            polos_eje);
    
    fprintf('\nConclusion mediante los polos:\n');
    fprintf('El sistema es %s.\n', estado_polos);
    
    
    %% =================================================
    % 12. Comparacion de los dos metodos
    % =================================================
    
    fprintf('\n\n');
    fprintf('========================================================\n');
    fprintf('             Conclusion del sistema\n');
    fprintf('========================================================\n\n');
    
    if resultado_routh && resultado_polos
    
        fprintf(['Los dos metodos utilizados, Routh-Hurwitz y el ' ...
                 'analisis de los polos de lazo cerrado,\n']);
    
        fprintf(['indican que el sistema es estable para la ganancia ' ...
                 'K = %.6g.\n'], K);
    
        fprintf(['Esto significa que todos los polos de lazo cerrado ' ...
                 'se encuentran en el semiplano izquierdo\n']);
    
        fprintf(['del plano complejo, lo cual es consistente con la ' ...
                 'ubicacion de las raices observada\n']);
    
        fprintf('en el lugar de las raices.\n');
    
    
    elseif ~resultado_routh && ~resultado_polos
    
        fprintf(['Los dos metodos utilizados, Routh-Hurwitz y el ' ...
                 'analisis de los polos de lazo cerrado,\n']);
    
        fprintf(['indican que el sistema es inestable para la ganancia ' ...
                 'K = %.6g.\n'], K);
    
        fprintf(['La inestabilidad se debe a la presencia de uno o mas ' ...
                 'polos en el semiplano derecho,\n']);
    
        fprintf(['lo cual es consistente con la ubicacion de las raices ' ...
                 'observada en el lugar de las raices.\n']);
    
    
    else
    
        fprintf(['Los resultados de Routh-Hurwitz y del analisis ' ...
                 'directo de los polos no coinciden completamente.\n']);
    
        fprintf(['Se recomienda revisar el caso particular y la ' ...
                 'ubicacion de los polos sobre el eje imaginario.\n']);
    
    end
    
    
    fprintf('\n========================================================\n');
    fprintf('                 Fin del analisis\n');
    fprintf('========================================================\n');
    
    
    end
    
    
    %% =================================================
    % Funcion para construir la tabla de Routh
    % =================================================
    
    function R = tablaRouth(coef)
    
    n = length(coef)-1;
    
    filas = n + 1;
    columnas = ceil((n+1)/2);
    
    R = zeros(filas, columnas);
    
    % Primera fila:
    % a_n, a_(n-2), a_(n-4), ...
    R(1,1:length(coef(1:2:end))) = coef(1:2:end);
    
    % Segunda fila:
    % a_(n-1), a_(n-3), a_(n-5), ...
    R(2,1:length(coef(2:2:end))) = coef(2:2:end);
    
    % Construccion de la tabla
    for i = 3:filas
    
        for j = 1:columnas-1
    
            R(i,j) = (R(i-1,1)*R(i-2,j+1) ...
                     - R(i-2,1)*R(i-1,j+1)) ...
                     / R(i-1,1);
    
        end
    
    end
    
    end
    
    
    %% =================================================
    % Funcion para mostrar polinomios
    % =================================================
    
    function mostrarPolinomio(coef, nombre)
    
    grado = length(coef)-1;
    
    fprintf('%s = ', nombre);
    
    for i = 1:length(coef)
    
        valor = coef(i);
        potencia = grado-(i-1);
    
        if i == 1
    
            fprintf('%.4g', valor);
    
        else
    
            if valor >= 0
                fprintf(' + %.4g', valor);
            else
                fprintf(' - %.4g', abs(valor));
            end
    
        end
    
        if potencia > 1
            fprintf('s^%d', potencia);
    
        elseif potencia == 1
            fprintf('s');
    
        end
    
    end
    
    fprintf(' = 0\n');

end

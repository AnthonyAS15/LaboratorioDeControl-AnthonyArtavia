%Definición de la función dedicada a simular el motor CD

function MotorCD(K_T, R_a, b, K_b, J) 

    %%Validación de las entradas
    
    if ~isnumeric(K_T) || ~isscalar(K_T) || ~isreal(K_T) || ~isfinite(K_T) || K_T <= 0
        error('K_T debe ser un número real, finito y mayor que 0.');
    end
    
    if ~isnumeric(R_a) || ~isscalar(R_a) || ~isreal(R_a) || ~isfinite(R_a) || R_a <= 0
        error('R_a debe ser un número real, finito y mayor que 0.');
    end
    
    if ~isnumeric(b) || ~isscalar(b) || ~isreal(b) || ~isfinite(b) || b <= 0
        error('b debe ser un número real, finito y mayor que 0.');
    end
    
    if ~isnumeric(K_b) || ~isscalar(K_b) || ~isreal(K_b) || ~isfinite(K_b) || K_b <= 0
        error('K_b debe ser un número real, finito y mayor que 0.');
    end
    
    if ~isnumeric(J) || ~isscalar(J) || ~isreal(J) || ~isfinite(J) || J <= 0
        error('J debe ser un número real, finito y mayor que 0.');
    end
    
    %%Cálculo de K_M y tau
    
    denominador = R_a*b + K_T*K_b;
    
    if denominador == 0
        error('El denominador R_a*b + K_T*K_b no puede ser cero.');
    end
    
    K_M = K_T / denominador;
    tau = R_a*J / denominador;

    fprintf('El valor obtenido para K_M corresponde a: %f\n', K_M);
    fprintf('El valor obtenido para tau corresponde a: %f\n', tau);
    
    %%Función de transferencia
  
    disp('La función de transferencia G(s) tiene la siguiente forma: ');
    G = tf(K_M, [tau 1])

    %%Parámetros de la respuesta temporal

    %Simulación hasta 10*tau
    t_final = 10*tau;
    t = linspace(0, t_final, 1000);

    %Respuesta al escalón unitario
    [y, t] = step(G, t);

    %%Datos de interés

    %a) Valor final esperado en t = 5*tau
    t_5tau = 5*tau;
    y_final = K_M*(1 - exp(-5));

    %b) Error de estado estacionario
    e_ss = abs(1 - y_final);

    %c) Respuesta en t = tau
    t_tau = tau;
    y_tau = K_M*(1 - exp(-1));

    %d) Tiempo de asentamiento al 2%
    t_s = -log(0.02)*tau;

    %%Gráfica

    figure;

    %Respuesta del sistema
    h1 = plot(t, y, 'LineWidth', 1.5);
    hold on;
    grid on;

    %a) Valor final esperado
    h2 = plot(t_5tau, y_final, 'o', ...
        'MarkerSize', 7, ...
        'LineWidth', 1.5);

    %c) Valor en t = tau
    h3 = plot(t_tau, y_tau, 'o', ...
        'MarkerSize', 7, ...
        'LineWidth', 1.5);

    %d) Tiempo de asentamiento
    h4 = xline(t_s, '--', ...
        'LineWidth', 1.2);

    %b) Error de estado estacionario
    if e_ss > 0.01

        h5 = plot([t_5tau t_5tau], ...
            [y_final 1], ':', ...
            'LineWidth', 1.2);

        legend([h1 h2 h3 h4 h5], ...
            'Respuesta del sistema', ...
            'Valor final esperado (5\tau)', ...
            'Respuesta en \tau', ...
            'Tiempo de asentamiento (2%)', ...
            'Error de estado estacionario', ...
            'Location', 'southeast');
    else

        legend([h1 h2 h3 h4], ...
            'Respuesta del sistema', ...
            'Valor final esperado (5\tau)', ...
            'Respuesta en \tau', ...
            'Tiempo de asentamiento (2%)', ...
            'Location', 'southeast');

    end

    %%Etiquetas

    xlabel('Tiempo [s]');
    ylabel('Respuesta');
    title('Respuesta al escalón unitario - Motor de CD');

    hold off;

end

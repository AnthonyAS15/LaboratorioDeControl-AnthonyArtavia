function Polos_Dinamicos(ceros, polos)
    % Validar que se ingresen los parámetros requeridos
    if nargin < 2
        error('Debe ingresar los ceros y los polos. Ejemplo: Polos_Dinamicos([], [-1, -2])');
    end
    
    % Asegurar que sean vectores columna
    ceros = ceros(:); 
    polos = polos(:);
    
    % 1. Construye la ecuación de transferencia
    fprintf('\n--- 1. ECUACIÓN DE TRANSFERENCIA DE LA PLANTA ---\n');
    planta_zpk = zpk(ceros, polos, 1);
    planta_tf = tf(planta_zpk)
    
    % 2. Extrae la ecuación característica original
    fprintf('\n--- 2. ECUACIÓN CARACTERÍSTICA ORIGINAL ---\n');
    [~, den] = tfdata(planta_tf, 'v');
    disp('El polinomio característico original (denominador = 0) es:');
    ecuacion_caracteristica = tf(den, 1)
    
    % 3 y 4. Diagrama y selección de polos
    fprintf('\n--- 3. DISEÑO INTERACTIVO (ROOT LOCUS) ---\n');
    disp('Abriendo Control System Designer...');
    controlSystemDesigner('rlocus', planta_tf);
    
    % --- INICIO DE LA AUTOMATIZACIÓN ---
    fprintf('\n--- ACCIÓN REQUERIDA ---\n');
    disp('1. Modifique los polos en la ventana interactiva.');
    disp('2. Vaya a "Export" y exporte el bloque "C" al Workspace.');
    disp('3. Vuelva a esta ventana de comandos y presione ENTER para continuar...');
    pause; % El script se detiene aquí hasta que presiones Enter
    
    try
        % Extraer el compensador 'C' desde el Workspace base
        C = evalin('base', 'C'); 
    
        % 5. Generar la nueva ecuación característica del sistema compensado
        fprintf('\n--- 4. NUEVA ECUACIÓN CARACTERÍSTICA (COMPENSADA) ---\n');
        % El sistema en lazo cerrado es T = (C*G) / (1 + C*G)
        % La ecuación característica es 1 + C*G = 0 (denominador de T)
        sistema_lazo_cerrado = feedback(C * planta_tf, 1);
        [~, den_compensado] = tfdata(sistema_lazo_cerrado, 'v');
    
        
        disp('El polinomio característico del sistema COMPENSADO es:');
        ecuacion_caracteristica_comp = tf(den_compensado, 1)
    
        % 6. Extraer la respuesta del compensador como complemento
        fprintf('\n--- 5. RESPUESTA DEL COMPENSADOR Y PLANTA ---\n');
        disp('Ecuación del Compensador (C):');
        C
    
        % Graficar ambas respuestas (planta original vs sistema compensado)
        figure('Name', 'Comparación de Respuestas al Escalón');
        step(planta_tf, 'r--'); hold on;
        step(sistema_lazo_cerrado, 'b-');
        grid on;
        title('Respuesta al escalón: Planta Original vs Sistema Compensado');
        legend('Planta Original (Lazo Abierto)', 'Sistema Compensado (Lazo Cerrado)');
    
    catch
        fprintf('\n[ERROR]: No se encontró la variable "C" en el Workspace.\n');
        fprintf('Asegúrese de exportarla desde el Control System Designer antes de presionar Enter.\n');
    end
end

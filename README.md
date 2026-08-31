# Repositorio del Laboratorio de Control Automático
Repositorio dedicado a los proyectos individuales del curso Laboratorio de Control Automático.

## Datos del estudiante

Anthony Artavia Salazar

2020036546

## Proyecto Individual 1

El primer proyecto individual del curso consiste simplemente del archivo MotorCD que se encuentra dentro de la carpeta Proyecto 1.
Para ejecutar el script, se debe simplemente llamar a la función MotorCD junto con las entradas deseadas. Por ejemplo: MotorCD(1, 2, 0.25, 0.5, 0.25)

Para tomarlo en consideración, las entradas poseen el siguiente orden: MotorCD(K_T, R_a, b, K_b, J)

## Proyecto Individual 2

El segundo proyecto individual del curso se puede encontrar en la carpeta llamada Proyecto 2. Este consiste de una función llamada Estabilidad_Lazo_Abierto(), por lo que para ejecutar el script basta con ejecutar dicha función en la línea de comandos. Hecho esto, la función solicitará al usuario los parámetros de entrada para así ejecutar el script solicitado.

## Proyecto Individual 3

El tercer proyecto individual del curso está en la carpeta llamada Proyecto 3. Este consiste del script llamado Polos_Dinamicos, el cual posee una función con el mismo nombre. Para ejecutar dicho script, se pueden seguir las siguientes indicaciones

GUÍA RÁPIDA DE EJECUCIÓN - Polos_Dinamicos

1. EJECUTAR EL SCRIPT:
   Llama a la función desde la Command Window pasando ceros:
   `>> Polos_Dinamicos([], [-1, -2])`

2. DISEÑAR INTERACTIVAMENTE:
   En la ventana gráfica que se abre (Control System Designer):
   - Arrastrar polos: Arrastra los marcadores rosa en el gráfico Root Locus.
   - Agregar polos: Clic derecho en el gráfico -> 'Add Pole/Zero' -> 'Pole' y haz clic donde desees colocarlo.

4. EXPORTAR EL COMPENSADOR:
   - Haz clic en la pestaña "Control System" (arriba).
   - Haz clic en el botón "Export" -> "Export Model".
   - Selecciona únicamente el bloque "C" (Compensador) y presiona "Export to Workspace".

5. FINALIZAR:
   Vuelve a la Command Window de MATLAB y presiona ENTER para generar
   la nueva ecuación característica y visualizar las respuestas.
   

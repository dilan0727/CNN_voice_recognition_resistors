function calculadora_resistencias_por_voz()
    % Definir los colores de las bandas
    colores = {'Negro', 'Cafe', 'Rojo', 'Naranja', 'Amarillo', 'Verde', 'Azul', 'Violeta', 'Gris', 'Blanco', 'Dorado', 'Plateado'};
    
    % Solicitar los colores mediante voz y obtener las predicciones
    banda1 = reconocer_color_por_voz(colores, 'primera');
    banda2 = reconocer_color_por_voz(colores, 'segunda');
    banda3 = reconocer_color_por_voz(colores, 'tercera');
    
    % Calcular el valor de la resistencia
    valor_resistencia = calcular_valor_resistencia(banda1, banda2, banda3, colores);
    
    % Mostrar el resultado
    fprintf('El valor de la resistencia es: %.2f ohms\n', valor_resistencia);
    
    % Mostrar la imagen correspondiente a la resistencia, si existe
    mostrar_imagen(valor_resistencia);
end

function color = reconocer_color_por_voz(colores, num_banda)
    % Mensaje para solicitar el color mediante voz
    disp(['Por favor, diga el color de la ', num_banda, ' banda:']);
    
    % Grabar audio
    recorder = audiorecorder;
    recordblocking(recorder, 2); % Grabar durante 2 segundos
    disp('Grabación completa. Analizando...');
    
    % Obtener datos de audio
    audio_data = getaudiodata(recorder);
    
    % Convertir audio a .wav y guardar
    nombre_archivo_wav = ['voz_color_', num_banda, '.wav'];
    audiowrite(nombre_archivo_wav, audio_data, recorder.SampleRate);
    
    % Convertir .wav a .mat con MFCC
    nombre_archivo_mat = ['voz_color_', num_banda, '.mat'];
    calcular_y_guardar_MFCC_aux(nombre_archivo_wav, nombre_archivo_mat, [12, 199, 3]);
    
    % Cargar archivo .mat con MFCC
    carga = load(nombre_archivo_mat);
    MFCC = carga.MFCC;
    
    % Clasificar utilizando la red neuronal previamente entrenada
    net = load('NetAudio.mat');
    red = net.net;
    prediccion = classify(red, MFCC);
    
    % Mostrar la predicción
    disp(['El color detectado para la ', num_banda, ' banda es: ', char(prediccion)]);
    
    % Retornar la predicción como resultado
    color = char(prediccion);
end

function calcular_y_guardar_MFCC_aux(audio_path, save_path, tamanio_capa_entrada)
    % Leer archivo WAV
    [y, Fs] = audioread(audio_path);
    
    % Calcular coeficientes MFCC
    [MFCCs, ~, ~] = mfcc(y, Fs); % Asegúrate de tener la función mfcc disponible en tu entorno MATLAB
    
    % Redimensionar MFCC al tamaño de la capa de entrada de la CNN
    MFCC = imresize(MFCCs, [tamanio_capa_entrada(1), tamanio_capa_entrada(2)]);
    
    % Agregar una dimensión para los canales si es necesario
    if size(MFCC, 3) == 1
        MFCC = repmat(MFCC, [1 1 tamanio_capa_entrada(3)]);
    end
    
    % Guardar en archivo .mat
    save(save_path, 'MFCC');
end

function valor_resistencia = calcular_valor_resistencia(banda1, banda2, banda3, colores)
    % Definir los valores para cada color en la banda
    valores = [0 1 2 3 4 5 6 7 8 9 0 0];
    
    % Definir los multiplicadores para cada color en la banda
    multiplicadores = [1 10 100 1000 10000 100000 1000000 10000000 100000000 100000000 0.1 0.01];
    
    % Obtener los valores para cada color
    valor1 = valores(strcmp(banda1, colores));
    valor2 = valores(strcmp(banda2, colores));
    multiplicador = multiplicadores(strcmp(banda3, colores));
    
    % Calcular el valor de la resistencia
    valor_resistencia = (valor1 * 10 + valor2) * multiplicador;
end

function mostrar_imagen(valor_resistencia)
    % Definir la carpeta de imágenes con la ruta completa
    carpeta_imagenes = 'imagenes';
    
    % Formatear el número de resistencia como cadena sin espacios
    num_resistencia_str = strrep(num2str(valor_resistencia), '.', '.');
    
    % Construir el nombre completo del archivo de imagen
    nombre_archivo = fullfile(carpeta_imagenes, ['imagen_resistencia_', num_resistencia_str, '.png']);
    
    % Imprimir el nombre del archivo, incluso si no existe
    disp(['Nombre del archivo de imagen: ', nombre_archivo]);
    
    % Verificar si el archivo de imagen existe antes de intentar cargarlo
    if exist(nombre_archivo, 'file') == 2
        % Mostrar la imagen
        imshow(nombre_archivo);
        title(['Resistencia: ', num2str(valor_resistencia), ' ohms']);
    else
        disp(['No hay imagen disponible para la resistencia: ', num2str(valor_resistencia), ' ohms.']);
    end
    
end



function calculadora_resistencias_por_voz()
    % Definir la carpeta de destino
    carpeta_destino = 'DataAudio\Test\Naranja';
    
    % Iterar sobre los 20 audios
    for i = 1:20
        % Mostrar mensaje de inicio de grabación
        disp(['Comenzando la grabación del audio ', num2str(i)]);
        
        % Grabar audio
        recorder = audiorecorder;
        recordblocking(recorder, 2); % Grabar durante 2 segundos
        
        % Obtener datos de audio
        audio_data = getaudiodata(recorder);
        
        % Convertir audio a .wav y guardar
        nombre_archivo_wav = fullfile(carpeta_destino, ['audio_', num2str(20 + i), '.wav']);
        audiowrite(nombre_archivo_wav, audio_data, recorder.SampleRate);
        
        % Convertir .wav a .mat con MFCC
        nombre_archivo_mat = fullfile(carpeta_destino, ['MFCCNaranja', num2str(20 + i), '.mat']);
        calcular_y_guardar_MFCC_aux(nombre_archivo_wav, nombre_archivo_mat, [12, 199, 3]);
        
        % Mostrar mensaje de finalización de grabación
        disp(['Audio ', num2str(i), ' guardado en ', nombre_archivo_mat]);
    end
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


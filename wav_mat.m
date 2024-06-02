% Carpeta donde se encuentran los archivos WAV
carpeta = 'DataAudio\Train\Dorado';

% Obtener la lista de archivos WAV en la carpeta
archivos_wav = dir(fullfile(carpeta, '*.wav'));

% Contador inicial para los nombres de archivo
contador = 61;

% Tamaño de la capa de entrada de la CNN
tamanio_capa_entrada = [12 199 3];

% Función para calcular los coeficientes MFCC y redimensionarlos al tamaño de la capa de entrada de la CNN
calcular_y_guardar_MFCC = @(audio_path, save_path, tamanio_capa_entrada) ...
    calcular_y_guardar_MFCC_aux(audio_path, save_path, tamanio_capa_entrada);

% Iterar sobre cada archivo WAV y convertirlo a .mat
for i = 1:numel(archivos_wav)
    nombre_archivo_wav = archivos_wav(i).name;
    ruta_archivo_wav = fullfile(carpeta, nombre_archivo_wav);
    
    % Nombre de archivo .mat para guardar
    nombre_archivo_mat = fullfile(carpeta, ['MFCCDorado', num2str(contador), '.mat']);
    
    % Calcular y guardar coeficientes MFCC
    calcular_y_guardar_MFCC(ruta_archivo_wav, nombre_archivo_mat, tamanio_capa_entrada);
    
    % Incrementar el contador
    contador = contador + 1;
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

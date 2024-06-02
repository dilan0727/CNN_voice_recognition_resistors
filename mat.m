% Carpeta donde se encuentran los archivos OGG
carpeta = 'DataAudio\Train\Blanco';

% Obtener la lista de archivos OGG en la carpeta
archivos_ogg = dir(fullfile(carpeta, '*.ogg'));

% Contador inicial para los nombres de archivo
contador = 61;

% Tamaño de la capa de entrada de la CNN
tamanio_capa_entrada = [12 199 3];

% Función para calcular los coeficientes MFCC y redimensionarlos al tamaño de la capa de entrada de la CNN
calcular_y_guardar_MFCC = @(audio_path, save_path, tamanio_capa_entrada) ...
    calcular_y_guardar_MFCC_aux(audio_path, save_path, tamanio_capa_entrada);

% Iterar sobre cada archivo OGG y convertirlo a .mat
for i = 1:numel(archivos_ogg)
    nombre_archivo_ogg = archivos_ogg(i).name;
    ruta_archivo_ogg = fullfile(carpeta, nombre_archivo_ogg);
    
    % Nombre de archivo .mat para guardar
    nombre_archivo_mat = fullfile(carpeta, ['MFCCDorado', num2str(contador), '.mat']);
    
    % Calcular y guardar coeficientes MFCC
    calcular_y_guardar_MFCC(ruta_archivo_ogg, nombre_archivo_mat, tamanio_capa_entrada);
    
    % Incrementar el contador
    contador = contador + 1;
end

function calcular_y_guardar_MFCC_aux(audio_path, save_path, tamanio_capa_entrada)
    % Convertir archivo OGG a WAV
    system(['ffmpeg -i "', audio_path, '" "', audio_path(1:end-4), '.wav"']);
    
    % Leer archivo WAV
    [y, Fs] = audioread([audio_path(1:end-4), '.wav']);
    
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
    
    % Eliminar archivo WAV temporal
    delete([audio_path(1:end-4), '.wav']);
end

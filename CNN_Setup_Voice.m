clear;
close;
%% Base de datos de MFCC
%% Entrenamiento
location = 'DataAudio\Train';
imds = imageDatastore(location, 'FileExtensions', '.mat', 'IncludeSubfolders',1, ...
                      'LabelSource','foldernames');
tbl = countEachLabel(imds);
minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category
countEachLabel(imds)
trainingDS = imds;
trainingDS.Labels = categorical(trainingDS.Labels);
trainingDS.ReadFcn = @readFunctionMFCC;

%% Validacion
location = 'DataAudio\Test';
imds = imageDatastore(location, 'FileExtensions', '.mat', 'IncludeSubfolders',1, ...
                      'LabelSource','foldernames');
tbl = countEachLabel(imds);
minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category
countEachLabel(imds)
ValidationDS = imds;
% Convert labels to categoricals
ValidationDS.Labels = categorical(ValidationDS.Labels);
ValidationDS.ReadFcn = @readFunctionMFCC;

%% Entrenamiento de la red
[opts, layers] = CNN_Net_Arquit(ValidationDS);
[net, info] = trainNetwork(trainingDS, layers, opts);

montage(mat2gray(gather(net.Layers(2).Weights)));
title('First Layer Weights');
analyzeNetwork(net);

save('NetAudio.mat', 'net') ;
save('NetAudioInfo.mat', 'info') ;

% confusion matrix
location = 'DataAudio/Test';
imds = imageDatastore(location, 'FileExtensions', '.mat', 'IncludeSubfolders',1, ...
                      'LabelSource','foldernames');
tbl = countEachLabel(imds)
minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category
% Notice that each set now has exactly the same number of images.
countEachLabel(imds)
XTest = imds;
% Convert labels to categoricals
XTest.Labels = categorical(XTest.Labels);
XTest.ReadFcn = @readFunctionMFCC;
[YTest,err] = classify(net, XTest,'MiniBatchSize',15);

TotalMatrix = [XTest.Labels YTest ...
                categorical(cellstr(num2str(err(:,1)))) ...
                categorical(cellstr(num2str(err(:,2)))) ...
                categorical(cellstr(num2str(err(:,3)))) ...
                categorical(cellstr(num2str(err(:,4)))) ...
                 categorical(cellstr(num2str(err(:,5)))) ...
                 categorical(cellstr(num2str(err(:,6))))
                ];
            
accuracy = 100*sum(YTest == XTest.Labels)/numel(XTest.Labels);

targets(:,1)=(XTest.Labels=='Negro');
targets(:,2)=(XTest.Labels=='Cafe');
targets(:,3)=(XTest.Labels=='Rojo');
targets(:,4)=(XTest.Labels=='Naranja');
targets(:,5)=(XTest.Labels=='Amarillo');
targets(:,6)=(XTest.Labels=='Verde');
targets(:,7)=(XTest.Labels=='Azul');
targets(:,8)=(XTest.Labels=='Violeta');
targets(:,9)=(XTest.Labels=='Blanco');
targets(:,10)=(XTest.Labels=='Dorado');
targets(:,11)=(XTest.Labels=='Plateado');
outputs(:,1)=(YTest=='Negro');
outputs(:,2)=(YTest=='Cafe');
outputs(:,3)=(YTest=='Rojo');
outputs(:,4)=(YTest=='Naranja');
outputs(:,5)=(YTest=='Amarillo');
outputs(:,6)=(YTest=='Verde');
outputs(:,7)=(YTest=='Azul');
outputs(:,8)=(YTest=='Violeta');
outputs(:,9)=(YTest=='Blanco');
outputs(:,10)=(YTest=='Dorado');
outputs(:,11)=(YTest=='Plateado');

figure
plotconfusion(double(targets'),double(outputs'))
classes = {'Negro'; 'Cafe'; 'Rojo'; 'Naranja'; 'Amarillo'; 'Verde'; 'Azul'; 'Violeta'; 'Blanco'; 'Dorado'; 'Plateado'};%{'Llevar'; 'Medicina'; 'Robot'; 'Papel'; 'Parar'; 'Toalla'; 'Traer'; 'Vaso'};
set(gca,'xticklabel',[classes', {' '}])
set(gca,'yticklabel',[classes', {' '}])
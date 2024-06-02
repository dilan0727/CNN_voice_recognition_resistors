function [opts, layers] = CNN_init_Voice(ValidationDS)
D = 32;
%Inicialización de la convolución 1 y el Fully-connected
conv1 = convolution2dLayer(7,D,'Padding',1,...
                     'BiasLearnRateFactor',2,'name','conv1');
conv1.Weights = gpuArray(single(randn([7 7 3 D])*0.0001));
conv1.Bias = gpuArray(single(randn([1 1 D])*0.00001+1));

fc1 = fullyConnectedLayer(D*16,'BiasLearnRateFactor',2,'name','fc1');
fc1.Weights = gpuArray(single(randn([D*16 1024])*0.1));%%
fc1.Bias = gpuArray(single(randn([D*16 1])*0.01+1));

fc2 = fullyConnectedLayer(D*64,'BiasLearnRateFactor',2,'name','fc2');
fc2.Weights = gpuArray(single(randn([D*64 D*16])*0.1));
fc2.Bias = gpuArray(single(randn([D*64 1])*0.01+1));

fc3 = fullyConnectedLayer(11,'BiasLearnRateFactor',2,'name','fc3');
fc3.Weights = gpuArray(single(randn([11 D*64])*0.1));
fc3.Bias = gpuArray(single(randn([11 1])*0.01+1));

layers = [imageInputLayer([12 199 3]);
    conv1;                                                                          
    batchNormalizationLayer('Name','batchn1');
    convolution2dLayer(5,D,'Padding',1,'BiasLearnRateFactor',2,'name','conv2');     
    maxPooling2dLayer(2,'Stride',2,'name','pool1');                     
    convolution2dLayer(3,(D*2),'Padding',1,'BiasLearnRateFactor',2,'name','conv3'); 
    convolution2dLayer(3,(D*2),'Padding',1,'BiasLearnRateFactor',2,'name','conv4'); 
    maxPooling2dLayer(3,'Stride',3,'name','pool2');                                   
    convolution2dLayer(3,(D*4),'Padding',1,'BiasLearnRateFactor',2,'name','conv5');  
    convolution2dLayer(2,(D*4),'Padding',1,'BiasLearnRateFactor',2,'name','conv6');  
    maxPooling2dLayer(2,'Stride',2,'name','pool3');                                    
    convolution2dLayer(2,(D*4),'Padding',1,'BiasLearnRateFactor',2,'name','conv7');  
    maxPooling2dLayer(2,'Stride',2,'name','pool4');    
    fc1;
    dropoutLayer(0.2, 'name','dropFC1');
    fc2;
    dropoutLayer(0.2, 'name','dropFC2');
    fc3;
    softmaxLayer()
    classificationLayer()   ];
% Define the training options.
opts = trainingOptions('sgdm', ...
    'InitialLearnRate', 1e-6, ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 120, ...
    'LearnRateSchedule','piecewise',...
    'L2Regularization', 0.004, ...
    'Shuffle', 'every-epoch', ...
    'MaxEpochs', 20, ...
    'MiniBatchSize', 1, ...
    'Verbose', true, ...
    'VerboseFrequency', 1880, ...
        'ValidationData',ValidationDS, ...
        'ValidationFrequency',940, ...
        'ValidationPatience',Inf, ...
    'Plots','training-progress', ...
    'ExecutionEnvironment', 'auto');

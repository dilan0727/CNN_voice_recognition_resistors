% Copyright 2016 The MathWorks, Inc.

function I = readFunctionTrainMFCC(filename)
% Resize the flowers images to the size required by the network.
I = load(filename);
I = I.MFCC;


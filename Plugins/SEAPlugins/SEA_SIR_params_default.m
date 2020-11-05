function [ params ] = SEA_SIR_params_default()
%Default parameter values for the SEA_SIR plugin

params = [];
params.filtLen = 1000; % analysis window length in seconds
params.filtOffset = 50; % analysis window step length in seconds

end


function [ params ] = SEE_SupSIRSelect_params_default()
%Default parameter values for the SEE_SupSIRSelect plugin

params = [];
params.filtLen = 1000; % analysis window length in seconds
params.filtOffset = 50; % analysis window step length in seconds

end


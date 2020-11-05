%% EXAMPLE 1 : Signal Analysis
% The Configurations presented here are detailed in 
% [1, Sect. 5.3, pp. 136-142].
%
% [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
%
% NOTE: The outputs from each configuration here will be written to the 
% .\MASSLab\Outputs\[CONFIGURATION NAME] directory.  The output signals and
% configuration info are wrtten to the "[CONFIGURATION NAME]-OUT.mat" by the 
% DO_FileWrite plugin and contains the following variables:
%   Config = A structure array containing all of the configuration
%       information.
%   DateTime = A timestamp denoting when the data were collected.
%   SampRate = The sampling rate of the signals.
%   CSE = An [L x Q] array of composite source estimate samples, where L is
%       the signal length (in samples) and Q is the number of estimated sources
%   BLOCK = An Nb-length structure array containing information produced by
%       MASS at each block, where Nb is the number of blocks.
%       .CSE = A structure array containing:
%           .sig = An [Lb x Q] array of composite source estimate samples, 
%               where Lb is the block signal length (in samples) and Q is 
%               the number of estimated sources.
%           .cds = An [L x Q x P] array of filter coefficients of the
%               composite system, where L is a filter length, Q is the
%               number of sources being estimated, and P is the number of
%               input mixture signals.
%       .SEA = A variable-sized and variable-typed array or structure
%           containg the SEAPlugin's results.

%% Example 1a) SIR Estimation Dependence on Filter Length, L
% These Configurations were used to generate the data in [1, Sect. 5.3.1]. 

%% L = 500 samples
config = Config_SigAnalysis_Ex1_500; % Load the configuration
sem = MASS_SEM(config);              % Initialize the SEM
sem.Start();                         % Start processing

% Outputs will be placed in the .\MASSLab\Outputs\Config_SigAnalysis_Ex1_500
% directory.  The Config_SigAnalysis_Ex1_500.mat file contains the output
% signals and data as described above.
fpath = fileparts(which('MASS_SEM.m'));
outDir = fullfile(fpath,'Outputs', 'Config_SigAnalysis_Ex1_500');
OUT = load(fullfile(outDir,'Config_SigAnalysis_Ex1_500-OUT.mat'));

disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

%% L = 1000 samples
config = Config_SigAnalysis_Ex1_1000;
sem = MASS_SEM(config);
sem.Start();
disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

%% L = 2000 samples
config = Config_SigAnalysis_Ex1_2000;
sem = MASS_SEM(config);
sem.Start();
disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

%% L = 3000 samples
config = Config_SigAnalysis_Ex1_3000;
sem = MASS_SEM(config);
sem.Start();
disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

%% L = 4000 samples
config = Config_SigAnalysis_Ex1_4000;
sem = MASS_SEM(config);
sem.Start();
disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

%% Example 1b) SIR Estimation Dependence on Data Block Length, N
% These Configurations were used to generate the data in [1, Sect. 5.3.2].
% Note that L=1000 for all cases.

%% N = 2 seconds x Sampling Rate
config = Config_SigAnalysis_Ex2_1000_2;
sem = MASS_SEM(config);
sem.Start();
disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

% Outputs will be placed in the .\MASSLab\Outputs\Config_SigAnalysis_Ex2_1000_2
% directory.  The Config_SigAnalysis_Ex1_500.mat file contains the output
% signals and data as described above.
[fpath] = fileparts(which('MASS_SEM.m'));
outDir = fullfile(fpath,'Outputs', 'Config_SigAnalysis_Ex2_1000_2');
OUT = load(fullfile(outDir,'Config_SigAnalysis_Ex2_1000_2-OUT.mat'));

disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

%% N = 5 seconds x Sampling Rate
config = Config_SigAnalysis_Ex2_1000_5;
sem = MASS_SEM(config);
sem.Start();
disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

%% N = 10 seconds x Sampling Rate
config = Config_SigAnalysis_Ex2_1000_10;
sem = MASS_SEM(config);
sem.Start();
disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

%% N = 30 seconds x Sampling Rate
config = Config_SigAnalysis_Ex2_1000_30;
sem = MASS_SEM(config);
sem.Start();
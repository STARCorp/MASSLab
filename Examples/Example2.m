%% EXAMPLE 2 : Single Algorithm Source Separation
% The examples given here are modified versions of the cases in
% [1, Sect. 5.5.1, pp. 147-154], where these examples only use the
% SEP_MCLP and SEP_TTSE BSE methods. Examples 2a abd 2b operate on a 3 source x
% x 3 mixture set, while examples 2c and 2d operate on a 4 source x
% x 4 mixture set.
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

%% Example 2a) SEP_MCLP (3x3)
% Note: This configuration is named Config_MASS_Ex1b_MCLP in [1, p.150].
config = Config_MASS_Ex3_GS1_3x3_Alg1Analysis;  % Load the configuration
sem = MASS_SEM(config);                         % Initialize the SEM
sem.Start();                                    % Start processing

% Outputs will be placed in the .\MASSLab\Outputs\Config_MASS_Ex3_GS1_3x3_Alg1Analysis
% directory.  The Config_SigAnalysis_Ex1_500.mat file contains the output
% signals and data as described above.
fpath = fileparts(which('MASS_SEM.m'));
outDir = fullfile(fpath,'Outputs', 'Config_MASS_Ex3_GS1_3x3_Alg1Analysis');
OUT = load(fullfile(outDir,'Config_MASS_Ex3_GS1_3x3_Alg1Analysis-OUT.mat'));

disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

%% Example 2b) SEP_TTSE (3x3)
% Note: This configuration is named Config_MASS_Ex1c_TTSE in [1, p.152].
config = Config_MASS_Ex3_GS1_3x3_Alg2Analysis;
sem = MASS_SEM(config);
sem.Start();

disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

%% Example 2c) SEP_MCLP (4x4)
config = Config_MASS_Ex3_GS1_4x4_Alg1Analysis;
sem = MASS_SEM(config);
sem.Start();

disp('Example is complete. Hit any key to proceed to the next example, or CTRL-C to exit.');
pause();

%% Example 2d) SEP_TTSE (4x4)
config = Config_MASS_Ex3_GS1_4x4_Alg2Analysis;
sem = MASS_SEM(config);
sem.Start();


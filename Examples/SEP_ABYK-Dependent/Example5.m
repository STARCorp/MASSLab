%% EXAMPLE 5 : Semi-Blind Multiple Algorithm Source Separation
% The examples given here can be found in [1, Sect. 5.5.2, pp. 154-161].
%
% [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
% 
% NOTE: These examples require the SEP_ABYK plugin.  Currently this plugin
% is unavailable.

%% Example 5a) Semi-Blind MASS (3x3)
% Note: This configuration is named Config_MASS_Ex2a_3x3 in [1, p. 155].
config = Config_MASS_Ex1_GS1_3x3;
sem = MASS_SEM(config);
sem.Start();

%% Example 5b) Semi-Blind MASS (4x4)
% % Note: This configuration is named Config_MASS_Ex2c_4x4 in [1, p. 159].
% config = Config_MASS_Ex1_GS1_4x4;
% sem = MASS_SEM(config);
% sem.Start();

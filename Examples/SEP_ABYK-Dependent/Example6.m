%% EXAMPLE 6 : Blind Multiple Algorithm Source Separation 
% The examples given here can be found in [1, Sect. 5.5.3, pp. 161-164].
%
% [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
%
% NOTE: These examples require the SEP_ABYK plugin.  Currently this plugin
% is unavailable.

%% Example 6a) Blind MASS without Self-Competition (3x3)
% Note: This configuration is named Config_MASS_Ex3a_3x3 in [1, p. 162].
config = Config_MASS_Ex2_GS1_3x3;
sem = MASS_SEM(config);
sem.Start();

%% Example 6b) Blind MASS with Self-Competition (3x3)
% Note: This configuration is named Config_MASS_Ex3a_3x3_BSC in [1, p. 162].
config = Config_MASS_Ex2_GS1_3x3_SelfComp;
sem = MASS_SEM(config);
sem.Start();

%% Example 6c) Blind MASS without Self-Competition (4x4)
% Note: This configuration is named Config_MASS_Ex3a_4x4 in [1, p. 162].
% config = Config_MASS_Ex2_GS1_3x3;
% sem = MASS_SEM(config);
% sem.Start();

%% Example 6d) Blind MASS with Self-Competition (4x4)
% Note: This configuration is named Config_MASS_Ex3a_4x4_BSC in [1, p. 162].
% config = Config_MASS_Ex2_GS1_3x3_SelfComp;
% sem = MASS_SEM(config);
% sem.Start();
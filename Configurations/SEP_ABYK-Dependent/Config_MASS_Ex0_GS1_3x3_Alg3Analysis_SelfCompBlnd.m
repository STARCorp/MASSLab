classdef Config_MASS_Ex0_GS1_3x3_Alg3Analysis_SelfCompBlnd < Config_MASS_Ex0_GS1_3x3_Alg3Analysis
    % MASS Example using blind methods:
    % - SEP_ABYK, SEP_MCLP, SEP_TTSE SEP plugins
    % - DS_SS1-3_GS1_3x4_RT60-0.1s.mat
    
    methods
        % **************************************************************
        % Constructor
        function obj = Config_MASS_Ex0_GS1_3x3_Alg3Analysis_SelfCompBlnd()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'MASS Example 0';
            obj.configDescr = 'MASS Example 0: SASS Enhancement via Sel-Competition';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Set SEM Signal Processing Properties
            obj.semSelfComp = 1;
            
            % **********************************************************
            % Define Plugin Instances
            obj.SEE = PluginInst('SEE_MinXcorrSelect',10);
            obj.SNUM = [PluginInst('SNUM_NumObs',0)];
        end
    end
end


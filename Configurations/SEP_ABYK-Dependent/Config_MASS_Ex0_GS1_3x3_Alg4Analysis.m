classdef Config_MASS_Ex0_GS1_3x3_Alg4Analysis < Config_MASS_Ex0_GS1_3x3_Alg1Analysis
    % MASS Example using blind methods:
    % - SEP_ABYK, SEP_MCLP, SEP_TTSE SEP plugins
    % - DS_SS1-3_GS1_3x4_RT60-0.1s.mat
    
    methods
        % **************************************************************
        % Constructor
        function obj = Config_MASS_Ex0_GS1_3x3_Alg4Analysis()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'MASS Example 0';
            obj.configDescr = 'MASS Example 0: SASS Enhancement via Sel-Competition';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Define Plugin Instances
            obj.SEP = [PluginInst('SEP_SupSysId',0)];
        end
    end
end


classdef Config_MASS_Ex2_GS1_3x4 < Config_MASS_Ex1_GS1_3x4
    % MASS Example using blind methods:
    % - SEP_ABYK, SEP_MCLP, SEP_TTSE SEP plugins
    % - DS_SS1-3_GS1_3x4_RT60-0.1s.mat
    
    methods
        % **************************************************************
        % Constructor
        function obj = Config_MASS_Ex2_GS1_3x4()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'MASS Example 2';
            obj.configDescr = 'MASS Example 2: Blind MASS';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Define Plugin Instances
            obj.SEE = [PluginInst('SEE_MinXcorrSelect',0)];
            obj.SNUM = [PluginInst('SNUM_NumObs',0)];
        end
    end
end


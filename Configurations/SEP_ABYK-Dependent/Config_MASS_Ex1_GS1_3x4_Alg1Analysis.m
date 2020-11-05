classdef Config_MASS_Ex1_GS1_3x4_Alg1Analysis < Config_MASS_Ex1_GS1_3x4
    % MASS Example using blind methods:
    % - SEP_ABYK, SEP_MCLP, SEP_TTSE SEP plugins
    % - DS_SS1-3_GS1_3x4_RT60-0.1s.mat
    
    methods
        % **************************************************************
        % Constructor
        function obj = Config_MASS_Ex1_GS1_3x4_Alg1Analysis()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'MASS Example 1';
            obj.configDescr = 'MASS Example 1: Semi-Blind MASS';
            obj.configAbbr = class(obj);
            
            obj.SEP = [PluginInst('SEP_MCLP',0)];
            obj.SEE = [PluginInst('SEE_Identity',0)];
        end
    end
end


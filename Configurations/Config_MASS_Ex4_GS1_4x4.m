classdef Config_MASS_Ex4_GS1_4x4 < Config_MASS_Ex3_GS1_4x4
    % MASS Example using blind methods:
    % - SEP_MCLP, SEP_TTSE SEP plugins
    % - DS_SS1-3_GS1_3x4_RT60-0.1s.mat
%
% The abstract Configuration is given in Sect. 3.5 of [1, pp. 76-77], while
% particular instances are given throughout Ch. 5 of [1].
%
% [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

    
    methods
        % **************************************************************
        % Constructor
        function obj = Config_MASS_Ex4_GS1_4x4()
            
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


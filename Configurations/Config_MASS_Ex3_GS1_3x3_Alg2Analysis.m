classdef Config_MASS_Ex3_GS1_3x3_Alg2Analysis < Config_MASS_Ex3_GS1_3x3
    % Single Algorithm Source Separation (SASS) Example using blind method:
    % - SEP_TTSE SEP plugin
    % - DS_SS1-3_GS1_3x3_RT60-0.1s.mat
%
% The abstract Configuration is given in Sect. 3.5 of [1, pp. 76-77], while
% particular instances are given throughout Ch. 5 of [1].
%
% [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

    
    methods
        % **************************************************************
        % Constructor
        function obj = Config_MASS_Ex3_GS1_3x3_Alg2Analysis()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'SASS Example: SEP_TTSE';
            obj.configDescr = 'SASS Example: SEP_TTSE';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Define Plugin Instances
            obj.SEP = [PluginInst('SEP_TTSE',0)];
            obj.SEE = [PluginInst('SEE_Identity',0)];
            
        end
    end
end


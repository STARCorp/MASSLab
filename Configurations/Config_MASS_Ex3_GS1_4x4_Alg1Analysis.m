classdef Config_MASS_Ex3_GS1_4x4_Alg1Analysis < Config_MASS_Ex3_GS1_4x4
    % Single Algorithm Source Separation (SASS) Example using blind method:
    % - SEP_MCLP SEP plugin
    % - DS_SS1-3_GS1_4x4_RT60-0.1s.mat
%
% The abstract Configuration is given in Sect. 3.5 of [1, pp. 76-77], while
% particular instances are given throughout Ch. 5 of [1].
%
% [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

    
    methods
        % **************************************************************
        % Constructor
        function obj = Config_MASS_Ex3_GS1_4x4_Alg1Analysis()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'SASS Example: SEP_MCLP';
            obj.configDescr = 'SASS Example: SEP_MCLP';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Define Plugin Instances
            obj.SEP = [PluginInst('SEP_MCLP',0)];
            obj.SEE = [PluginInst('SEE_Identity',0)];
        end
    end
end


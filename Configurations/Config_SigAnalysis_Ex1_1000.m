classdef Config_SigAnalysis_Ex1_1000 < Config_SigAnalysis_Ex1_500
%
% The abstract Configuration is given in Sect. 3.5 of [1, pp. 76-77], while
% particular instances are given throughout Ch. 5 of [1].
%
% [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

    
    methods
        % **************************************************************
        % Constructor
        function obj = Config_SigAnalysis_Ex1_1000()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'Signal Analysis Example 1';
            obj.configDescr = 'Signal Analysis Example 1: SIR of Static Signals';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Define Plugin Instances
            obj.SEA = PluginInst('SEA_SIR',10);
            
        end
    end
end


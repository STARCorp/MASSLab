classdef Config_SigAnalysis_Ex2_1000_2 < Config_SigAnalysis_Ex1_1000
%
% The abstract Configuration is given in Sect. 3.5 of [1, pp. 76-77], while
% particular instances are given throughout Ch. 5 of [1].
%
% [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

    
    methods
        % **************************************************************
        % Constructor
        function obj = Config_SigAnalysis_Ex2_1000_2()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'Signal Analysis Example 2';
            obj.configDescr = 'Signal Analysis Example 2: Block-level Analysis';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Set SEM Signal Processing Properties
            obj.semBlkLen = -2;
            obj.semBlkStep = -2;

            % **********************************************************
            % Define Plugin Instances
            obj.SEA = PluginInst('SEA_SIR',0);
        end
    end
end


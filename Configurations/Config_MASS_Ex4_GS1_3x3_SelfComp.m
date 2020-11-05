classdef Config_MASS_Ex4_GS1_3x3_SelfComp < Config_MASS_Ex4_GS1_3x3
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
        function obj = Config_MASS_Ex4_GS1_3x3_SelfComp()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'MASS Example 4';
            obj.configDescr = 'MASS Example 4: Blind MASS with Self-Competition';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Set SEM Signal Processing Properties
            obj.semSelfComp = 1;
        end
    end
end


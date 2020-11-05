classdef Config_Analysis_Ex1_10 < Config_Analysis_Ex1_2
   
    methods
        % **************************************************************
        % Constructor
        function obj = Config_Analysis_Ex1_10()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'Analysis Example 1';
            obj.configDescr = 'Analysis Example 1: Block processing and Block-level Analysis';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Set SEM Signal Processing Properties
            obj.semBlkLen = -10;
            obj.semBlkStep = -10;
            
        end
    end
end


classdef Config_Analysis_Ex1_5 < Config_Analysis_Ex1_2
   
    methods
        % **************************************************************
        % Constructor
        function obj = Config_Analysis_Ex1_5()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'Analysis Example 1';
            obj.configDescr = 'Analysis Example 1: Block processing and Block-level Analysis';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Set SEM Signal Processing Properties
            obj.semBlkLen = -5;
            obj.semBlkStep = -5;
            
        end
    end
end


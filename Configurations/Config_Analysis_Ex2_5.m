classdef Config_Analysis_Ex2_5 < Config_Analysis_Ex2_2
   
    methods
        % **************************************************************
        % Constructor
        function obj = Config_Analysis_Ex2_5()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'Analysis Example 2';
            obj.configDescr = 'Analysis Example 2: Block processing and Batch Analysis';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Set SEM Signal Processing Properties
            obj.semBlkLen = -5;
            obj.semBlkStep = -5;
            
            obj.SEA = PluginInst('SEA_SIR', 10);
            
        end
    end
end


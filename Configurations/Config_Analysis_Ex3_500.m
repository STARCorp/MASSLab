classdef Config_Analysis_Ex3_500 < Config_Analysis_Ex2_30
   
    methods
        % **************************************************************
        % Constructor
        function obj = Config_Analysis_Ex3_500()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'Analysis Example 3';
            obj.configDescr = 'Analysis Example 3: SEA Imaging Filter Length';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Set SEM Signal Processing Properties
            obj.semBlkLen = -30;
            obj.semBlkStep = -30;
            
            obj.SEA = PluginInst('SEA_SIR', 11);
            
        end
    end
end


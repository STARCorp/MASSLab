classdef PAS_SupSrcCoh < PASPlugin
    
    properties (Access = private)
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = PAS_SupSrcCoh(ParamSetId)
            obj.pluginName = 'Default Config Plugin';
            obj.pluginVersion ='0.0.1';
            obj.pluginAbbr = 'ConfigPluginDefault';
            obj.pluginDescr = 'Lists Configurations in the Configuration directory for user to choose';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements
            obj.reqSrcEstGroup = 0;
            obj.reqSrcEstTA = 0;
            obj.reqSrcEstCDS = 0;
            obj.reqSrcEst = 0;
            obj.reqSrcNum = 0;
            obj.reqSrcSig = 0;
            obj.reqObsSig = 0;
            obj.reqBlkLenMin = [];
            obj.reqBlkLenMax = [];
        end
        
        % Initialization routine, called before runtime
        function obj = Init(obj)
            obj.pluginStatus = 1;
        end
        
        % Update routine, called during runtime  
        function obj = Update(obj)
        end
    end
    
end


classdef SNUM_SupSrc < SNUMPlugin
   
    properties (Access = private)
        
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SNUM_SupSrc(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'SNUM Plugin Using the known sources';
            obj.pluginVersion ='0.0.1';
            obj.pluginAbbr = 'SNUM_SupSrc';
            obj.pluginDescr = 'Source enumeration with known sources, and the sum of sources'' images'' envelopes';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements
            obj.reqSrcSig = 1;
            obj.reqBlkLenMin = -1;
            obj.reqBlkLenMax = [];
        end
        
        % Initialization routine, called before runtime
        function obj = Init(obj)
            obj.pluginStatus = 1;
        end
        
        % Update routine, called during runtime  
        function obj = Update(obj)
            [N,P]=size(obj.semObsSig);
            Q = size(obj.semSrcSig,2);
            obj.srcNum = Q*ones(N,P);
        end
    end
    
end


classdef SNUM_SupSrcTVEnv < SNUMPlugin

    properties (Access = private)
        cdsFiltLen = [];
        cdsFiltOffset = [];
        sampRate = [];
        envThresh = 0.01;
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SNUM_SupSrcTVEnv(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'SNUM Plugin Using the known sources';
            obj.pluginVersion ='0.0.1';
            obj.pluginAbbr = 'SNUM_SupSrcTVEnv';
            obj.pluginDescr = 'Source enumeration with known sources, uses imaged source envelopes to determine time-varying number of sources';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements
            obj.reqSrcSig = 1;
            obj.reqBlkLenMin = -1;
            obj.reqBlkLenMax = [];
        end
        
        % Initialization routine, called before runtime
        function obj = Init(obj)
            obj.cdsFiltLen = obj.massInfo.getCDSFiltLen();
            obj.cdsFiltOffset = obj.massInfo.getCDSFiltOffset();
            obj.sampRate = obj.massInfo.getSampRate();
            
            obj.pluginStatus = 1;
        end
        
        % Update routine, called during runtime  
        function obj = Update(obj)
            [N,P]=size(obj.semObsSig);
            Q = size(obj.semSrcSig,2);
            obj.srcNum = zeros(N,P);
            
            srcEnv = zeros(N,Q);
            srcObsEnv = zeros(N,Q,P);
            srcObsImg = zeros(N,Q,P);
            
            for qq=1:Q
                srcEnv(:,qq) = env0_std(obj.semSrcSig(:,qq),obj.sampRate)>obj.envThresh;
            end
                
            for pp=1:P
                krnl = obj.massInfo.SysIdOp(obj.semSrcSig, ...
                    obj.semObsSig(:,pp),obj.cdsFiltLen,obj.cdsFiltOffset);
                [~,srcObsImg(:,:,pp)] = obj.massInfo.CDO(obj.semSrcSig,krnl,[]);
                
                for qq=1:Q
                    srcObsEnv(:,qq,pp) = env0_std(srcObsImg(:,qq,pp),obj.sampRate)>obj.envThresh;
                end
                
                obj.srcNum(:,pp) = sum(srcObsEnv(:,:,pp),2);
            end
        end
    end
    
end


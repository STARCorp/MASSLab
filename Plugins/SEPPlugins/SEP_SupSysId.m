classdef SEP_SupSysId < SEPPlugin
    %Description:
	%The source estimate production plugin (SEPPlugin) SEP_SupSysId is a 
	%supervised method that estimates each of the source signals as a linear 
	%combination of the observation signals via the massInfo.SysIdOp 
	%(see Sects. 1.2.3 and 3.4.3) function. This estimation of the source 
	%signals from the observation signals uses all CDO properties, e.g.
	%filter length, filter offset, etc., defined for the CDO in the 
	%configuration. The CDS produced by massInfo.SysIdOp populates the 
	%se.cds variable, and the CSE produced by the application of the 
	%massInfo.CDO function to the observation data with se.cds as input
	%populates the se.cse variable, at each block.
	%
	%Constructor:
	%SEP_SupSysId( ParamSetId )
	%
	%Common Fields:
	%pluginName = Supervised FIR Deconvolution
	%pluginVersion = 1.0.1
	%pluginAbbr = SEP_SupSysId
	%pluginDescr = Uses System Identification Operator with known sources 
	%	to produce source estimates.
	%
	%Requirement Fields:
	%reqSrcNum = 0 Method does NOT require an SNUMPlugin
	%reqSrcSig = 1 Supervised method, requires source signals
	%reqBlkLenMin = -2 Minimum data-block length is 2s
	%reqBlkLenMax = inf Maximum data-block length is unspecified
	%
	%Parameters: None
	%Parameter Sets: None
    
    properties (Access = private)
%         cdsFiltLen = [];
%         cdsFiltOffset = [];
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SEP_SupSysId(ParamSetId)
            obj.pluginName = 'Supervised FIR Deconvolution';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = 'SEP_SupSysId';
            obj.pluginDescr = 'Uses System Identification Operator with known sources to produce source estimates';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            obj.reqSrcSig = 1;
            obj.reqBlkLenMin = -2;
            obj.reqBlkLenMax = inf;
        end
        
        % Initialization routine, called before runtime
        function obj = Init(obj)
%             obj.cdsFiltLen = obj.massInfo.getCDSFiltLen();
%             obj.cdsFiltOffset = obj.massInfo.getCDSFiltOffset();
        end
        
        % Update routine, called during runtime  
        function obj = Update(obj)
%             obj.se.cds = obj.massInfo.CDSEstimator(obj.semSrcSig);
%             obj.se.cds = obj.massInfo.SysIdOp(obj.semObsSig,obj.semSrcSig,2*obj.cdsFiltLen,2*obj.cdsFiltOffset);
            obj.se.cds = obj.massInfo.SysIdOp(...
                obj.semObsSig,obj.semSrcSig,obj.massInfo.getCDSFiltLen(), ...
                obj.massInfo.getCDSFiltOffset());
            obj.se.sig = obj.massInfo.CDO(obj.semObsSig,obj.se.cds,[]);
%             obj.se.sig = obj.semSrcSig;
        end
        
        function obj = ShutDown(obj)
        end
    end
    
end


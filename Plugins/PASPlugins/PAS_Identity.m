classdef PAS_Identity < PASPlugin
    %Description:
    %The permutation ambiguity solution plugin (PASPlugin) PAS_Identity simply
    %passes the CSEs given as input directly to the output. The PAS_Identity 
    %plugin is useful for evaluating the performance of an individual SEPPlugin, 
    %SEGPlugin, SETAPlugin, SEEPlugin or some combination of those plugins, 
    %by removing the PASPlugin from the signal processing and analysis.
    %
    %Constructor:
    %PAS_Identity(ParamSetId)
    %
    %Common Fields: 
    %pluginName = Identity (Pass Through) PAS Plugin
    %pluginVersion = 1.0.1
    %pluginAbbr = PAS_Identity
    %pluginDescr = Passes source estimates from input to output
    %
    %Requirement Fields:
    %reqSrcEstGroup = 0 Method does not require a SEGPlugin
    %reqSrcEstTA = 0 Method does not require a SETAPlugin
    %reqSrcEstCDS = 0 Method does not require that the CDS for each source
    %   estimate be supplied
    %reqSrcNum = 0 Method does not require a SNUMPlugin
    %reqSrcSig = 0 Blind method, source signals are NOT required
    %reqBlkLenMin = [] Minimum data-block length is unspecified
    %reqBlkLenMax = [] Maximum data-block length is unspecified
    %
    %Parameters: None
    %
    %Parameter Sets: None
    
    properties (Access = private)
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = PAS_Identity(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'Identity (Pass Through) PAS Plugin';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = 'PAS_Identity';
            obj.pluginDescr = 'Passes source estimates from input to output';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements
            obj.reqSrcEstGroup = 0;
            obj.reqSrcEstTA = 0;
            obj.reqSrcEstCDS = 0;
            obj.reqSrcNum = 0;
            obj.reqSrcSig = 0;
            obj.reqBlkLenMin = [];
            obj.reqBlkLenMax = []; 
        end
        
        % Initialization routine, called before runtime
        function obj = Init(obj)
            obj.pluginStatus = 1;
        end
        
        % Update routine, called during runtime  
        function obj = Update(obj)
            obj.cse = obj.semCSE;
        end
    end
    
end


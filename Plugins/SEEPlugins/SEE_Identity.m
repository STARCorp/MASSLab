classdef SEE_Identity < SEEPlugin
    %Description:
    %The source estimate production plugin (SEEPlugin) SEE_Identity takes a set 
    %of source estimates as input and passes those source estimates to the output.
    %The SEE_Identity plugin is useful for evaluating the performance of an 
    %individual SEPPlugin, SEGPlugin, or SETAPlugin, or some combination of 
    %those plugins, by removing the SEEPlugin from the analysis.
    %
    %Constructor:
    %SEE_Identity(ParamSetId)
    %
    %Common Fields:
    %pluginName Identity (Pass Through) SEE Plugin
    %pluginVersion 1.0.1
    %pluginAbbr SEE_Identity
    %pluginDescr Passes source estimates from input to output
    %
    %Requirement Fields:
    %reqSrcEstGroup = 0 Method does not require a SEGPlugin
    %reqSrcEstTA = 0 Method does not require a SETAPlugin
    %reqSrcEstCDS = 0 Method does not require that the CDS for each source
    %   estimate be supplied
    %reqSrcNum = 0 Method does NOT require an SNUMPlugin
    %reqSrcSig = 0 Blind method, does NOT require source signals
    %reqBlkLenMin = [] Minimum data-block length is unspecified
    %reqBlkLenMax = [] Maximum data-block length is unspecified
    %
    %Parameters: None
    %
    %Paramter Sets: None
    
    properties (Access = private)
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SEE_Identity(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'Identity (Pass Through) SEE Plugin';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = 'SEE_Identity';
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
            obj.cse.sig = obj.semSrcEstArr.sig;
            obj.cse.cds = obj.semSrcEstArr.cds;
        end
    end
    
end


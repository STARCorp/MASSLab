classdef SEE_SupSIRSelect < SEEPlugin
    %Description:
    %The source estimate evaluation plugin (SEEPlugin) SEE_SupSIRSelect is a
    %supervised method that selects the source estimates based upon SIR 
    %(see Sect. 1.3.6). That is, for a set of Q known sources and a set of 
    %source estimates (SEs), the
    %SEE_SupSIRSelect plugin evaluates the SIR for each known source in each 
    %SE and then passes through the Q SEs that provide the maximum SIR for 
    %each of the known sources. The method assumes that (only) Q sources are 
    %present in any CSE set, thus it always produces a CSE set containing 
    %Q source estimates.
    %
    %Constructor:
    %SEE_SupSIRSelect(ParamSetId)
    %
    %Common Fields:
    %pluginName = Selection based SEE via SIR Evaluation
    %pluginVersion = 1.0.1
    %pluginAbbr = SEE_SupSIRSelect
    %pluginDescr = Selection based SEE via SIR Evaluation
    %
    %Requirement Fields:
    %reqSrcEstGroup = 0 Method does not require a SEGPlugin
    %reqSrcEstTA = 0 Method does not require a SETAPlugin
    %reqSrcEstCDS = 0 Method does not require that the CDS for each source
    %   estimate be supplied
    %reqSrcNum = 0 Method does NOT require an SNUMPlugin
    %reqSrcSig = 1 Supervised method, requires source signals
    %reqBlkLenMin = -1 Minimum data-block length is 1s
    %reqBlkLenMax = inf Maximum data-block length is unspecified
    %
    %Parameters:
    %filtLen = Imaging filter length, in samples 
    %   Range: filtLen > 1 
    %   Defaukt: semCDSFiltLen
    %filtOffset = A delay to ensure causal solutions, in samples
    %   Range: filtOffset ? 0 
    %   Default: 50
    %
    %Parameter Sets:
    %ID: 0
    %   Parameter Values: filtLen = semCDSFiltLen filtOffset is given by 
    %       SEE_SupSIRSelect_params()
    %   SEE Mode: Block
    %ID: 1
    %   Parameter Values: filtLen = 0.5 x semCDSFiltLen filtOffset is given 
    %       by SEE_SupSIRSelect_params()
    %   SEE Mode: Block
    %ID: 2
    %   Parameter Values: filtLen = 2 x semCDSFiltLen filtOffset is given by 
    %       SEE_SupSIRSelect_params()
    %   SEE Mode: Block
    %ID: 3
    %   Parameter Values: filtLen = 3 x semCDSFiltLen filtOffset is given by 
    %       SEE_SupSIRSelect_params()
    %   SEE Mode: Block
    %ID: 4
    %   Parameter Values: filtLen = 4 x semCDSFiltLen filtOffset is given by 
    %       SEE_SupSIRSelect_params()
    %   SEE Mode: Block
    %ID: 10
    %   Parameter Values: filtLen = semCDSFiltLen filtOffset is given by 
    %       SEE_SupSIRSelect_params()
    %   SEE Mode: Batch
    %ID: 11
    %   Parameter Values: filtLen = 0.5 x semCDSFiltLen filtOffset is given by 
    %       SEE_SupSIRSelect_params()
    %   SEE Mode: Batch
    %ID: 12
    %   Parameter Values: filtLen = 2 x semCDSFiltLen filtOffset is given by 
    %       SEE_SupSIRSelect_params()
    %   SEE Mode: Batch
    %ID: 13
    %   Parameter Values: filtLen = 3 x semCDSFiltLen filtOffset is given by 
    %       SEE_SupSIRSelect_params()
    %   SEE Mode: Batch
    %ID: 14
    %   Parameter Values: filtLen = 4 x semCDSFiltLen filtOffset is given by 
    %       SEE_SupSIRSelect_params()
    %   SEE Mode: Batch
    
    properties (Access = private)
        params = SEE_SupSIRSelect_params();
        filtLen = 1000;
        filtOffset = 0; %params.filtOffset;
        result = [];
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SEE_SupSIRSelect(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'Selection-based SEE via SIR Evaluation';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = 'SEE_SupSIRSelect';
            obj.pluginDescr = 'Selection-based SEE via SIR Evaluation';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements
            obj.reqSrcEstGroup = 0; 
            obj.reqSrcEstTA = 0;
            obj.reqSrcNum = 0;
            obj.reqSrcSig = 1;
            obj.reqSigFull = 0;
            if obj.paramSetId >= 10, obj.reqSigFull = 1; end
            
            obj.reqBlkLenMin = -1;
            obj.reqBlkLenMax = inf;
        end
        
         % Initialization routine, called before runtime
        function obj = Init(obj)
            obj.filtLen = obj.massInfo.getCDSFiltLen();
            obj.filtOffset = obj.params.filtOffset; %obj.massInfo.getCDSFiltOffset();
            
            switch obj.paramSetId
                case 1, obj.filtLen = round(obj.filtLen/2); 
%                     obj.filtOffset = round(obj.filtOffset/2); 
                case 11,
                    obj.filtLen = round(obj.filtLen/2);
%                     obj.filtOffset = round(obj.filtOffset/2);
                case 2,
                    obj.filtLen = 2*obj.filtLen;
%                     obj.filtOffset = 2*obj.filtOffset;
                case 12,
                    obj.filtLen = 2*obj.filtLen;
%                     obj.filtOffset = 2*obj.filtOffset;
                case 3,
                    obj.filtLen = 3*obj.filtLen;
%                     obj.filtOffset = 2*obj.filtOffset;
                case 13,
                    obj.filtLen = 3*obj.filtLen;
%                     obj.filtOffset = 2*obj.filtOffset;
                case 4,
                    obj.filtLen = 4*obj.filtLen;
%                     obj.filtOffset = 2*obj.filtOffset;
                case 14,
                    obj.filtLen = 4*obj.filtLen;
%                     obj.filtOffset = 2*obj.filtOffset;
            end
            
            obj.pluginStatus = 1;
        end
        
        % Update routine, called during runtime  
        function obj = Update(obj)
            obj.result = [];
            obj.cse=[];
            cse = obj.semSrcEstArr.sig;
            Q = size(obj.semSrcSig,2);
            srcNdx = 1:Q;
            
            if obj.reqSigFull == 1
%                 ndx = 1:20*obj.massInfo.getSampRate();
                cse = obj.massInfo.CDO(obj.semObsSig, obj.semSrcEstArr.cds,[]);
            end
            
            for kk = 1:size(cse,2)
                obj.result(kk,:) = sir_lsfilt(obj.semSrcSig,cse(:,kk),obj.filtLen,obj.filtOffset);
            end
            
            
%             for kk=1:Q
%                 [ii,jj] = find(obj.result == max(obj.result(:)),1);
%                 obj.cse.sig(:,jj) = obj.semSrcEstArr.sig(:,ii);
%                 obj.cse.cds(:,:,jj) = obj.semSrcEstArr.cds(:,:,ii);
%                 obj.result(ii,:) = -1; obj.result(:,jj) = -1;
%             end
            
            mxval = max(obj.result,[],1);
            ndx=nan(1,numel(mxval));
            for kk = 1:numel(mxval)
                ndx(kk) = find(obj.result(:,kk)==mxval(kk),1);
                obj.cse.sig(:,kk) = obj.semSrcEstArr.sig(:,ndx(kk));
                obj.cse.cds(:,:,kk) = obj.semSrcEstArr.cds(:,:,ndx(kk));
            end
            
%             seeSIR = mxval


%             for kk=1:size(obj.semSrcSig,2)
%                 obj.cse.sig(:,kk) = obj.semSrcEstArr.sig(:,obj.result(:,kk)==mxval(kk));
%                 
%                 obj.cse.cds(:,kk) = obj.semSrcEstArr.sig(:,obj.result(:,kk)==mxval(kk));
%             end
%             obj.result
        end
    end
    
end


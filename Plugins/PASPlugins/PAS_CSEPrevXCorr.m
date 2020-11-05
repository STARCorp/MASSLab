classdef PAS_CSEPrevXCorr < PASPlugin
    %Description:
	%The permutation ambiguity solution plugin (PASPlugin) PAS_CSEPrevXcorr is a
	%blind method that maximizes the cross-correlation between current and the last block’s
	%CDSs to resolve the permutation ambiguity. The method is primitive in that, if the last
	%block’s CDS estimates ? sources, then PAS_CSEPrevXcorr will output ? CSEs. Thus,
	%any error in estimating the number of sources will be propagated by PAS_CSEPrevXcorr.
	%To understand the implications of this deficiency, we now give a quick technical
	%description of the method.
    %
    %Constructor:
    %PAS_CSEPrevXcorr(ParamSetId)
    %
    %Common Fields:
    %pluginName = PAS via past and current CDS Cross-Correlation
    %pluginVersion = 1.0.1
    %pluginAbbr = PAS_CSEPrevXcorr
    %pluginDescr = PAS using cross-corrleation of CSEs produced from current and past
    %   CDSs applied to current observations
    %
    %Requirement Fields:
    %reqSrcEstGroup = 0 Method does not require a SEGPlugin
    %reqSrcEstTA = 0 Method does not require a SETAPlugin
    %reqSrcEstCDS = 0 Method does not require that the CDS for each source
    %   estimate be supplied
    %reqSrcNum = 0 Method does not require a SNUMPlugin
    %reqSrcSig = 0 Blind method, source signals are NOT required
    %reqBlkLenMin = -1 Minimum data-block length is 1s
    %reqBlkLenMax = -60 Maximum data-block length is 60s
    %
    %Parameters: None
    %
    %Parameter Sets: None
    
    properties (Access = private)
        xcThreshVals = 0:.1:1;
        xcThresh = 0.5;
        xcMaxLag = 100;
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = PAS_CSEPrevXCorr(ParamSetId)
            obj.pluginName = 'PAS Plugin via Cross-Correlation';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = 'PAS_CSEPrevXCorr';
            obj.pluginDescr = 'PAS using cross-corrleation of CSEs produced from current and past CDSs applied to current observations';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements
            obj.reqSrcEstGroup = 0;
            obj.reqSrcEstTA = 0;
            obj.reqSrcEstCDS = 0;
            obj.reqSrcNum = 1;
            obj.reqSrcSig = 0;
            obj.reqBlkLenMin = -1;
            obj.reqBlkLenMax = -60;
            
%             if obj.paramSetId == 1, obj.reqSrcNum = 1; end
                
        end
        
        % Initialization routine, called before runtime
        function obj = Init(obj)
            if ~isempty(obj.paramSetId) && obj.paramSetId>0 && obj.paramSetId<=11, 
                obj.xcThresh = obj.xcThreshVals(obj.paramSetId);
            end
            
            obj.pluginStatus = 1;
        end
        
        % Update routine, called during runtime  
        function obj = Update(obj)
            
            if isempty(obj.semCDSPrev)
                obj.cse = obj.semCSE;
%                 obj.cds = obj.semCDS;
            else
                cse = obj.semCSE; %obj.massInfo.CDO(obj.semObsSig,obj.semCDS,'');
                csePrevSig = obj.massInfo.CDO(obj.semObsSig,obj.semCDSPrev,'');
                
%                 obj.massInfo.getNumSrc();
%                 Q = max(ans(:));
                
                obj.cse.sig = csePrevSig;
                obj.cse.cds = obj.semCDSPrev;
                
                N = size(cse.sig,2); Np = size(csePrevSig,2);
                xcmat = nan(N,Np);
                
                for jj=1:N
                    for kk=1:Np
                        xcmat(jj,kk) = max(abs(xcorr(cse.sig(:,jj),csePrevSig(:,kk),2000,'coeff')));
                    end
                end
                
                for kk=1:Np
                    jj = find(xcmat(:,kk)==max(xcmat(:,kk)),1);
                    obj.cse.sig(:,kk) = cse.sig(:,jj);
                    obj.cse.cds(:,:,kk) = cse.cds(:,:,jj);
                    
                    xcmat(jj,:) = -1; xcmat(:,kk) = -1;
                end
                        
%                 
%                 cndx = logical(ones(1,N));
%                 for kk=1:Np,
%                     ndx = find(xcmat(:,kk)==max(xcmat(:,kk)),1);
%                     if xcmat(ndx,kk) > obj.xcThresh
%                         cndx(ndx)=0;
%                         obj.cse.sig(:,kk) = cse.sig(:,ndx);
%                         obj.cse.cds(:,:,kk) = cse.cds(:,:,ndx);
%                     end
%                 end
                

            end
        end
    end
    
end


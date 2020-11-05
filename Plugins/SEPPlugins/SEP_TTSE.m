classdef SEP_TTSE < SEPPlugin
    % SEP via Source Extraction for Intermittent sources
	%Description:
	%The source estimate production plugin (SEPPlugin) SEP_TTSE implements a
	%convolutive blind source extraction (BSE) method for sources that 
	%intermittently become silent. The method is dubbed the turn-taking 
	%source extraction (TTSE) method for the way intermittent sources tend 
	%to take turns, e.g. conversational speech. The method makes many 
	%assumptions, but crucially, when the mixing system is critically- or 
	%overdetermined with an intermittent source, a source extraction 
	%solution for the intermittent source is available via a system 
	%identification problem and a full discussion of the method
	%is given in [1] Appendix A.
    %
	% [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
    %     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
    %
	%Constructor:
	%SEP_TTSE ( ParamSetId )
	%
	%Common Fields:
	%pluginName = Source Extraction for Intermittent Sources
	%pluginVersion = 0.0.1
	%pluginAbbr = SEP_TTSE
	%pluginDescr = Source Extraction when some sources are intermittently silent
	%
	%Requirement Fields:
	%reqSrcNum = 0 Method does NOT require a SNUMPlugin
	%reqSrcSig = 0 Blind method, does NOT require source signals
	%reqBlkLenMin = -2 Minimum data-block length is 2s
	%reqBlkLenMax = inf Maximum data-block length is unspecified
	%
	%Parameters:
	%reqWinLen = Sub-block length, in seconds
	%	Range: reqWinLen > 1
	%	Default: 1
	%reqWinStep = A delay to ensure causal solutions, in seconds
	%	Range: reqWinStep ? 0
	%	Default: 0.25
	%
	%Parameter Sets:
	%ID: 0
	%	Paramter Values: Given by SEP_TTSE_params_default() function
	%	SEP Mode: Competitive
	%ID: 1
	%	Parameter Values: Given by SEP_TTSE_params() function
	%	SEP Mode: Competitive
	
    
    properties (Access = private)
        params = SEP_TTSE_params_default();

        winLen = []; % analysis window length in samples, set in Init()
        winStep = []; % analysis window step length in samples, set in Init()
        win = [];
        winNdx = 0;
        sampRate = [];
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SEP_TTSE(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'Source Extraction for Intermittent Sources';
            obj.pluginVersion ='0.0.1';
            obj.pluginAbbr = class(obj);
            obj.pluginDescr = 'Potential Source Extraction when some sources are intermittently silent';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements 
            obj.reqSrcSig = 0;
            obj.reqBlkLenMin = -2; %-9.95;
            obj.reqBlkLenMax = inf;
        end
        
        % Initialization routine, called after SEM configuration, but before runtime
        % The massInfo object is now available for the plugin to query the MASS system
        function obj = Init(obj)
            if obj.paramSetId == 1, obj.params = SEP_TTSE_params(); end

            obj.sampRate = obj.massInfo.getSampRate();
            obj.winLen = round(obj.sampRate*obj.params.reqWinLen);
            obj.winStep = round(obj.sampRate*obj.params.reqWinStep);
            obj.win = 1:obj.winLen;
            
            obj.pluginStatus = 1;
        end
        
        % Update routine, called during runtime at each data block 
        function obj = Update(obj)
            obj.se.sig = [];
            obj.se.cds = [];
            obj.winNdx = 0;
            [N,P] = size(obj.semObsSig);
            
            mxNdx = ceil((N-obj.winLen)/obj.winStep );
            cds = zeros(obj.semCDSFiltLen,P,mxNdx);
%             se = zeros(N,ceil(N/obj.winStep));
            offset = zeros(mxNdx,1);
            lstndx = size(obj.semObsSig,2);
            
            while (obj.winNdx*obj.winStep + obj.win) <= N
                win = obj.winNdx*obj.winStep + obj.win;
                obj.winNdx = obj.winNdx + 1;
                ndx = P; ondx = (1:P)~=ndx;
                
                [cds(:,1:end-1,obj.winNdx), offset(obj.winNdx)] = ...
                    obj.massInfo.SysIdOp(obj.semObsSig(win,ondx),...
                    obj.semObsSig(win,ndx),obj.semCDSFiltLen,obj.semCDSFiltOffset);
                cds(offset(obj.winNdx)+1,lstndx,obj.winNdx) = -1;
                
%                 [cds(:,2:end,obj.winNdx), offset(obj.winNdx)] = ...
%                     obj.massInfo.SysIdOp(obj.semObsSig(win,2:end),...
%                     obj.semObsSig(win,1),obj.semCDSFiltLen,obj.semCDSFiltOffset);
%                 cds(offset(obj.winNdx)+1,1,obj.winNdx) = -1;
            end
            cds = -cds;
            
            se = obj.massInfo.CDO(obj.semObsSig,cds,[]);
            
            seVar = var(se);
            seNdx = zeros(min(P,mxNdx),1);
            for pp=1:min(P,mxNdx);
                seNdx(pp) = find(seVar==max(seVar));
                seVar(seNdx(pp)) = -1;
            end
            
            obj.se.sig = se(:,seNdx);
%             obj.se.cds = cds(:,:,seNdx);

        end
            
    end
    
end


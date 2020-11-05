classdef SEP_MCLP < SEPPlugin
    % SEP via Multi-Channel Linear Prediction
	%Description:
	%The source estimate production plugin (SEPPlugin) SEP_MCLP implements the
	%convolutive blind source extraction (BSE) method given by Delcroix et al. 
	%in [45] and [46]. This underlying method is a multi-channel version of 
	%the linear prediction problem (see Sect. 1.2.3) and was originally 
	%intended as a blind dereverberation method for an acoustic source in the 
	%presence of a compact noise source. However, the method is actually a 
	%BSE method under certain source and sensor location geometries. 
	%In particular, the SEP_MCLP can extract a source of interest (SOI) if 
	%the SOI is closer to a particular sensor than any other source, and all 
	%the other sources are closer than the SOI to all the other sensors.
	%
	%Constructor:
	%SEP_MCLP ( ParamSetId )
	%
	%Common Fields:
	%pluginName = SEP via Multi-Channel Linear Prediction
	%pluginVersion = 1.0.1
	%pluginAbbr = SEP_MCLP
	%pluginDescr = Potential Source Extraction via Multi-Channel Linear Prediction
	%
	%Requirement Fields:
	%reqSrcNum = 0 Method does NOT require a SNUMPlugin
	%reqSrcSig = 0 Blind method, does NOT require source signals
	%reqBlkLenMin = -2 Minimum data-block length is 2s
	%reqBlkLenMax = inf Maximum data-block length is unspecified
	%
	%Parameters:
	%filtLen = Prediction filter length in samples
	%	Range: filtLen > 0
	%	Default: 400
	%arOrder = Number of poles in estimated AR spectrum for de-whitening
	%	Range: arOrder > 0
	%	Default: 20
	%siFiltLen = Imaging filter length in samples in dewhitening process
	%	Range: siFiltLen > 0
	%	Default: 200
	%siFiltLag = Number of samples to delay error signal in imaging for 
	%	de-whitening process
	%	Range: 0 ? siFiltLag < siFiltLen
	%	Default: 20
	%
	%Parameter Sets:
	%ID: 0
	%	Parameter Values: Given by SEP_MCLP_params_default() function
	%	SEP Mode: Competitive
	%ID: 1
	%	Parameter Values: Given by SEP_MCLP_params() function
	%	SEP Mode: Competitive
    
    properties (Access = private)
        params = SEP_MCLP_params_default();
        
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SEP_MCLP(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'SEP via Multi-Channel Linear Prediction';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = class(obj);
            obj.pluginDescr = 'Potential Source Extraction via Multi-Channel Linear Prediction';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements 
            obj.reqSrcNum = 0;
            obj.reqSrcSig = 0;
            obj.reqBlkLenMin = -2; %-9.95;
            obj.reqBlkLenMax = inf;
        end
        
        % Initialization routine, called after SEM configuration, but before runtime
        % The massInfo object is now available for the plugin to query the MASS system
        function obj = Init(obj)
            obj.pluginStatus = 1;
            if obj.paramSetId == 1, obj.params = SEP_MCLP_params(); end
        end
        
        % Update routine, called during runtime at each data block 
        function obj = Update(obj)
            obj.se.sig = [];
            
            N = size(obj.semObsSig,2);
            NDX = 1:N;
            for kk=0:N-1
                ndx = circshift(NDX,-kk,2);
                [obj.se.sig(:,kk+1),~] = mclp(obj.semObsSig(:,ndx),obj.params.filtLen, ...
                    obj.params.arOrder,obj.params.siFiltLen,obj.params.siFiltLag);
            end
            obj.se.sig = [obj.se.sig; zeros(1,size(obj.se.sig,2))]; %MCLP uses BLKLEN-1 samples, so pad with 1 extra row of zeros
        end
            
    end
    
end


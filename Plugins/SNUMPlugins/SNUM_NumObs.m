classdef SNUM_NumObs < SNUMPlugin
    %Description
	%The source enumeration plugin (SNUMPlugin) SNUM_NumObs assumes a
	%critically-determined source number, Q, to sensor number, P, scenario 
	%and simply reports the number of sources as the number of observation 
	%signals, i.e. Q=P. The srcNum field is an array the size of semObsSig 
	%populated with the sole value P which is the second dimension of the 
	%semObsSig variable. Thus, this naïve method is blind and assumes all
	%sources are active in every channel of the observations at all times.
	%
	%Constructor:
	%SNUM_NumObs ( ParamSetId )
	%
	%Common Fields:
	%pluginName = SNUMPlugin that assumes critically-determined mixtures
	%pluginVersion = 1.0.1
	%pluginAbbr = SNUM_NumObs
	%pluginDescr = Estimates the number of sources as the number of 
	%	observations (blind, critically-determined)
	%
	%Requirement Fields:
	%reqSrcSig = 0 Blind method, does NOT require source signals
	%reqBlkLenMin = [] Minimum data-block length is unspecified
	%reqBlkLenMax = [] Maximum data-block length is unspecified
	%
	%Parameters: None
	%Paramter Sets: None
    
    properties (Access = private)
        
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SNUM_NumObs(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'SNUMPlugin that assumes critically-determined mixtures';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = 'SNUM_NumObs';
            obj.pluginDescr = 'Estimates the number of sources as the number of observations (blind, critically-determined)';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements
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
            [N,P]=size(obj.semObsSig);
            obj.srcNum = P*ones(N,P);
        end
    end
    
end


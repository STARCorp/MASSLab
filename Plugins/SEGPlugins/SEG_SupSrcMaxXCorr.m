classdef SEG_SupSrcMaxXCorr < SEGPlugin
    
    properties (Access = private)
        
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SEG_SupSrcMaxXCorr(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'SEG Plugin Using the known sources';
            obj.pluginVersion ='0.0.1';
            obj.pluginAbbr = 'SEG_SupSrcMaxXCorr';
            obj.pluginDescr = 'Source estimate grouping with known sources';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements
            obj.reqSrcNum = 0;
            obj.reqSrcSig = 1;
            obj.reqObsSig = 0;
            obj.reqBlkLenMin = -1;
            obj.reqBlkLenMax = [];
        end
        
        % Initialization routine, called before runtime
        function obj = Init(obj)
            obj.pluginStatus = 1;
        end
        
        % Update routine, called during runtime  
        function obj = Update(obj)
            [N,Q] = size(obj.semSrcSig);
            obj.seg = repmat(SourceEstimate(),1,Q);
            M = size(obj.semSrcEstArr.sig,2);
            xcmat = nan(Q,M);
            
            for qq=1:Q
                for mm=1:M
                    xcmat(qq,mm) = max(abs(xcorr(obj.semSrcSig(:,qq),obj.semSrcEstArr.sig(:,mm),4000,'coeff')));
                end
            end
            
            for mm=1:M
                ndx = find(xcmat(:,mm) == max(xcmat(:,mm)));
                obj.seg(ndx).sig = [obj.seg(ndx).sig obj.semSrcEstArr.sig(:,mm)];
            end
        end
    end
    
end

















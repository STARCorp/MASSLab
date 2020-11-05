classdef SEE_MinXcorrSelect < SEEPlugin
    %Description:
    %The source estimate evaluation plugin (SEEPlugin) SEE_MinXCorrSelect is a
    %blind method that selects a set of sources such that the maximum 
    %cross-correlation (over a range of lags) between each pair of source 
    %estimates is minimized. The method is semiblind, because it requires that 
    %the number of sources be known or estimated, thus any valid Configuration 
    %using the SEE_MinXCorrSelect plugin must also include a source
    %enumeration plugin (SEEPlugin).
    %
    %Constructor:
    %SEE_MinXCorrSelect(SEEPlugin)
    %
    %Common Fields:
    %pluginName = Selection based SEE via Minimum Source Estimate Cross-correlation
    %pluginVersion = 1.0.1
    %pluginAbbr = SEE_MinXCorrSelect
    %pluginDescr = Selection based SEE via Minimum Source Estimate Cross-correlation
    %
    %Requirement Fields:
    %reqSrcEstGroup = 0 Method does not require a SEGPlugin
    %reqSrcEstTA = 0 Method does not require a SETAPlugin
    %reqSrcEstCDS = 0 Method does not require that the CDS for each source
    %   estimate be supplied
    %reqSrcNum = 1 Semi-Blind method, requires an SNUMPlugin
    %reqSrcSig = 0 Source signals are NOT source signals
    %reqBlkLenMin = -2 Minimum data-block length is 2s
    %reqBlkLenMax = -60 Maximum data-block length is 60s
    %
    %Parameters: None
    %
    %Parameter Sets: None
    
    properties (Access = private)
        filtLen = 1000;
        filtOffset = 250;
        result = [];
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SEE_MinXcorrSelect(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'Selection based SEE via Minimum Source Estimate Cross-correlation';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = 'SEE_MinXcorrSelect';
            obj.pluginDescr = 'Selection based SEE via Minimum Source Estimate Cross-correlation';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements
            obj.reqSrcEstGroup = 0; 
            obj.reqSrcEstTA = 0;
            obj.reqSrcEstCDS = 0;
            obj.reqSrcNum = 1;
            obj.reqSrcSig = 0;
            obj.reqBlkLenMin = -2;
            obj.reqBlkLenMax = -60;
        end
        
         % Initialization routine, called before runtime
        function obj = Init(obj)
            obj.pluginStatus = 1;
        end
        
        % Update routine, called during runtime  
        function obj = Update(obj)
            obj.result = [];
            obj.cse = SourceEstimate();
            obj.massInfo.getNumSrc();
            Q = max(ans(:));
            N = size(obj.semSrcEstArr.sig,2);
            P=size(obj.semObsSig,2);
            ndx = reshape(1:N^2,N,N);
            xcmat = ones(N);
            
            nent = negentropy(mean0_var1(obj.semSrcEstArr.sig));
            
            for jj=1:N-1
                for kk=(jj+1):N
                    abs(xcorr(obj.semSrcEstArr.sig(:,jj),obj.semSrcEstArr.sig(:,kk),4000,'coeff'));
                    xcmat(jj,kk) = max(ans) + mean(ans);
%                     xcmat(jj,kk) = mean(ans);
                end
            end
            
            xcmat = triu(xcmat,1) + triu(xcmat,1).' + eye(N);
            
            cmb = nchoosek(1:N,Q);
            xcdet = ones(size(cmb,1),1);
            nentsm = ones(size(cmb,1),1);
            for kk=1:size(cmb,1)
                xcdet(kk) = det(xcmat(cmb(kk,:),cmb(kk,:)));
                nentsm(kk) = sum(nent(cmb(kk,:)));
            end
            
            M=floor(N/P);
            ndx = zeros(M,1); xcdet0=xcdet;
            for nn=1:M
                ndx(nn) = find(xcdet0==max(xcdet0),1);
                xcdet0(ndx(nn)) = -inf;
            end
            
            [xcdet(ndx) nentsm(ndx) xcdet(ndx) + nentsm(ndx) cmb(ndx,:)];
            
            met = xcdet(ndx) + nentsm(ndx);
            kk = find(met==max(met),1);
            
            cmb(ndx(kk),:);
            
%             kk = find((xcdet+nentsm)==max(xcdet+nentsm),1);
%             kk = find((xcdet+nentsm)==min(1-xcdet),1);
            
%             cmb(kk,:);
%             xcmat(cmb(kk,:),cmb(kk,:));

%             xcmat0=xcmat;
%             
%             cseNdx =[];
%             [cseNdx(1),cseNdx(2)] = find(xcmat==min(xcmat(:)),1);
%             xcmat(cseNdx(1),cseNdx(2))=2;
%             xcmat = triu(xcmat,1) + triu(xcmat,1).' + 2*eye(N);
%             m=3;
%             while numel(cseNdx)<Q
%                mean(xcmat(cseNdx,:),1) + max(xcmat(cseNdx,:),[],1);
%                cseNdx(m) = find(ans == min(ans),1);
%                for kk=1:m-1, xcmat(cseNdx(kk),cseNdx(m)) = 2; xcmat(cseNdx(m),cseNdx(kk)) = 2; end
%                m=m+1;
%             end
            
            obj.cse.sig = obj.semSrcEstArr.sig(:,cmb(ndx(kk),:));
            obj.cse.cds = obj.semSrcEstArr.cds(:,:,cmb(ndx(kk),:));

%             obj.cse.sig = obj.semSrcEstArr.sig(:,cmb(kk,:));
%             obj.cse.cds = obj.semSrcEstArr.cds(:,:,cmb(kk,:));
            
%             cseNdx
            
%             for kk = 1:size(obj.semSrcEstArr.sig,2)
%                 obj.result(kk,:) = sir_lsfilt(obj.semSrcSig,obj.semSrcEstArr.sig(:,kk),obj.filtLen,obj.filtOffset);
%             end
%             
%             mxval = max(obj.result,[],1);
%             for kk=1:size(obj.semSrcSig,2)
%                 obj.cse.sig(:,kk) = obj.semSrcEstArr.sig(:,obj.result(:,kk)==mxval(kk));
%             end
%             obj.result
        end
    end
    
end


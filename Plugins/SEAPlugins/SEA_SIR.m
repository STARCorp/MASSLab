classdef SEA_SIR < SEAPlugin
    %Description:
    %The source estimate evaluation plugin (SEAPlugin) SEA_SIR is a supervised
    %method that calculates SIR (see Sect. 1.3.6) for each source and each 
    %CSE per data block.
    %
    %Constructor: SEA_SIR(ParamSetId)
    %
    %Common Fields:
    %pluginName = SIR Analysis
    %pluginVersion = 1.0.1
    %pluginAbbr = SEA_SIR
    %pluginDescr = SIR Analysis
    %
    %Requirement Fields:
    %reqSrcEstGroup = 0 Method does not require a SEGPlugin
    %reqSrcEstTA = 0 Method does not require a SETAPlugin
    %reqSrcEstCDS = 0 Method does not require that the CDS for each source
    %   estimate be supplied
    %reqSrcNum = 0 Method does not require a SNUMPlugin
    %reqSrcSig = 1 Supervised method, source signals are required
    %reqBlkLenMin = -1 Minimum data-block length is 1s
    %reqBlkLenMax = inf Maximum data-block length is unspecified
    %
    %Parameters:
    %filtLen = Imaging filter length, in samples 
    %   Range: filtLen > 1 
    %   Default: semCDSFiltLen
    %filtOffset = A delay to ensure causal solutions, in samples
    %   Range: filtOffset ? 0 
    %   Default: 50
    %
    %Parameter Sets:
    %ID: 0
    %   Parameter Values: filtLen = semCDSFiltLen
    %       filtOffset is given by SEA_SIR_params()
    %   SEA Mode: Block
    %ID: 1
    %   Parameter Values: filtLen = 0.5 x semCDSFiltLen
    %       filtOffset is given by SEA_SIR_params()
    %   SEA Mode: Block
    %ID: 2
    %   Parameter Values: filtLen = 2 x semCDSFiltLen
    %       filtOffset is given by SEA_SIR_params()
    %   SEA Mode: Block
    %ID: 3
    %   Parameter Values: filtLen = 3 x semCDSFiltLen
    %       filtOffset is given by SEA_SIR_params()
    %   SEA Mode: Block
    %ID: 4
    %   Parameter Values: filtLen = 4 x semCDSFiltLen
    %       filtOffset is given by SEA_SIR_params()
    %   SEA Mode: Block
    %ID: 10
    %   Parameter Values: filtLen = semCDSFiltLen
    %       filtOffset is given by SEA_SIR_params()
    %   SEA Mode: Batch
    %ID: 11
    %   Parameter Values: filtLen = 0.5 x semCDSFiltLen
    %       filtOffset is given by SEA_SIR_params()
    %   SEA Mode: Batch
    %ID: 12
    %   Parameter Values: filtLen = 2 x semCDSFiltLen
    %       filtOffset is given by SEA_SIR_params()
    %   SEA Mode: Batch
    %ID: 13
    %   Parameter Values: filtLen = 3 x semCDSFiltLen
    %       filtOffset is given by SEA_SIR_params()
    %   SEA Mode: Batch
    %ID: 14
    %   Parameter Values: filtLen = 4 x semCDSFiltLen
    %       filtOffset is given by SEA_SIR_params()
    %   SEA Mode: Batch
    
    properties (Access = private)
        params = SEA_SIR_params();
        filtLen = 1000;
        filtOffset = [];
        result = [];
        blkNdx = 1;
        blkStep =[];
        sampRate = [];
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SEA_SIR(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'SIR Analysis';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = class(obj);
            obj.pluginDescr = 'SIR Analysis';
            obj.pluginStatus = 0;
            if ParamSetId >= 0, obj.paramSetId = ParamSetId; 
            else obj.paramSetId = 0;
            end
            
            % Plugin Requirements
            obj.reqSrcEstGroup = 0; 
            obj.reqSrcEstTA = 0;
            obj.reqSrcNum = 0;
            obj.reqSrcSig = 1;
            
            obj.reqSigFull = 0;
            if obj.paramSetId >= 10, obj.reqSigFull = 1; end
            
            obj.reqBlkLenMin = -1;
            obj.reqBlkLenMax = [];
            
            obj.sea.results = [];
            obj.sea.figures(1).handle = [];
            obj.sea.figures(1).name = 'SIRdB-TV-Ind';
            obj.sea.figures(2).handle = [];
            obj.sea.figures(2).name = 'SIRdB-Avg1';
            obj.sea.figures(3).handle = [];
            obj.sea.figures(3).name = 'SIRdB-Avg2';
            obj.sea.figures(4).handle = [];
            obj.sea.figures(4).name = 'SIRLin-Avg';
            obj.sea.figures(5).handle = [];
            obj.sea.figures(5).name = 'SIRdB-TV-All';
            obj.sea.figures(6).handle = [];
            obj.sea.figures(6).name = 'SIRdB-Avg-MaxSrc';
        end
        
         % Initialization routine, called before runtime
        function obj = Init(obj)
            obj.blkStep = obj.massInfo.getBlkStep();
            obj.sampRate = obj.massInfo.getSampRate();
            obj.filtLen = obj.massInfo.getCDSFiltLen();
            obj.filtOffset = obj.params.filtOffset;
            
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
%             obj.sea = [];
            cse = obj.semCSE.sig;
            
            N=size(obj.semCSE.sig,2);
            
            if obj.reqSigFull == 1
%                 ndx = 1:20*obj.massInfo.getSampRate();
                cse = obj.massInfo.CDO(obj.semObsSig, obj.semCSE.cds,[]);
            end
            
%             if obj.blkNdx == 1, obj.result = nan(1,1,N); end
            for kk = 1:N
                if obj.blkNdx == 1
                    obj.sea.results(kk,:,1) = sir_lsfilt(obj.semSrcSig,obj.semObsSig(:,kk),obj.filtLen,obj.filtOffset);
                    
%                     obj.result(kk).met = [];
%                 else
%                     obj.sea(kk).results = [];
                end
                    
%                 obj.sea(kk).results = repmat(sir_lsfilt(obj.semSrcSig,obj.semCSE.sig(:,kk),obj.filtLen,20),N,1);
%                 obj.sea(kk).results = repmat(sir_lsfilt(obj.semSrcSig(ndx,:),cse(:,kk),obj.filtLen,obj.filtOffset),N,1);
%                 obj.sea(kk).results = sir_lsfilt(obj.semSrcSig,obj.semCSE.sig(:,kk),obj.filtLen,obj.filtOffset);
%                 obj.sea(kk).results = repmat(sir_lsfilt(obj.semSrcSig(ndx,:),cse(:,kk),obj.filtLen,obj.filtOffset),N,1);
                obj.sea.results(kk,:,obj.blkNdx+1) = [sir_lsfilt(obj.semSrcSig,cse(:,kk),obj.filtLen,obj.filtOffset)];
                
            end
            
            seaSIR = max(obj.sea.results(:,:,obj.blkNdx+1),[],1);
            
            plotResults(obj,1000);
            
            obj.blkNdx = obj.blkNdx + 1;
        end
        
        function obj = ShutDown(obj)
            
            
%             cmap = [0         0.4470    0.7410;
%                     0.8500    0.3250    0.0980;
%                     0.9290    0.6940    0.1250;
%                     0.4940    0.1840    0.5560;
%                     0.4660    0.6740    0.1880;
%                     0.3010    0.7450    0.9330;
%                     0.6350    0.0780    0.1840;];
%                 
% %             sea(1).figures(1).handles = 
%             ax=[];
%             h = figure(1000 ); clf;
%             hold on
%             for kk=1:Q
%                 ax(kk) = bar((kk-1)+(1:Q:Q^2),10*log10(avgSIR(:,kk)),.2);
%                 set(ax(kk),'FaceColor',cmap(kk,:));
%             end
%             hold off
% %             title(['CSE ' num2str(kk)]);
%             grid on
%             ylabel('Average SIR (dB)');
%             legend(leg,'Location','EastOutside');
%             ylim([-25 25]);
%             set(gca,'XTickLabel',cseLabel);
            
        end
        
        function plotResults(obj,FIGNO)
            
            [N Q M] = size(obj.sea.results);
            cseLabel = {}; srcLabel = {}; srcTick = {''}; cseSrcLabel = {}; cseTick = {''};
            for kk=1:Q, 
                srcLabel{kk} = ['Source ' num2str(kk)]; 
                srcTick{kk+1} = num2str(kk);
            end
            srcTick{end+1}='';
            for kk=1:N, 
                cseLabel{kk} = ['CSE ' num2str(kk)]; 
                cseTick{kk+1} = cseLabel{kk};
            end
            cseTick{end+1}='';
            mm=1;
            for kk=1:N,
                for jj=1:Q
                    cseSrcLabel{mm} = [cseLabel{kk} ': ' srcLabel{jj}];
                    mm=mm+1;
                end
            end
            
            avgSIR = mean(obj.sea.results(:,:,2:end),3);
            
            cmap = get(gca,'ColorOrder');
            cmap = cmap(1:Q,:);
            
            
            % ------------------------------------------------
            t = (0:M-1)*obj.blkStep/obj.sampRate;
            obj.sea.figures(1).handle = figure(FIGNO); clf
            for kk = 1:N
                subplot(N,1,kk);
                plot(t,10*log10(permute(obj.sea.results(kk,:,:),[3 2 1])));
                grid on
                xlabel('Time (s)');
                ylabel('SIR (dB)');
                title(cseLabel{kk});
                legend(srcLabel);
            end
            
            % ------------------------------------------------
            obj.sea.figures(2).handle = figure(FIGNO+1 ); clf 
            
            for kk=1:N
                ax=[];
                subplot(1,N,kk);
                hold on
                for jj=1:Q
                    bar(jj,10*log10(avgSIR(kk,jj)),'FaceColor',cmap(jj,:));
                    title(cseLabel{kk})
                    ax1=gca; ax1.YGrid = 'on'; grid on
                    set(ax1,'XTickLabel',srcTick,'XTick',0:(2+Q));
                    ylabel('Average SIR (dB)');
                    xlabel('Source');
                    ylim([-30 27]);
                end
                hold off
            end
            
%             % ------------------------------------------------
%             obj.sea.figures(3).handle = figure(FIGNO+3 ); clf 
%             
%             for kk=1:N
%                 ax=[];
%                 hold on
% %                 for jj=1:Q
%                     mxAvg = max(avgSIR(kk,:));
%                     jj = find(avgSIR(kk,:)==mxAvg,1);
%                     
%                     bar(kk,10*log10(avgSIR(kk,jj)),'FaceColor',cmap(jj,:));
% %                     title(cseLabel{kk})
%                     ax1=gca; ax1.YGrid = 'on'; grid on
%                     set(ax1,'XTickLabel',cseTick,'XTick',0:(2+Q));
%                     ylabel('Max Avg SIR (dB)');
% %                     xlabel('CSE');
%                     ylim([0 27]);
% %                 end
%                 hold off
%             end
%             legend(srcLabel,'Location','EastOutside');
            
%             % ------------------------------------------------
%             obj.sea.figures(4).handle = figure(FIGNO+4 ); clf
%             bar(1:N,10*log10(avgSIR), .8, 'grouped');
%             ax1=gca; ax1.YGrid = 'on'; colormap(ax1,cmap);
%             ylabel('Average SIR (dB)'); set(ax1,'XTickLabel',cseLabel);
%             legend(srcLabel,'Location','EastOutside');
%             ylim([-30 27]);
           
            
%             % ------------------------------------------------
%             obj.sea.figures(5).handle = figure(FIGNO+5); clf
%             bar3(1:N,avgSIR,.4);
%             ax2=gca; colormap(ax2,cmap);
% %             xlabel('Source'); zlabel('CSE');
%             zlabel('Average SIR (Linear)');
%             set(gca,'XTickLabel',srcLabel);
%             set(gca,'YTickLabel',cseLabel);
            
%             % ------------------------------------------------
%             t = (0:M-1)*obj.blkStep/obj.sampRate;
% %             mrk = {'-x','--^','-.o',':s'}; 
%             mrk = {'-.','--','-',':'};
%             obj.sea.figures(6).handle = figure(FIGNO+6); clf
%             
%             hold on
%             for kk = 1:N
% %                 subplot(N,1,kk);
%                 ax = plot(t,10*log10(permute(obj.sea.results(kk,:,:),[3 2 1])),[mrk{kk}]);
%                 grid on
%                 for jj=1:numel(ax), ax(jj).Color = cmap(jj,:); end
%                 xlabel('Time (s)');
%                 ylabel('SIR (dB)');
%                 
%             end
%             hold off
%             
%             legend(cseSrcLabel,'Location','EastOutside');
            
            
            drawnow();
        end
    end
    
end


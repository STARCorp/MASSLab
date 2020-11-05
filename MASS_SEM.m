classdef (Sealed) MASS_SEM < handle
%     MASS Source Estimate Management
%     Description: The MASS_SEM class coordinates all of the efforts of the
%     various plugins in the MASS framework. In order to use the MASS
%     framework, a user must create and configure an instance of the
%     MASS_SEM class, and then call the MASS_SEM's Start() function.
%     
%     Specialized Functions: Start(), Stop()
%     
%     Constructors: SEM( PluginInst ), SEM( Configuration )
%     
%     See Ch. 2 in [1] for overview 
%     See Sects. 3.1 & 3.2 in [1] for general MASS framework relevancy
%     See Sect. 3.7 in [1] for details of usage
%     
%     [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

    properties (GetAccess=public, SetAccess=private)
        name='MASS Source Estimate Management (SEM) System';
        version='1.0.10';
        abbr='SEM';
        descr='Controls the signal processing workflow in the MASS framework';
    end
    
    properties (Access=private)
        id=1;
        status = 0;
        
        obsExtSig; %ExternalSignal []
        obsSig; % Observation samples
        srcExtSig; %ExternalSignal []
        srcSig; % Source samples
        doDestExtSig; %DO Plugin output destination, ExternalSignal.
        
        % Plugins
        SEP;  SEE = []; PAS = [];  SEG = []; SNUM = [];
        SETA = []; SEA = []; DA = [];  DO = []; CFG = [];
        
        %Processing Parameters
        config = [];
        blkNdx = 1;
        blkLen = [];
        blkStep = [];
        numObsSig = [];
        numSrcSig = [];
%         numSrc = [];
        cdsFiltLen = []; 
        cdsFiltOffset = []; 
        sampRate = [];
        pluginError = [];
        pluginUndef = [];
        verbose = [];
        selfComp = [];
        
        %Demixing Solution
        cse = SourceEstimate(); 
%         cds = []; 
        cdsPrev = []; 
        
        %Source estimates from Plugins
        seArr = SourceEstimate(); 
        seAlg = [];
        seGroup = []; 
        seGroupTA = []; 
        seTA = [];
        srcNum = [];
        
        % SEA Ressults
        seaResults = [];
        
        % Processing flags
        reqSrcEstGroupTA = 0;
        reqSrcEstGroup = 0;
        reqSrcEstTA = 0;
        reqSrcNum = 0;
        reqSrcSig = 0;
        
    end
    
    methods
        %Constructor(s)
        function obj = MASS_SEM(Config)
            if strcmpi(class(Config),'PluginInst')==1
                obj.CFG = eval([Config.pluginClass '(' num2str(Config.pluginParamSetId) ')']);
                if strcmpi(obj.CFG.getSuperClass,'ConfigPlugin')~=1,
                    error('\nERROR in SEM Conctruction: \n%s is not a valid ConfigPlugin Extension.\n',Config.pluginClass);
                end
                        
                obj.config = [];
                obj.status = 0;
            elseif strcmpi(Config.superClassHidden,'Configuration')==1
                obj.config = Config;
                obj.CFG = [];
                obj.status = 1;
            end
            
            obj.semConfiguration();
            obj.semInitialization();
        end
        
        %Data retrieval functions
        function out = getBlkLen(obj), out = obj.blkLen; end
        function out = getBlkStep(obj), out = obj.blkStep; end
        function out = getSampRate(obj), out = obj.sampRate; end
        function out = getNumSrcSig(obj), out = obj.numSrcSig; end
        function out = getNumObsSig(obj), out = obj.numObsSig; end
        function out = getNumSrc(obj), out = obj.srcNum; end
        function out = getCDS(obj), out = obj.cse.cds;  end
        function out = getCDSPrev(obj), out = obj.cdsPrev; end
        function out = getCDSFiltLen(obj), out = obj.cdsFiltLen; end
        function out = getCDSFiltOffset(obj), out = obj.cdsFiltOffset; end
        function out = getConfig(obj), out = obj.config; end
        
        % Miscellaneous Sig Proc functions
        function [img,filt,offset] = ImgOp(obj,S,X,FILTLEN,OFFSET)
%             [img,filt] = lsfilt(S,X,FILTLEN,OFFSET);
            [filt,offset] = obj.SysIdOp(S,X,FILTLEN,OFFSET);
            img = obj.CDO(S,filt,[]);
        end
        
        function [out,img] = CDO(obj,SIG,KRNL,CNV)
            if nargin<3, CNV = []; end
            [out,img] = krnl3_filt( SIG,KRNL,CNV );
        end
        
        function [krnl,offset] = SysIdOp(obj,SIGARR,SIG,FILTLEN,OFFSET)
            krnl = zeros(FILTLEN, size(SIGARR,2), size(SIG,2));
            N=size(SIG,1);
            if size(SIGARR,2)*FILTLEN<1000
%                 tic
                for kk=1:size(SIG,2)
                    off = [];
                    for jj=1:size(SIGARR,2);
                        [r,tau]=xcorr(SIGARR(:,jj),SIG(:,kk),min(2*obj.sampRate,min([obj.sampRate round(obj.blkLen/2)])));
                        off(jj) = tau(abs(r)==max(abs(r)));
                    end
                    offset = max(off)+OFFSET;
                    [~,krnl(:,:,kk)] = lsfilt(SIGARR,SIG(:,kk),FILTLEN,offset);
                end
%                 toc
            else
%                 tic
                for kk=1:size(SIG,2)
                    off = [];
                    for jj=1:size(SIGARR,2);
                        [r,tau]=xcorr(SIGARR(:,jj),SIG(:,kk),min(2*obj.sampRate,min([obj.sampRate round(obj.blkLen/2)])));
                        off(jj) = tau(abs(r)==max(abs(r)));
                    end
                    offset = max(off)+OFFSET;
                    [~,krnl(:,:,kk),e] = lsfiltf(SIGARR,SIG(:,kk),FILTLEN,offset);
                end
%                 toc
            end
            
        end
        function [krnl,offset] = CDSEstimator(obj,SIG)
            [krnl,offset] = obj.SysIdOp(obj.obsSig,SIG,obj.cdsFiltLen,obj.cdsFiltOffset);

        end
        
        % Publicly accessible functionality
        function obj = Stop(obj)
        end
        function obj = Start(obj)
%             if obj.status < 2, obj.semConfiguration(); end
%             if obj.status == 2, obj.semInitialization(); end
            if obj.status == 3, 
%                 try
                    obj.semRuntime(); 
                    obj.semShutDown();
%                 catch ex
%                     obj.semShutDown();
%                 end
            end
        end
    end
    
    methods (Access = private)
        %****************************************************
        % Run configuration routine
        function obj = semConfiguration(obj)
%             try

                if obj.status == 0
                    if isempty(obj.CFG), error('ConfigPlugin failed to instantiate.');
                    else
                        obj.CFG.Init();
                        obj.CFG.Run();
                        obj.config = obj.CFG.config;
                        if ~isempty(obj.config), obj.status=1; end
                    end
                end
                
                if obj.status == 1 && ~isempty(obj.config)
                    
                    % *****************************************************
                    % Initial Configuration Checks
                    errMsg0 = sprintf('\n** ERROR(s) in MASS CONFIGURATION **\n');
                    errMsg = '';
                    
                    if isempty(obj.config.SEP) || isempty(obj.config.SEE) || isempty(obj.config.PAS) ...
                            || isempty(obj.config.DA) || isempty(obj.config.DO)
                        errMsg = sprintf('%s-- REQUIRED PLUGINS: DA,DO,SEP,SEE, and PAS: Missing one ore more plugin definitions.\n',errMsg);
                    end
                        
                    % *****************************************************
                    % Create MASS Info Object
                    massInfo = MASSInfo(obj);
                    
                    % *****************************************************
                    % Gather and Initialize General Configuration Info
                    obj.obsExtSig = obj.config.daObsExtSig;
                    obj.obsSig=[];
                    obj.srcExtSig = obj.config.daSrcExtSig;
                    obj.srcSig=[];
                    obj.doDestExtSig = obj.config.doDestExtSig;
                    
                    obj.sampRate = obj.config.semSampRate;
                    b = [1; -obj.sampRate];
                    
                    if isempty( obj.config.semCDSFiltLen ),
                        errMsg = sprintf('%s-- CDS Filter Length: semCDSFiltLen CANNOT be unspecified.\n',errMsg);
                    else
                        b((obj.config.semCDSFiltLen < 0)+1);
                        obj.cdsFiltLen = round(ans*obj.config.semCDSFiltLen);
                    end
                    
                    if isempty( obj.config.semCDSFiltOffset ),
                        obj.cdsFiltOffset = round(obj.cdsFiltLen/2);
                    else
                        b((obj.config.semCDSFiltOffset < 0)+1);
                        obj.cdsFiltOffset = round(ans*obj.config.semCDSFiltOffset);
                    end
                    
                    b((obj.config.semBlkLen < 0)+1);
                    obj.blkLen = round(ans*obj.config.semBlkLen);
                    obj.blkStep = round(ans*obj.config.semBlkStep);
                    
                    obj.selfComp = obj.config.semSelfComp;
                    obj.pluginError = obj.config.semPluginError;
                    obj.pluginUndef = obj.config.semPluginUndef;
                    obj.verbose = obj.config.semVerbose;
                    
                    blkLenMin = obj.blkLen;
                    blkLenMax = inf;
                    
                    % *****************************************************
                    % Configure SEP Plugins
                    if ~isempty(obj.config.SEP)
                        pluginId=20;
                        for kk=1:numel(obj.config.SEP)
                            obj.SEP(kk).Plugin = eval([obj.config.SEP(kk).pluginClass '(' num2str(obj.config.SEP(kk).pluginParamSetId) ')']);
                            
                            if strcmpi(obj.SEP(kk).Plugin.getSuperClass,'SEPPlugin')~=1, 
                                errMsg = sprintf('%s-- SEPPlugin: %s is not a valid SEPPlugin Extension.\n',errMsg,obj.config.SEP(kk).pluginClass);
                            else
                                %Plugin Requirements
                                if obj.SEP(kk).Plugin.reqSrcNum == 1, obj.reqSrcNum=1; end
                                if obj.SEP(kk).Plugin.reqSrcSig == 1, obj.reqSrcSig=1; end
                                
                                b((obj.SEP(kk).Plugin.reqBlkLenMin < 0)+1);
                                blkLenMin = max([blkLenMin round(ans*obj.SEP(kk).Plugin.reqBlkLenMin)]);
                                b((obj.SEP(kk).Plugin.reqBlkLenMax < 0)+1);
                                blkLenMax = min([blkLenMax round(ans*obj.SEP(kk).Plugin.reqBlkLenMax)]);
                                
                                % SEM Update to Plugin
                                obj.SEP(kk).Plugin.semCDSFiltLen = obj.cdsFiltLen;
                                obj.SEP(kk).Plugin.semCDSFiltOffset = obj.cdsFiltOffset;
                                obj.SEP(kk).Plugin.setMassInfo(massInfo);
                                obj.SEP(kk).Plugin.setPluginId(pluginId);
                                pluginId = pluginId + 1;
                            end
                        end
                        obj.seArr = SourceEstimate();
                        obj.seAlg = repmat(SourceEstimate(),1,numel(obj.SEP));
                    end
                    
                    % *****************************************************
                    % Configure SEE Plugin
                    if ~isempty(obj.config.SEE)
                        obj.SEE = eval([obj.config.SEE.pluginClass '(' num2str(obj.config.SEE.pluginParamSetId) ')']);
                        
                        if strcmpi(obj.SEE.getSuperClass,'SEEPlugin')~=1, 
                            errMsg = sprintf('%s-- SEEPlugin: %s is not a valid SEEPlugin Extension.\n',errMsg,obj.config.SEE.pluginClass);
                        else
                            
                            %Plugin Requirements
                            if obj.SEE.reqSrcEstGroup == 1 && obj.SEE.reqSrcEstTA == 1, 
                                obj.reqSrcEstGroupTA=1; 
                            else
                                if obj.SEE.reqSrcEstGroup == 1, obj.reqSrcEstGroup=1; end
                                if obj.SEE.reqSrcEstTA == 1, obj.reqSrcEstTA=1; end
                            end
                            if obj.SEE.reqSrcNum == 1, obj.reqSrcNum=1; end
                            if obj.SEE.reqSrcSig == 1, obj.reqSrcSig=1; end
                            
                            b((obj.SEE.reqBlkLenMin < 0)+1);
                            blkLenMin = max([blkLenMin round(ans*obj.SEE.reqBlkLenMin)]);
                            b((obj.SEE.reqBlkLenMax < 0)+1);
                            blkLenMax = min([blkLenMax round(ans*obj.SEE.reqBlkLenMax)]);
                                
                            % SEM Update to Plugin
                            obj.SEE.setMassInfo(massInfo);
                            obj.SEE.setPluginId(10);
                        end
                    end
                    
                    % *****************************************************
                    % Configure PAS Plugin
                    if ~isempty(obj.config.PAS)
                        obj.PAS = eval([obj.config.PAS.pluginClass '(' num2str(obj.config.PAS.pluginParamSetId) ')']);
                        
                        if strcmpi(obj.PAS.getSuperClass,'PASPlugin')~=1, 
                            errMsg = sprintf('%s-- PASPlugin: %s is not a valid PASPlugin Extension.\n',errMsg,obj.config.PAS.pluginClass);
                        else
                            
                            %Plugin Requirements
                            if obj.PAS.reqSrcEstGroup == 1 && obj.PAS.reqSrcEstTA == 1, 
                                obj.reqSrcEstGroupTA=1; 
                            else
                                if obj.PAS.reqSrcEstGroup == 1, obj.reqSrcEstGroup=1; end
                                if obj.PAS.reqSrcEstTA == 1, obj.reqSrcEstTA=1; end
                            end
                            if obj.PAS.reqSrcNum == 1, obj.reqSrcNum=1; end
                            if obj.PAS.reqSrcSig == 1, obj.reqSrcSig=1; end
                            
                            b((obj.PAS.reqBlkLenMin < 0)+1);
                            blkLenMin = max([blkLenMin round(ans*obj.PAS.reqBlkLenMin)]);
                            b((obj.PAS.reqBlkLenMax < 0)+1);
                            blkLenMax = min([blkLenMax round(ans*obj.PAS.reqBlkLenMax)]);
                            
                            % SEM Update to Plugin
                            obj.PAS.setMassInfo(massInfo);
                            obj.PAS.setPluginId(11);
                        end
                    end
                    
                    % *****************************************************
                    % Configure SEG Plugin
                    if ~isempty(obj.config.SEG)
                        obj.SEG = eval([obj.config.SEG.pluginClass '(' num2str(obj.config.SEG.pluginParamSetId) ')']);
                        
                        if strcmpi(obj.SEG.getSuperClass,'SEGPlugin')~=1, 
                            errMsg = sprintf('%s-- SEGPlugin: %s is not a valid SEGPlugin Extension.\n',errMsg,obj.config.SEG.pluginClass);
                        else
                            
                            %Plugin Requirements
                            if obj.SEG.reqSrcNum == 1, obj.reqSrcNum=1; end
                            if obj.SEG.reqSrcSig == 1, obj.reqSrcSig=1; end
                            
                            b((obj.SEG.reqBlkLenMin < 0)+1);
                            blkLenMin = max([blkLenMin round(ans*obj.SEG.reqBlkLenMin)]);
                            b((obj.SEG.reqBlkLenMax < 0)+1);
                            blkLenMax = min([blkLenMax round(ans*obj.SEG.reqBlkLenMax)]);
                            
                            % SEM Update to Plugin
                            obj.SEG.setMassInfo(massInfo);
                            obj.SEG.setPluginId(12);
                        end
                    end
                    
                    % *****************************************************
                    % Configure SNUM Plugin
                    if ~isempty(obj.config.SNUM)
                        obj.SNUM = eval([obj.config.SNUM.pluginClass '(' num2str(obj.config.SNUM.pluginParamSetId) ')']);
                        
                        if strcmpi(obj.SNUM.getSuperClass,'SNUMPlugin')~=1, 
                            errMsg = sprintf('%s-- SNUMPlugin: %s is not a valid SNUMPlugin Extension.\n',errMsg,obj.config.SNUM.pluginClass);
                        else
                            
                            %Plugin Requirements
%                             if obj.SNUM.reqSrcEstTA == 1, reqSrcEstTA=1; end
                            if obj.SNUM.reqSrcSig == 1, obj.reqSrcSig=1; end
                            
                            b((obj.SNUM.reqBlkLenMin < 0)+1);
                            blkLenMin = max([blkLenMin round(ans*obj.SNUM.reqBlkLenMin)]);
                            b((obj.SNUM.reqBlkLenMax < 0)+1);
                            blkLenMax = min([blkLenMax round(ans*obj.SNUM.reqBlkLenMax)]);
                            
                            % SEM Update to Plugin
                            obj.SNUM.setMassInfo(massInfo);
                            obj.SNUM.setPluginId(13);
                        end
                    end
                    
                    % *****************************************************
                    % Configure SETA Plugin
                    if ~isempty(obj.config.SETA)
                        obj.SETA = eval([obj.config.SETA.pluginClass '(' num2str(obj.config.SETA.pluginParamSetId) ')']);
                        
                        if strcmpi(obj.SETA.getSuperClass,'SETAPlugin')~=1, 
                            errMsg = sprintf('%s-- SETAPlugin: %s is not a valid SETAPlugin Extension.\n',errMsg,obj.config.SETA.pluginClass);
                        else
                            
                            %Plugin Requirements
                            if obj.SETA.reqSrcEstGroup == 1, obj.reqSrcEstGroup=1; end
                            if obj.SETA.reqSrcSig == 1, obj.reqSrcSig=1; end
                            
                            b((obj.SETA.reqBlkLenMin < 0)+1);
                            blkLenMin = max([blkLenMin round(ans*obj.SETA.reqBlkLenMin)]);
                            b((obj.SETA.reqBlkLenMax < 0)+1);
                            blkLenMax = min([blkLenMax round(ans*obj.SETA.reqBlkLenMax)]);
                            
                            % SEM Update to Plugin
                            obj.SETA.setMassInfo(massInfo);
                            obj.SETA.setPluginId(14);
                        end
                    end
                    
                    % *****************************************************
                    % Configure SEA Plugin
                    if ~isempty(obj.config.SEA)
                        obj.SEA = eval([obj.config.SEA.pluginClass '(' num2str(obj.config.SEA.pluginParamSetId) ')']);
                        
                        if strcmpi(obj.SEA.getSuperClass,'SEAPlugin')~=1, 
                            errMsg = sprintf('%s-- SEAPlugin: %s is not a valid SEAPlugin Extension.\n',errMsg,obj.config.SEA.pluginClass);
                        else
                            
                            %Plugin Requirements
                            if obj.SEA.reqSrcEstGroup == 1 && obj.SEA.reqSrcEstTA == 1, 
                                obj.reqSrcEstGroupTA=1; 
                            else
                                if obj.SEA.reqSrcEstGroup == 1, obj.reqSrcEstGroup=1; end
                                if obj.SEA.reqSrcEstTA == 1, obj.reqSrcEstTA=1; end
                            end
                            if obj.SEA.reqSrcNum == 1, obj.reqSrcNum=1; end
                            if obj.SEA.reqSrcSig == 1, obj.reqSrcSig=1; end
                            
                            b((obj.SEA.reqBlkLenMin < 0)+1);
                            blkLenMin = max([blkLenMin round(ans*obj.SEA.reqBlkLenMin)]);
                            b((obj.SEA.reqBlkLenMax < 0)+1);
                            blkLenMax = min([blkLenMax round(ans*obj.SEA.reqBlkLenMax)]);
                            
                            % SEM Update to Plugin
                            obj.SEA.setMassInfo(massInfo);
                            obj.SEA.setPluginId(15);
                        end
                    end
                    
                    % *****************************************************
                    % Determine Sig. Process. Parameters
                    if blkLenMin>blkLenMax,
                        errMsg = sprintf('%s-- Plugins have incompatible BLOCK LENGTH Requirements.\n',errMsg);
                    elseif blkLenMin == 0 && isempty(obj.blkLen)
                        errMsg = sprintf('%s-- No Minimum Required Block Length specified in Configuration or Plugins.\n',errMsg);
                    elseif isempty(obj.blkLen) || (obj.blkLen < blkLenMin),
                        obj.blkLen = blkLenMin + obj.cdsFiltLen - 1;
                        obj.blkStep = blkLenMin;
                    else
                        obj.blkLen = blkLenMin + obj.cdsFiltLen - 1;
                        obj.blkStep = blkLenMin;
                    end
                    
                    if obj.blkLen < obj.cdsFiltLen,
                        errMsg = sprintf('%s-- Minimum Data Block Length must be equal to or greater than CDS filter length.\n',errMsg);
                    end
                    
                    if isempty(obj.blkStep) || obj.blkStep > (obj.blkLen - obj.cdsFiltLen + 1)
                        obj.blkStep = obj.blkLen - obj.cdsFiltLen + 1; 
                    end
                    
                    % *****************************************************
                    % Configure DA Plugin
                    if ~isempty(obj.config.DA)
                        obj.DA = eval([obj.config.DA.pluginClass '(' num2str(obj.config.DA.pluginParamSetId) ')']);
                        
                        if strcmpi(obj.DA.getSuperClass,'DAPlugin')~=1, 
                            errMsg = sprintf('%s-- DAPlugin: %s is not a valid DAPlugin Extension.\n',errMsg,obj.config.DA.pluginClass);
                        else
                            obj.DA.setMassInfo(massInfo);
                            obj.DA.setPluginId(16);
                            
                            obj.DA.semBlkLen = obj.blkLen;
                            obj.DA.semBlkStep = obj.blkStep;
                            obj.DA.semSampRate = obj.sampRate;
                            obj.DA.semObsExtSig = obj.obsExtSig;
                            obj.DA.semSrcExtSig = obj.srcExtSig;
                        end
                    end
                    
                    % *****************************************************
                    % Configure DO Plugin
                    if ~isempty(obj.config.DO)
                        obj.DO = eval([obj.config.DO.pluginClass '(' num2str(obj.config.DO.pluginParamSetId) ')']);
                        
                        if strcmpi(obj.DO.getSuperClass,'DOPlugin')~=1, 
                            errMsg = sprintf('%s-- DOPlugin: %s is not a valid DOPlugin Extension.\n',errMsg,obj.config.DO.pluginClass);
                        else
                            obj.DO.setMassInfo(massInfo);
                            obj.DO.setPluginId(17);
                            
                            obj.DO.semBlkLen = obj.blkLen;
                            obj.DO.semBlkStep = obj.blkStep;
                            obj.DO.semSampRate = obj.sampRate;
                            obj.DO.semDestExtSig = obj.doDestExtSig;
                        end
                    end
                    
                    % *****************************************************
                    % Final Checks for Valid Configuration
                    if obj.reqSrcEstGroup == 1 && isempty(obj.SEG), 
                        errMsg = sprintf('%s-- SEGPlugin REQUIRED by other plugin(s) but NOT DEFINED in Config.\n',errMsg);
                    end
                    if obj.reqSrcEstTA == 1 && isempty(obj.SETA), error(''); 
                        errMsg = sprintf('%s-- SETAPlugin REQUIRED by other plugin(s) but NOT DEFINED in Config.\n',errMsg);
                    end
                    if obj.reqSrcNum == 1 && isempty(obj.SNUM), 
                        errMsg = sprintf('%s-- SNUMPlugin REQUIRED by other plugin(s) but NOT DEFINED in Config.\n',errMsg);
                    end
                    if obj.reqSrcSig == 1 && isempty(obj.srcExtSig), 
                        errMsg = sprintf('%s-- Source Signal Data REQUIRED by plugin(s) but NOT DEFINED in Config.\n',errMsg);
                    end

                end
                
                if ~isempty(errMsg), 
                    obj.status = -1; 
                    error('%s%s',errMsg0, errMsg); 
%                     fprintf('%s%s',errMsg0, errMsg);
%                     return
                end
                
%                 obj.DA.Init();
%                 obj.numObsSig = obj.DA.numObsSig;
%                 obj.numSrcSig = obj.DA.numSrcSig;
                
                obj.status = 2;
%             catch ex
%                 obj.status = -1;
%             end
         end
        
        %****************************************************
        % Run initialization routine
        function obj = semInitialization(obj)
            % Run Plugin Initialization Routines
            obj.DA.Init();
            obj.numObsSig = obj.DA.numObsSig;
            obj.numSrcSig = obj.DA.numSrcSig;
            
            for kk=1:numel(obj.SEP), obj.SEP(kk).Plugin.Init(); end
            obj.SEE.Init();
            obj.PAS.Init();
            obj.DO.Init();
            
            if ~isempty(obj.SNUM), obj.SNUM.Init(); end
            if ~isempty(obj.SETA), obj.SETA.Init(); end
            if ~isempty(obj.SEG), obj.SEG.Init(); end
            if ~isempty(obj.SEA), obj.SEA.Init(); end
            
            obj.cdsPrev = krnl_eye(obj.cdsFiltLen,obj.numObsSig,obj.cdsFiltOffset);
            
            obj.status = 3;
        end
        
        %****************************************************
        % Perform MASS
        function obj = semRuntime(obj)
            obj.DA.Start();
            obj.DO.Start();
            
            if ~isempty(obj.SEA) && obj.SEA.reqSigFull==1
                obj.SEA.semObsSig = obj.DA.obsSigFull;
                obj.SEA.semSrcSig = obj.DA.srcSigFull;
            end
            
            if ~isempty(obj.SEE) && obj.SEE.reqSigFull==1
                obj.SEE.semObsSig = obj.DA.obsSigFull;
                obj.SEE.semSrcSig = obj.DA.srcSigFull;
            end
            
            while obj.DA.pluginStatus > 0
                obj.DA.Update();
                
                    obj.srcSig = obj.DA.srcSig;
                    obj.obsSig = obj.DA.obsSig;
                    
%                 figure(1); plot(obj.obsSig(:,1));
%                 drawnow();
                
                
                %********************************************
                % SNUM Plugin
                if obj.reqSrcNum == 1 
                    % - Update Plugin with SEM Data
                    obj.SNUM.semObsSig = obj.obsSig;
                    obj.SNUM.semSrcSig = obj.srcSig;
                    
                    % - Run Plugin Update routine
                    obj.SNUM.Update();
                    
                    % - Collect Results
                    obj.srcNum = obj.SNUM.srcNum;
                end
                
                %********************************************
                % SEP Plugins
                obj.seArr = SourceEstimate();
                for kk=1:numel(obj.SEP)
                    % - Update Plugin with SEM Data
                    obj.SEP(kk).Plugin.semObsSig = obj.obsSig;
                    obj.SEP(kk).Plugin.semSrcSig = obj.srcSig;
                    obj.SEP(kk).Plugin.semCDS = obj.cse.cds;
                    obj.SEP(kk).Plugin.semSrcNum = obj.srcNum;
                    
                    % - Run Plugin Update routine
                    obj.SEP(kk).Plugin.Update();
                    
                    obj.seAlg(kk) = obj.SEP(kk).Plugin.se;
                    
                    if isempty(obj.seAlg(kk).cds)
                        obj.seAlg(kk).cds = obj.CDSEstimator(obj.seAlg(kk).sig);
                    end
                    
                    % - Collect Results
                    obj.seArr.sig = [obj.seArr.sig obj.SEP(kk).Plugin.se.sig];
                    
                    P = size(obj.SEP(kk).Plugin.se.sig,2);
                    if kk==1
                        obj.seArr.cds(:,:,end +(0:(P-1))) = obj.seAlg(kk).cds;
                    else
                        obj.seArr.cds(:,:,end +(1:P)) = obj.seAlg(kk).cds;
                    end
                    
                    
%                     figure(obj.SEP(kk).Plugin.getPluginId()); plot(obj.SEP(kk).Plugin.se)
                end
                
                %********************************************
                % MASS Self-Competition
                if ~isempty(obj.cdsPrev) && obj.selfComp==1
                    seSig = obj.CDO(obj.obsSig,obj.cdsPrev,[]);
                    
                    obj.seAlg(end+1).sig = seSig;
                    obj.seAlg(end+1).cds = obj.cdsPrev;
                    
                    P = size(obj.cdsPrev,3);
                    obj.seArr.sig = [obj.seArr.sig seSig];
                    obj.seArr.cds(:,:,end +(1:P)) = obj.cdsPrev;
                end
                
                %********************************************
                % SEG Plugin
                if obj.reqSrcEstGroup == 1
                    % - Update Plugin with SEM Data
                    obj.SEG.semObsSig = obj.obsSig;
                    obj.SEG.semSrcSig = obj.srcSig;
                    obj.SEG.semSrcEstArr = obj.seArr;
                    obj.SEG.semSrcEstAlg = obj.seAlg;
                    
                    % - Run Plugin Update routine
                    obj.SEG.Update();
                    
                    % - Collect Results
                    obj.seGroup = obj.SEG.seg;
                end
                
                %********************************************
                % SETA Plugin with SE data
                if obj.reqSrcEstTA == 1
                    % - Update Plugin with SEM Data
                    % - Run Plugin Update routine
                    % - Collect Results
                end
                
                %********************************************
                % SETA Plugin with SEG data
                if obj.reqSrcEstGroupTA == 1
                    % - Update Plugin with SEM Data
                    % - Run Plugin Update routine
                    % - Collect Results
                end
                
                %********************************************
                % SEE Plugin
                % - Update Plugin with SEM Data
                if obj.SEE.reqSigFull ~= 1
                    obj.SEE.semObsSig = obj.obsSig;
                    obj.SEE.semSrcSig = obj.srcSig;
                end
                obj.SEE.semSrcEstArr = obj.seArr;
                obj.SEE.semSrcEstAlg = obj.seAlg;
                obj.SEE.semSrcEstGroup = obj.seGroup;
                obj.SEE.semSrcEstGroupTA = obj.seGroupTA;
                obj.SEE.semSrcEstTA = obj.seTA;
                
                % - Run Plugin Update routine
                obj.SEE.Update();
                
                % - Collect Results
                obj.cse = obj.SEE.cse;
%                 obj.cse.cds = obj.SEE.cds;
                
                if isempty(obj.cse.cds), 
                    obj.cse.cds = obj.CDSEstimator(obj.cse.sig); 
                end
                
%                 figure(obj.SEE.getPluginId()); plot(obj.cse);
%                 krnl3_plot(obj.cse.cds,100+obj.SEE.getPluginId());
%                 drawnow();
                %********************************************
                % PAS Plugin
                %  - Update Plugin with SEM Data
                obj.PAS.semObsSig = obj.obsSig;
                obj.PAS.semSrcSig = obj.srcSig;
                obj.PAS.semSrcEstArr = obj.seArr;
                obj.PAS.semSrcEstAlg = obj.seAlg;
                obj.PAS.semSrcEstGroup = obj.seGroup;
                obj.PAS.semSrcEstGroupTA = obj.seGroupTA;
                obj.PAS.semSrcEstTA = obj.seTA;
                obj.PAS.semCSE = obj.cse;
                obj.PAS.semCDSPrev = obj.cdsPrev;
        
                % - Run Plugin Update routine
                obj.PAS.Update();
                
                % - Collect Results
                obj.cse = obj.PAS.cse;
%                 obj.cse.cds = obj.PAS.cds;
                
                %********************************************
                % SEA Plugin
                if ~isempty(obj.SEA)
                % - Update Plugin with SEM Data
                    if obj.SEA.reqSigFull ~= 1
                        obj.SEA.semObsSig = obj.obsSig;
                        obj.SEA.semSrcSig = obj.srcSig;
                    end
                    obj.SEA.semSrcEstArr = obj.seArr;
                    obj.SEA.semSrcEstAlg = obj.seAlg;
                    obj.SEA.semSrcEstGroup = obj.seGroup;
                    obj.SEA.semSrcEstGroupTA = obj.seGroupTA;
                    obj.SEA.semSrcEstTA = obj.seTA;
                    obj.SEA.semCSE = obj.cse;
                    obj.SEA.semCDSPrev = obj.cdsPrev;
                    
                % - Run Plugin Update routine
                    obj.SEA.Update();
                    
                    % - Collect Results
                    obj.seaResults = obj.SEA.sea;
                end
                
                %********************************************
                % DO Plugin
                % - Update Plugin with SEM Data
                obj.DO.semCSE = obj.cse;
                obj.DO.semSEA = obj.seaResults;
                
                % - Run Plugin Update routine
                obj.DO.Update();
                
                %********************************************
                % SEM Block Finalization Tasks
                obj.cdsPrev = obj.cse.cds;
                
            end
            
            obj.DA.Stop();
            obj.DO.Stop();
        end
        
        %****************************************************
        % Run shutdownn routine
        function obj = semShutDown(obj)
            % Run Plugin ShutDown Routines
            obj.DA.ShutDown();
            
            for kk=1:numel(obj.SEP), obj.SEP(kk).Plugin.ShutDown(); end
            
            obj.SEE.ShutDown();
            obj.PAS.ShutDown();
            
            if ~isempty(obj.SNUM), obj.SNUM.ShutDown(); end
            if ~isempty(obj.SETA), obj.SETA.ShutDown(); end
            if ~isempty(obj.SEG), obj.SEG.ShutDown(); end
            if ~isempty(obj.SEA), obj.SEA.ShutDown(); end
            
            obj.DO.ShutDown();
            
            obj.status = 100;
        end    
    end
    
    
end












classdef DA_FileRead < DAPlugin
    %The abstract Data Acquisition Plugin is used for acquiring external
    %data used in the MASS system
	%
	%Description:
	%The data acquisition plugin (DAPlugin) DA_FileRead reads data from files
	%specified in the semObsExtSig and semSrcExtSig ExternalSignal objects 
	%contained in the configuration. The DA_FileRead component ensures that 
	%signals contained in the semObsExtSig and semSrcExtSig files are sampled 
	%at semSampRate, also contained in configuration. The DA_FileRead component 
	%reads into memory all data contained in the files specified by semObsExtSig 
	%and semSrcExtSig, but only delivers time-incremented blocks of data to the 
	%SEM with each Update() function call according to the DAPlugin specification.
	%
	% Constructor:
	%DA_FileRead ( ParamSetId )
	%
	%Parameters: None
	%Parameter Sets: None
	%
	%Common Fields:
	%pluginName = Data Acquisiton from Files
	%pluginVersion = 1.0.1
	%pluginAbbr = DA_FileRead
	%pluginDescr = Acquires data from audio or mat files
	%
	%Requirement Fields: None
	
    
    properties (Access = protected)
        blkNdx = 0;
        blk = [];
    end
    
    properties (GetAccess = public, SetAccess = protected)
        obsSigFull = [];
        srcSigFull = [];
    end 
    
    methods
        % Constructor, called during SEM Configuration
        function obj = DA_FileRead(ParamSetId)
            obj.pluginName = 'Data Acquisiton from Files';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = 'DA_FileRead';
            obj.pluginDescr = 'Acquires data from audio or mat files';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
        end
        
        % Initialization routine, called before runtime
        function obj=Init(obj)
            Nobs = []; Nsrc = inf;
            if ~isempty(obj.semObsExtSig)
                obsSigs = obj.loadExtSigs(obj.semObsExtSig);
                for kk=1:numel(obsSigs), Nobs(kk) = size(obsSigs(kk).sig,1); end
            end
            if ~isempty(obj.semSrcExtSig)
                srcSigs = obj.loadExtSigs(obj.semSrcExtSig);
                for kk=1:numel(srcSigs), Nsrc(kk) = size(srcSigs(kk).sig,1); end
            end
            N = min([min(Nobs) min(Nsrc)]);
            for kk=1:numel(obsSigs)
                obj.obsSigFull = [obj.obsSigFull obsSigs(kk).sig(1:N,:)];
            end
            for kk=1:numel(srcSigs)
                obj.srcSigFull = [obj.srcSigFull srcSigs(kk).sig(1:N,:)];
            end
% ******************************
% !!! Just grab 32 seconds !!!
            obj.obsSigFull = obj.obsSigFull(1:(30*obj.semSampRate+obj.massInfo.getCDSFiltLen()-1),:);
            if ~isempty(obj.srcSigFull)
                obj.srcSigFull = obj.srcSigFull(1:(30*obj.semSampRate+obj.massInfo.getCDSFiltLen()-1),:);
            end
% ******************************

            obj.obsSigFull = mean0_var1(obj.obsSigFull);
            
            obj.numObsSig = size(obj.obsSigFull,2);
            obj.numSrcSig = size(obj.srcSigFull,2);
            obj.blk = 1:obj.semBlkLen;
            obj.pluginStatus = 10;
        end
        
        function obj = Start(obj)
            obj.pluginStatus = 20;
        end
        
        function obj = Stop(obj)
            obj.pluginStatus = 100;
        end
        
        % Update routine, called during runtime  
        function obj=Update(obj)
            try
                obj.pluginStatus = 4;
                blk = obj.blkNdx * obj.semBlkStep + obj.blk;
                
%                 if blk(end)<size(obj.obsSigFull,1)
                    obj.obsSig = obj.obsSigFull(blk,:);
%                 else
%                     obj.obsSig = zeros(obj.semBlkLen,obj.numObsSig);
%                     N = size(obj.obsSig(blk(1):end,:),1);
%                     obj.obsSig(1:N,:) = obj.obsSig(blk(1):end,:);
%                 end
                
                if ~isempty(obj.srcSigFull)
%                     if blk(end)<size(obj.srcSigFull,1)
                        obj.srcSig = obj.srcSigFull(blk,:);
%                     else
%                         obj.srcSig = zeros(obj.semBlkLen,obj.numSrcSig);
%                         N = size(obj.srcSigFull(blk(1):end,:),1);
%                         obj.srcSig(1:N,:) = obj.srcSigFull(blk(1):end,:);
%                     end
                end
                
                obj.blkNdx = obj.blkNdx +1;
                if (obj.blkNdx * obj.semBlkStep + obj.semBlkLen) <= size(obj.obsSigFull,1)
                    obj.pluginStatus = 3;
                else
                    obj.pluginStatus = -3;
                end
            catch ex
                obj.pluginStatus = -1;
            end
        end
    end
    
    methods (Access = protected)
        function sigs = loadExtSigs(obj,ExtSigs)
            numExtSigs = numel(ExtSigs);
            sigs = [];
            
            for kk=1:numExtSigs
                [fpath,fname,fext] = fileparts(ExtSigs(kk).location);
                
                if strcmpi(fext,'.mat')  % Load Mat files
                    if isempty(ExtSigs(kk).varName)
                        error('DAFileLoad: MAT file specified without a variable name');
                    else
                        load(ExtSigs(kk).location);
                        
                        if isempty(ExtSigs(kk).channel)
                            sigs(kk).sig = eval(ExtSigs(kk).varName);
                        else
                            channel = num2str(ExtSigs(kk).channel);
                            sigs(kk).sig = eval([ExtSigs(kk).varName '(:,' channel ')']);
                        end
                    end
                else % Load Audio Files
                    [y,Fs] = audioread(ExtSigs(kk).location);
                    if isempty(ExtSigs(kk).channel), y = y(:,ExtSigs(kk).channel); end
                    if Fs ~= obj.semSampRate, y = resample(y,obj.semSampRate,Fs); end
                    sigs(kk).sig = y; y=[];
                end
            end
        end
    end
    
end

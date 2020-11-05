classdef Config_Analysis_Ex1_2 < Configuration
    
    methods
        % **************************************************************
        % Constructor
        function obj = Config_Analysis_Ex1_2()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'Analysis Example 1';
            obj.configDescr = 'Analysis Example 1: Block processing and Block-level Analysis';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Set SEM Signal Processing Properties
            obj.semSampRate = 16000;
            obj.semSelfComp = 0;
            obj.semBlkLen = -2;
            obj.semBlkStep = -2;
            obj.semCDSFiltLen = -1/16; 
            obj.semCDSFiltOffset = obj.semCDSFiltLen/2;
            
            % **********************************************************
            % Set SEM Miscellaneous Processing Properties
            obj.semPluginError = 0;
            obj.semVerbose = 0;
            
            % **********************************************************
            % Define Plugin Instances
            obj.SEP = [PluginInst('SEP_SupSysId',0);];
            obj.SEE = PluginInst('SEE_Identity',0);
            obj.PAS = PluginInst('PAS_Identity ',0);
            obj.SEG = []; 
            obj.SNUM = []; 
            obj.SETA = []; 
            obj.SEA = PluginInst('SEA_SIR',0);
            obj.DA = PluginInst('DA_FileRead',0);
            obj.DO = PluginInst('DO_FileWrite',0);
            
            % **********************************************************
            % External Data Sources
            % **********************************************************    
            % NOTE: Data Sources Below are Specifically for DA_FileRead and 
            %       DO_FileWrite I/O plugins. Custom I/O Plugins should modify
            %       ExternalSignals as needed.
            dataSet = 'DS_SS1-3_GS1_3x3_RT60-0.1s.mat';
            
            [fpath] = fileparts(which('MASS_SEM.m'));
            if isempty(fpath), error('MASS Package Path Required'); end
            
            outDir = fullfile(fpath,'Outputs', class(obj));
            if ~isdir(outDir), mkdir(outDir); end
            
            % **********************************************************
            % Shared Dataset Info, for brevity
            
            dataSetFQN = fullfile(fpath,'Datasets',dataSet);
            load(dataSetFQN,'SrcSet');
            srcSetFQN = fullfile(fpath,'Datasets','SourceSets',SrcSet);
            
            % ******************************************************
            % Observation Signal Data Source
            obj.daObsExtSig = ExternalSignal();
            obj.daObsExtSig.location = dataSetFQN;
            obj.daObsExtSig.varName = 'OBS';
            obj.daObsExtSig.sampRate = obj.semSampRate;
            obj.daObsExtSig.name = [dataSet '_' obj.daObsExtSig.varName];
            obj.daObsExtSig.groupId = [];
            obj.daObsExtSig.channel = [];
            obj.daObsExtSig.type = [];
            
            % ******************************************************
            % Source Signal Data Source, Optional
            obj.daSrcExtSig = ExternalSignal();
            obj.daSrcExtSig.location = srcSetFQN;
            obj.daSrcExtSig.varName = 'SRC';
            obj.daSrcExtSig.sampRate = obj.semSampRate;
            obj.daSrcExtSig.name = [dataSet '_' obj.daSrcExtSig.varName];
            obj.daSrcExtSig.groupId = [];
            obj.daSrcExtSig.channel = [];
            obj.daSrcExtSig.type = [];
            
            % **********************************************************
            % MASS Data Output Destination
            obj.doDestExtSig = ExternalSignal();
            obj.doDestExtSig.location = fullfile(outDir,[class(obj) '-OUT.mat']);
            obj.doDestExtSig.sampRate = obj.semSampRate;
            obj.doDestExtSig.varName = [];
            obj.doDestExtSig.name = [];
            obj.doDestExtSig.groupId = [];
            obj.doDestExtSig.channel = [];
            obj.doDestExtSig.type = [];
        end
    end
end


classdef Config_MASS_Ex1_GS1_3x3 < Configuration
% MASS Example using Blind SEP methods with Supervised SEE:
% -- SEP: SEP_ABYK, SEP_MCLP, SEP_TTSE SEP plugins
% -- SEE: SEE_SupSIRSelect
% -- PAS: PAS_CSEPrevXCorr
% -- Dataset: DS_SS1-3_GS1_3x3_RT60-0.1s.mat
%
% The abstract Configuration is given in Sect. 3.5 of [1, pp. 76-77], while
% particular instances are given throughout Ch. 5 of [1].
%
% [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

    methods
        % **************************************************************
        % Constructor
        function obj = Config_MASS_Ex1_GS1_3x3()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'MASS Example 1';
            obj.configDescr = 'MASS Example 1: Semi-Blind MASS';
            obj.configAbbr = class(obj);
            
            % **********************************************************
            % Set SEM Signal Processing Properties
            obj.semSampRate = 16000;
            obj.semSelfComp = 0;
            obj.semBlkLen = -5;
            obj.semBlkStep = -5;
            obj.semCDSFiltLen = -1/16; 
            obj.semCDSFiltOffset = obj.semCDSFiltLen/2;
            
            % **********************************************************
            % Set SEM Miscellaneous Processing Properties
            obj.semPluginError = 0;
            obj.semVerbose = 0;
            
            % **********************************************************
            % Define Plugin Instances
            obj.SEP = [PluginInst('SEP_MCLP',0);
                       PluginInst('SEP_TTSE',0);
                       PluginInst('SEP_ABYK',2);];
            obj.SEE = PluginInst('SEE_SupSIRSelect',10);
            obj.PAS = PluginInst('PAS_CSEPrevXCorr',0);
            obj.SEG = []; 
            obj.SNUM = PluginInst('SNUM_NumObs',0);
            obj.SETA = []; 
            obj.SEA = PluginInst('SEA_SIR', 10);
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


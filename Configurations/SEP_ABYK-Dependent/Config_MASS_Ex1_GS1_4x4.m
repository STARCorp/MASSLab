classdef Config_MASS_Ex1_GS1_4x4 < Config_MASS_Ex1_GS1_3x3
    % MASS Example using blind methods:
    % - SEP_ABYK, SEP_MCLP, SEP_TTSE SEP plugins
    % - DS_SS1-3_GS1_3x4_RT60-0.1s.mat
%
% The abstract Configuration is given in Sect. 3.5 of [1, pp. 76-77], while
% particular instances are given throughout Ch. 5 of [1].
%
% [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

    
    methods
        % **************************************************************
        % Constructor
        function obj = Config_MASS_Ex1_GS1_4x4()
            
            % **********************************************************
            % Configuration Properties
            obj.configName = 'MASS Example 1';
            obj.configDescr = 'MASS Example 1: Semi-Blind MASS';
            obj.configAbbr = class(obj);
           
            % **********************************************************
            % External Data Sources
            % **********************************************************    
            % NOTE: Data Sources Below are Specifically for DA_FileRead and 
            %       DO_FileWrite I/O plugins. Custom I/O Plugins should modify
            %       ExternalSignals as needed.
            dataSet = 'DS_SS1-4_GS1_4x4_RT60-0.1s.mat';
            
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


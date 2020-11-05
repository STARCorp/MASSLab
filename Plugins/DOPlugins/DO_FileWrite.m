classdef DO_FileWrite < DOPlugin
    %Description:
	%The data output plugin (DOPlugin) DO_FileWrite saves into a .mat file 
	%the semCDS, semCSE, and semSEA data at each block, as well as the 
	%configuration information used to produce these data. The .mat file 
	%location and name is defined in the semDestExtSig configuration variable. 
	%This component is very simple, in that it concatenates successive blocks 
	%of semCSE values into a single array that is saved out in the CSE 
	%variable in the .mat file. This component also concatenates the semSEA 
	%data into a single SEA array in the .mat file. Each CDS at every block 
	%is stored in a structure array CDS where CDS(m).values contains the CDS 
	%of the mth block. The configuration is saved out in a structure array 
	%CFG variable whose structure is the same as the Configuration object used 
	%to produce the data. In future versions of this component, the output 
	%.mat file will be modified to contain at least these three variables: 
	%CSE, Block, and CFG. The CSE and CFG variables will be the same as 
	%described above. The Block variable will be a structure array with at
	%least four fields: CSE, CDS, OBS, and SEA. The mth entry in Block, 
	%i.e. Block(m), will contain the mth data block’s CSE, CDS, observation 
	%data (OBS), and SEAPlugin results(SEA) as Block(m).CSE, Block(m).CDS, 
	%Block(m).OBS, and Block(m).SEA, respectively.
	%This will allow the SEAPlugin to output more general (dimensioned) 
	%data than currently given in the SEAPlugin’s definition and allow precise 
	%post-processing analysis by providing the exact samples of data needed 
	%to precisely recreate the MASS outputs at each block. 
	%The Block variable also allows for other types of block data unforeseen 
	%at this moment to be added in the future, and we note that this 
	%document provides a “beta” overview of the MASS framework. We will 
	%discuss even more opportunities for MASS framework improvement 
	%in Chapter 6.
	%
	%Constructor:
	%DO_FileWrite ( ParamSetId )
	%
	%Common Fields:
	%pluginName = Data Output to a MAT File
	%pluginVersion = 1.0.1
	%pluginAbbr = DA_FileWrite
	%pluginDescr = Writes MASS configuration, CDS, CSE, and SEA data to a .mat file
	%
	%Requirement Fields: None
	%Parameters: None
	%Parameter Sets: None
    
%     properties (Hidden)
%         semDestExtSig;
%         semCSE;
%         semCDS;
%         semSE;
%         semSEG;
%         semSEGTA;
%         semSEA;
%         semSEE;
%         
%         blkLen;
%         blkStep;
%         semSampRate;
%     end
    
    properties (Access = private)
        overwrite = 1; % 0|1: do not | do overwrite output files
        dateTime = [];
        cse = SourceEstimate();
        block = struct('CSE',[],'SEA',[]);
        sea = [];
        cds = [];
    end
    
    methods
        % Constructor, called during SEM Configuration
        function obj = DO_FileWrite(ParamSetId)
            obj.pluginName = 'Data Output to MAT File';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = 'DO_FileWrite';
            obj.pluginDescr = 'Writes MASS configuration, CDS, CSE, and SEA data to a .mat file';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            obj.dateTime = datetime();
        end
        
        % Initialization routine, called before runtime
        function obj = Init(obj)
            [fpath,fname,fext] = fileparts(obj.semDestExtSig.location);
            if ~isdir(fullfile(fpath)), mkdir(fpath); end
            DateTime = obj.dateTime;
            SampRate = obj.semSampRate;
            Config = obj.massInfo.getConfig();
            save(obj.semDestExtSig.location,'DateTime','SampRate','Config');
        end
        
        function obj = Start(obj)
            obj.pluginStatus = 2;
        end
        
        % Update routine, called during runtime  
        function obj = Update(obj)
            if ~isempty(obj.cse.sig) && size(obj.cse.sig,2)<size(obj.semCSE,2)
                N = size(obj.semCSE,2)-size(obj.cse.sig,2);
                obj.cse.sig(:,(end+1):(end+N))=0;
                
            end
            obj.cse.sig = [obj.cse.sig ; obj.semCSE.sig(1:obj.semBlkStep,:)];
            obj.block(end+1).CSE.sig = obj.semCSE.sig;
            obj.block(end).CSE.cds = obj.semCSE.cds;
            obj.block(end).SEA = obj.semSEA.results;
        end
        
        % Stop and finalize plugin functions
        function obj = Stop(obj)
            CSE = obj.cse.sig;
            obj.block(1) = [];
            BLOCK = obj.block;
%             CDS = obj.cse.cds; %obj.semCDS;
%             SEA = obj.semSEA.results;
%             CFG = obj.massInfo.getConfig();
            
            save(obj.semDestExtSig.location,'CSE','BLOCK','-append');
            
            for kk = 1:numel(obj.semSEA.figures)
                if ~isempty(obj.semSEA.figures(kk).handle)
                    figNm = [obj.semDestExtSig.location '_FIG' num2str(kk) '_' obj.semSEA.figures(kk).name '.fig'];
                    savefig(obj.semSEA.figures(kk).handle, figNm);
                end
            end
            obj.pluginStatus = 10;
        end
        
        % Shiutdown procedure
        function obj = ShutDown(obj)
%             plotResults(obj,1)
%             Q = numel(obj.sea); [N,P] = size(obj.sea(kk).results);
%             t = (0:(N-1))/obj.semSampRate;
%             figure(1);
%             leg={};
%             for kk=1:P, leg{kk} = ['Source ' num2str(kk)]; end
%             for kk = 1:numel(obj.semSEA)
%                 subplot(Q,1,kk);
%                 plot(t,10*log10(obj.sea(kk).results));
%                 xlabel('Time (s)');
%                 ylabel('SIR (dB)');
%                 title(['Output ' num2str(kk)]);
%                 legend(leg);
%             end
        end
        
        
    end  
end

















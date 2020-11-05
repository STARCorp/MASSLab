classdef SEP_Static < SEPPlugin
    % SEP static filter
	%Description:
	%The source estimate production plugin (SEPPlugin) SEP_Static applies an
	%identity CDS to the observation data, thus passing through the observation 
	%data as a CSE set for further processing in the MASS framework. Although 
	%conceptually simple, the SEP_Static plugin does take the (computational) 
	%time to apply the identity CDS contained in se.cds to the observation 
	%data via the plugin’s massInfo.CDO operation to produce the se.cse values. 
	%Although this method could have been named “SEP_Identity”,
	%we note that this particular plugin component is extraordinary in the 
	%MASS framework for several reasons: SEP_Static gives the MASS framework 
	%a simple, top-level debugging mechanism, SEP_Static allows the MASS 
	%framework to be used solely for signal analysis, SEP_Static is the only 
	%component that is meant to be extended by users, and the SEP_Static 
	%component concisely defines MASS block-processing concepts for
	%use in future development of the MASS framework. For the first reason, 
	%we simply note that a user can designate any signal set as the 
	%observation data and then design a configuration to study a particular 
	%set of plugins’ behaviors, and for the second reason, we devote Sect. 5.3 
	%to exploring a couple of signal analysis applications.
	%Thirdly, the SEP_Static plugin is abnormal in the component library, 
	%since we envision users extending the SEP_Static plugin component and 
	%modifying the se.cds variable with a particular CDS that will be applied 
	%at every block to the observation data. In this way, a user can apply a 
	%pre-defined CDS to the observations and allow MASS to determine if this 
	%CDS is ever “the best” in terms of a particular configuration. In this
	%manner, we give the user a method to apply static solutions to the data 
	%and study the MASS solution.
	%Furthermore, the SEP_Static method can describe the MASS framework’s
	%application of a CDS to the observation data via a CDO concisely. 
	%That is, any method that uses this operation, e.g. a SEP component, 
	%the MASS CSE, etc., can be described as a function that determines a CDS 
	%followed by a SEP_Static method that applies the CDS to a block of data. 
	%The SEP_Static method, applied at the block-level, encapsulates the
	%block-processing concept of MASS, and future development of the MASS 
	%framework will use SEP_Static as a building block.
	%
	%Constructor:
	%SEP_Static ( ParamSetId )
	%
	%Common Fields:
	%pluginName = SEP Static Filter
	%pluginVersion = 1.0.1
	%pluginAbbr = SEP_Static
	%pluginDescr = Static filtering of observation data
	%
	%Requirement Fields:
	%reqSrcNum = 0 Method does NOT require an SNUMPlugin
	%reqSrcSig = 0 Blind method, does NOT require source signals
	%reqBlkLenMin = -1 Minimum data-block length is 1s
	%reqBlkLenMax = inf Maximum data-block length is unspecified
	%
	%Parameters: None
	%Parameter Sets: None
    
    methods
        % Constructor, called during SEM Configuration
        function obj = SEP_Static(ParamSetId)
            % Plugin Identifying Information
            obj.pluginName = 'SEP Static Filter';
            obj.pluginVersion ='1.0.1';
            obj.pluginAbbr = class(obj);
            obj.pluginDescr = 'Static filtering of observation data';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
            
            % Plugin Requirements 
            obj.reqBlkLenMin = -1; %-9.95;
            obj.reqBlkLenMax = inf;
        end
        
        % Initialization routine, called after SEM configuration, but before runtime
        % The massInfo object is now available for the plugin to query the MASS system
        function obj = Init(obj)
            L = obj.massInfo.getCDSFiltLen();
            M = obj.massInfo.getNumObsSig();
            N = obj.massInfo.getCDSFiltOffset();
            
            obj.se.cds = krnl_eye(L,M,N);
            
            obj.pluginStatus = 1;
        end
        
        % Update routine, called during runtime at each data block 
        function obj = Update(obj)
%             obj.se.sig = obj.semObsSig;
            obj.se.sig = obj.massInfo.CDO(obj.semObsSig,obj.se.cds,[]);
        end
            
    end
    
end


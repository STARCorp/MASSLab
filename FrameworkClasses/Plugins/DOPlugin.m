%      The abstract Data Output Plugin is used to output results of the MASS
%      system
% 
%      Description:
%      The DOPlugin is tasked with outputting the various data produced by the
%      MASS framework. As shown below, the DOPlugin has access to all SEM Data
%      Fields, but in this version of the MASS framework, only the semCSE, semCDS, and
%      semSEA fields are updated prior to calling the DOPlugin’s Update() method at each
%      block. Thus, the DOPlugin is responsible for delivering the CSE set, the associated
%      CDS set, and any data provided by a SEAPlugin to the destination provided by the
%      doDestExtSig object given in the configuration. The DOPlugin does not have any
%      update fields, since it updates an external data destination at each call of the
%      DOPlugin’s Update() method.
%      
%      Properties:
%      pluginName = A string with a full name of the plugin.
%      pluginVersion = A string with the plugin’s development version.
%      pluginAbbr = A string with an abbreviation of pluginName, typically used in user
%      	displays with strict character limits.
%      pluginDescr = A string containing a description of the plugin’s implemented functionality.
%      pluginStatus = A flag denoting the state of the plugin.
%      paramSetId = A plugin-specific parameter set identification number
%      massInfo = A MASSInfo object that allows the plugin to query the MASS system for
%      	particular parameters and functionality
%      semSrcNum =
%      semSrcEstAlg = Source estimates grouped by SEP
%      semSrcEstGroup = Source estimates grouped by estimated source
%      semSrcEstTA =
%      semSrcEstGroupTA = Time-aligned source estimates grouped by estimated source
%      semCSE = The current CSE
%      semSEA = An array of CSE analysis values
%      semBlkLen = Data block length
%      semBlkStep = Data block step
%      semSampRate = Data sampling rate
%      semDataDestExtSig = Data destination for MASS output
%      
%      Methods:
%      Init() = Plugin-specific initialization procedure. Called by SEM during initialization phase.
%      Update() = Plugin-specific task procedure. Called by SEM during runtime after a new
%      	data-block has been acquired.
%      Shutdown() = Plugin-specific shutdown procedure. Called by SEM during shutdown phase.
%      Start() =
%      Stop() =
%      See also massInfo.
% 
%      See Sect. 3.6.11 in [1]
% 
%      [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%      Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
%
%    Reference page in Doc Center
%       doc DOPlugin
%
%

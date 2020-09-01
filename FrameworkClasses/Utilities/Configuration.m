%      The abstract Configuration class
%        The MASS system is initialized based on the configuration.
%      The Configuration class is responsible for defining all the information
%      necessary for the SEM to initialize itself and all of the user-extended MASS plugins.
%      The method of acquiring configuration information can be modified by the end-user
%      via the extensible ConfigPlugin class (see Sect. 3.6.2) whose only purpose is to
%      produce a valid Configuration object.
%      The Configuration class uses the ExternalSignal class to define two external data signal
%      sets; an observation/mixture signal set (semObsSig) and an underlying source signal
%      set (semSrcSig). The observation signals are required by source separation methods,
%      while a set of underlying source signals allow some plugins to operate in a supervised
%      manner, e.g. the SEAPlugin may implement an SIR metric. Although the semSrcSig
%      is only required to be defined when a particular plugin needs this information, the
%      semObsSig is required for any configuration.
%      The Configuration class also uses the ExternalSignal class to define a destination for the
%      data output. In this version of MASS, we require that a data output destination be
%      defined for a configuration to be valid.
%      The Configuration class also uses the PluginInst class to define instantiations of the
%      various plugins by the SEM. The PluginInst object simply contains the name of a
%      plugin class, PluginClass, and a parameter set identification number,
%      PluginParamSetId. For every PluginInst in the Configuration, the SEM will
%      instantiate a PluginClass object via the constructor PluginClass(PluginParamSetId)
%      for the appropriate plugin, or plugin set.
%      
%      Constructor:
%      
%      Properties:
%      semSelfComp = Determines if MASS work in selfcompetition mode
%      semBlkLen = The data block length used in MASS processing
%      semBlkStep = The data block step used in MASS processing
%      semCDSFiltLen = The CDS filter length (BLTI)
%      semCDSOffset = A global offset (delay) in the CDS
%      semPluginError = Flag to determine operation of SEM after a plugin
%      				error occurs. 0=Stop,1=Remove plugin and continue
%      semPluginUndef = Flag to determine operation of SEM if a plugin is undefined
%      				in the configuration. 0=Stop,1=Use appropriate reference component
%      semVerbose = Flag to determine if the SEM should display information during
%      				processing. 0=No,1=Display summary info
%      daObsExtSig = An array of ExternalData objects defining the observation signals.
%      daSrcExtSig = An array of ExternalData objects defining the underlying source signals.
%      doDestExtSig = An ExternalData object defining the destination of MASS data output
%      SEP = An array of SEP plugin construction definitions
%      SEE = SEE plugin construction definition
%      PAS = PAS plugin construction definition
%      SNUM = SNUM plugin construction definition
%      SEG = SEG plugin construction definition
%      SEA = SEA plugin construction definition
%      SETA = SETA plugin construction definition
%      DA = DA plugin construction definition
%      DO = DO plugin construction definition
%      
%      Methods: None
% 
%      See Sect. 3.5 in [1]
% 
%      [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%      Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
%
%    Reference page in Doc Center
%       doc Configuration
%
%

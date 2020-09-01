%      The abstract Data Acquisition Plugin is used for acquiring external
%      data used in the MASS system
% 
%      Description:
%      The Data Acquisition plugin is responsible for acquiring external signals
%      such as observations or side-information used by the various MASS plugins. The
%      data acquisition process is potentially a very complicated task, and here we try to
%      generalize that task to accommodate processes we cannot imagine. The DAPlugin is
%      not only responsible for acquiring the external signals, but it is also tasked with
%      providing the SEM with new blocks of data each time the SEM calls the plugin’s
%      Update() function, thus the DAPlugin extensions are responsible for resolving any
%      buffering and memory issues necessary to provide data to the MASS system. We
%      provide a simple implementation of this plugin class in 4.1, that simply reads in audio
%      files, and block-sequentially steps through the data at each Update() execution. The
%      DAPlugin is also responsible for ensuring that all signals are sampled at
%      semSampRate set in configuration.
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
%      obsSig = An array of observation signal samples
%      	at the current data block
%      srcSig = An array of source signal samples at the current data block
%      numObsSig = The number of observation signals
%      numSrcSig = The number of source signals
%      semObsExtSig = Data used to acquire observation signals
%      semSrcExtSig = Data used to acquire source signals
%      semBlkLen = Data block length
%      semBlkStep = Data block step
%      semSampRate = Data sampling rate
%      
%      Methods:
%      Init() = Plugin-specific initialization procedure. Called by SEM during initialization phase.
%      Update() = Plugin-specific task procedure. Called by SEM during runtime after a new
%      	data-block has been acquired.
%      Shutdown() = Plugin-specific shutdown procedure. Called by SEM during shutdown phase.
%      start() =
%      stop() =
%      
%      See also massInfo.
% 
%      See Sect. 3.6.3 in [1]
% 
%      [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%      Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
%
%    Reference page in Doc Center
%       doc DAPlugin
%
%

%      The abstract Source Enumeration plugin is tasked with estimating the
%      number of sources present in the observations
% 
%      Description
%      The SNUMPlugin is responsible for determining the number of active
%      sources at each sample in each observation signal. Although we do not require the
%      SNUMPlugin to be as precise as the initial description implies, we do require that any
%      SNUMPlugin implementation follow the format of reporting a source number
%      estimate at each sample of each observation signal. Therefore, the data that the
%      SNUMPlugin reports is an [NxP] array of source number estimate values, where N is
%      the length of the current data block and P is the number of observation signals, and
%      the (n,p)th value is an estimate of the number of sources active at the nth sample in the
%      pth observation. Although the number of sources active in a mixture is a positive
%      integer (or infinity!), we let the data type of these source number estimates be a Float,
%      since source enumeration is an estimation process, and real number values are
%      informative, e.g. 3.9 sources in a statistical sense helps inform the decision “probably 4 sources”.
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
%      srcNum = An estimate of the number of sources at each
%      	sample for each observation.
%      semObsSig = The current block of observation signals’ samples
%      semSrcSig = The current block of source signals’ samples
%      reqSrcSig  = Denotes whether or not the plugin requires
%      	underlying source signals. Supervised
%      	methods set this variable to “true” or 1.
%      reqBlkLenMin = The minimum amount of data (the data block
%      	length) required by the plugin. Positive values
%      	will indicate the nearest integer value of
%      	samples, while a negative value will indicate
%      	the number of seconds.
%      reqBlkLenMax = The maximum number of data samples (the
%      	data block length) a plugin can handle.
%      	Positive values will indicate the nearest integer
%      	value of samples, while a negative value will
%      	indicate the number of seconds.
%      
%      Methods:
%      Init() = Plugin-specific initialization procedure. Called by SEM during initialization phase.
%      Update() = Plugin-specific task procedure. Called by SEM during runtime after a new
%      	data-block has been acquired.
%      Shutdown() = Plugin-specific shutdown procedure. Called by SEM during shutdown phase.
%      
%      See also massInfo.
% 
%      See Sect. 3.6.4 in [1]
% 
%      [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%      Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
%
%    Reference page in Doc Center
%       doc SNUMPlugin
%
%

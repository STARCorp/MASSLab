%      The abstract Permutation Ambiguity Solution Plugin is tasked with
%      solving the permutation ambiguity problem in MASS.
% 
%      Description:
%      The PASPlugin resolves the permutation ambiguity in the source separation.
%      Although it has access to all SEM source estimate data, its main task is to ensure that
%      the order of source estimates from the SEEPlugin, i.e. the semCSE SEM data field,
%      stays the same from block to block.
%      
%      Properties:
%      pluginName = A string with a full name of the plugin.
%      pluginVersion = A string with the plugin�s development version.
%      pluginAbbr = A string with an abbreviation of pluginName, typically used in user
%      	displays with strict character limits.
%      pluginDescr = A string containing a description of the plugin�s implemented functionality.
%      pluginStatus = A flag denoting the state of the plugin.
%      paramSetId = A plugin-specific parameter set identification number
%      massInfo = A MASSInfo object that allows the plugin to query the MASS system for
%      	particular parameters and functionality
%      cse = A composite source estimate set, in which the permutation
%      	ambiguity has been resolved.
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
%      reqSrcSig  = Denotes whether or not the plugin requires
%      	underlying source signals. Supervised
%      	methods set this variable to �true� or 1.
%      reqSrcNum = Denotes whether or not the plugin requires an
%      	estimate of the source number. Setting this to
%      	�true� ensures that a source enumeration
%      	plugin is available.
%      reqSrcEstGroup = Denotes whether or not the plugin requires
%      	source estimates to be grouped. Setting this to
%      	�true� ensures that a SEG plugin is available.
%      reqSrcEstCDS Bool prot pub Denotes whether or not the plugin requires the
%      	CDS for every source estimate. Setting this to
%      	�true� ensures that all source estimates� CDSs
%      	are available.
%      reqSrcEstTA = Denotes whether or not the plugin requires
%      	source estimates to be time-aligned. Setting
%      	this to �true� ensures that a SETA plugin is available.
%      semObsSig = The current block of observation signals� samples
%      semSrcSig = The current block of source signals� samples
%      semSrcNum =
%      semSrcEstArr = An array of source estimates produced from SEPs
%      semSrcEstAlg = Source estimates grouped by SEP
%      semSrcEstGroup = Source estimates grouped by estimated source
%      semSrcEstTA =
%      semSrcEstGroupTA = Time-aligned source estimates grouped by estimated source
%      semCSE = The current CSE
%      semCDSPrev = CDS from previous block
%      
%      Methods:
%      Init() = Plugin-specific initialization procedure. Called by SEM during initialization phase.
%      Update() = Plugin-specific task procedure. Called by SEM during runtime after a new
%      	data-block has been acquired.
%      Shutdown() = Plugin-specific shutdown procedure. Called by SEM during shutdown phase.
%      
%      See also massInfo.
% 
%      See Sect. 3.6.9 in [1]
% 
%      [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%      Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
%
%    Reference page in Doc Center
%       doc PASPlugin
%
%

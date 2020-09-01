%      The abstract Signal Alignment Plugin time-aligns a set of signals
% 
%      Description:
%      The SETAPlugin class is tasked with time-aligning source estimates. Given
%      that source estimates can be supplied as either a single signal array, i.e.
%      semSrctEstArr, or as multiple grouped signal arrays, i.e. semSrcEstGroup, the
%      SETAPlugin is required to time-align signals in both the semSrctEstArr and
%      semSrcEstGroup source estimate sets. Signals will always be provided in
%      semSrctEstArr field, but the semSrcEstGroup SEM data field will only be populated
%      for configurations in which a SEGPlugin is employed, and the SETAPlugin is
%      responsible for checking this field for data. The SEM uses the outputs of a
%      SETAPlugin to populate the semSrcEstArrTA and semSrcEstGrouptTA SEM data
%      fields. The SETAPlugin can also generate the corresponding CDSs for the newly
%      time-aligned signal sets and populate the appropriate cds fields, but this is not
%      required. We note that there is a third group of source estimates provided in the
%      semSrcEstAlg variable, but currently, time-alignment for this group is unsupported.
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
%      setaArr = A SourceEstimate object in which the source estimates
%      	from the semSrctEstArr SEM data field have been time-aligned.
%      setaGroup = An array of SourceEstimate objects in which the
%      	source estimates from the semSrcEstGroup SEM data field
%      	have been time-aligned.
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
%      	methods set this variable to “true” or 1.
%      reqSrcEstGroup = Denotes whether or not the plugin requires
%      	source estimates to be grouped. Setting this to
%      	“true” ensures that a SEG plugin is available.
%      semObsSig = The current block of observation signals’ samples
%      semSrcSig = The current block of source signals’ samples
%      semSrcNum =
%      semSrcEstArr = An array of source estimates produced from SEPs
%      semSrcEstAlg = Source estimates grouped by SEP
%      semSrcEstGroup = Source estimates grouped by estimated source
%      
%      Methods:
%      Init() = Plugin-specific initialization procedure. Called by SEM during initialization phase.
%      Update() = Plugin-specific task procedure. Called by SEM during runtime after a new
%      	data-block has been acquired.
%      Shutdown() = Plugin-specific shutdown procedure. Called by SEM during shutdown phase.
%      
%      See also massInfo.
% 
%      See Sect. 3.6.7 in [1]
% 
%      [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%      Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
%
%    Reference page in Doc Center
%       doc SETAPlugin
%
%

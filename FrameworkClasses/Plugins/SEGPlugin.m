%      The abstract Source Estimate Grouping Pluging sorts the set of source
%      estimates of all SEP outputs into groups containing estimates of a
%      particular source
% 
%      Description:
%      The SEGPlugin is responsible for sorting an array of source estimates into
%      groups where each group consists of the source estimates estimating one source.
%      Each group of source estimates is placed in a SourceEstimate object, and the array of
%      all groups’ SourceEstimate objects constitutes the plugin’s update field. The SEM
%      will use the output of the SEGPlugin to populate the semSrcEstGroup SEM data field
%      of any plugin requiring this data.
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
%      seg = An array of source estimates. Each SourceEstimate object
%      	contains a group of similar source estimates
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
%      reqSrcNum = Denotes whether or not the plugin requires an
%      	estimate of the source number. Setting this to
%      	“true” ensures that a source enumeration
%      	plugin is available.
%      semObsSig = The current block of observation signals’ samples
%      semSrcSig = The current block of source signals’ samples
%      semSrcNum =
%      semSrcEstArr = An array of source estimates produced from SEPs
%      semSrcEstAlg = Source estimates grouped by SEP
%      
%      Methods:
%      Init() = Plugin-specific initialization procedure. Called by SEM during initialization phase.
%      Update() = Plugin-specific task procedure. Called by SEM during runtime after a new
%      	data-block has been acquired.
%      Shutdown() = Plugin-specific shutdown procedure. Called by SEM during shutdown phase.
%      
%      See also massInfo.
% 
%      See Sect. 3.6.6 in [1]
% 
%      [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%      Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
%
%    Reference page in Doc Center
%       doc SEGPlugin
%
%

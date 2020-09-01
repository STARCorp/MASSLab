%      The abstract Source Estimate Production plugin is tasked with
%      performing source separation and producing a set of source estimates
% 
%      Description:
%      The SEPPlugin is responsible for producing source estimates in the MASS
%      framework, and methods for SS are implemented in this class of plugin. The
%      SEPPlugin class has one update field of type SourceEstimate, where the SEPPlugin
%      places its current source estimates for a block in the sig field and optionally the
%      corresponding CDS into the cds field. If a CDS is not supplied, the MASS system
%      assumes that the source estimates are BLTI, and a CDS will be generated using the
%      MASSInfo.CDSEstimator() function. When multiple SEPPlugin implementations run
%      simultaneously in MASS, the SEM collects all source estimates and populates two
%      fields. The first field is a single SourceEstimate object, and all source estimates and
%      CDS are placed in the sig and cds field, respectively. The second field is an array of
%      SourceEstimate objects, where each object corresponds to the output of one
%      SEPPlugin, i.e. the estimates are grouped according to the algorithms. MASS plugins
%      requiring source estimates are provided with both fields, the first being supplied in the
%      plugin’s semSrcEstArr SEM data field, and the second is supplied via the
%      semSrcEstAlg SEM data field.
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
%      se = The current source estimates, and optional CDS.
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
%      semCDSFiltLen =
%      semCDSFiltOffset =
%      semObsSig = The current block of observation signals’ samples
%      semSrcSig = The current block of source signals’ samples
%      semCDS =
%      semSrcNum =
%      
%      
%      Methods:
%      Init() = Plugin-specific initialization procedure. Called by SEM during initialization phase.
%      Update() = Plugin-specific task procedure. Called by SEM during runtime after a new
%      	data-block has been acquired.
%      Shutdown() = Plugin-specific shutdown procedure. Called by SEM during shutdown phase.
%      
%      See also massInfo.
% 
%      See Sect. 3.6.5 in [1]
% 
%      [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%      Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
%
%    Reference page in Doc Center
%       doc SEPPlugin
%
%

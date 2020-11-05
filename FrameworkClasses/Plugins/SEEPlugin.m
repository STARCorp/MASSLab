classdef (Abstract) SEEPlugin < MASSPlugin
%     The abstract Source Estimate Evaluation Plugin is used to evaluate
%     source estimates and create a set of composite source estimates
%
%     Description:
%     The SEEPlugin is charged with evaluating the performance of a set of
%     source estimates and producing a CSE set. An overview of the evaluation topic for
%     MASS was given in Sect. 2.3, and any SEE method should be implemented in an
%     SEEPlugin extension class.
%     
%     Properties:
%     pluginName = A string with a full name of the plugin.
%     pluginVersion = A string with the plugin’s development version.
%     pluginAbbr = A string with an abbreviation of pluginName, typically used in user
%     	displays with strict character limits.
%     pluginDescr = A string containing a description of the plugin’s implemented functionality.
%     pluginStatus = A flag denoting the state of the plugin.
%     paramSetId = A plugin-specific parameter set identification number
%     massInfo = A MASSInfo object that allows the plugin to query the MASS system for
%     	particular parameters and functionality
%     cse = A composite source estimate set.
%     reqBlkLenMin = The minimum amount of data (the data block
%     	length) required by the plugin. Positive values
%     	will indicate the nearest integer value of
%     	samples, while a negative value will indicate
%     	the number of seconds.
%     reqBlkLenMax = The maximum number of data samples (the
%     	data block length) a plugin can handle.
%     	Positive values will indicate the nearest integer
%     	value of samples, while a negative value will
%     	indicate the number of seconds.
%     reqSrcSig  = Denotes whether or not the plugin requires
%     	underlying source signals. Supervised
%     	methods set this variable to “true” or 1.
%     reqSrcNum = Denotes whether or not the plugin requires an
%     	estimate of the source number. Setting this to
%     	“true” ensures that a source enumeration
%     	plugin is available.
%     reqSrcEstGroup = Denotes whether or not the plugin requires
%     	source estimates to be grouped. Setting this to
%     	“true” ensures that a SEG plugin is available.
%     reqSrcEstCDS Bool prot pub Denotes whether or not the plugin requires the
%     	CDS for every source estimate. Setting this to
%     	“true” ensures that all source estimates’ CDSs
%     	are available.
%     reqSrcEstTA = Denotes whether or not the plugin requires
%     	source estimates to be time-aligned. Setting
%     	this to “true” ensures that a SETA plugin is available.
%     semObsSig = The current block of observation signals’ samples
%     semSrcSig = The current block of source signals’ samples
%     semSrcNum =
%     semSrcEstArr = An array of source estimates produced from SEPs
%     semSrcEstAlg = Source estimates grouped by SEP
%     semSrcEstGroup = Source estimates grouped by estimated source
%     semSrcEstTA =
%     semSrcEstGroupTA = Time-aligned source estimates grouped by estimated source
%     
%     Methods:
%     Init() = Plugin-specific initialization procedure. Called by SEM during initialization phase.
%     Update() = Plugin-specific task procedure. Called by SEM during runtime after a new
%     	data-block has been acquired.
%     Shutdown() = Plugin-specific shutdown procedure. Called by SEM during shutdown phase.
%     
%     See also massInfo.
%
%     See Sect. 3.6.8 in [1]
%
%     [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

    
    properties (Hidden)
        % Data from SEM
        semObsSig; % Obervation data acquired by the SEM
        semSrcSig; % Source data acquired by the SEM
        semSrcEstArr; % Source Estimates from SEP Plugins
        semSrcEstAlg; % Source Estimates from SEP Plugins, grouped by algorithm
        semSrcEstGroup; % Source Estimates, grouped by estimated source
        semSrcEstTA; % Source Estimates, time-aligned
        semSrcEstGroupTA; % Source Estimates, grouped and time-aligned
        semSrcNum;
    end
    
    properties (GetAccess = public, SetAccess = protected)
        % Data Provided to SEM
        cse = SourceEstimate;
        
        % Signal Requirements
        reqSrcEstGroup = 0; 
        reqSrcEstTA = 0;
        reqSrcEstCDS = 0;
        reqSrcNum = 0;
        reqSrcSig = 0;
        reqSigFull = 0;
        
        % Signal Processing Requirements
        reqBlkLenMin;
        reqBlkLenMax;
    end
    
    methods
        function obj=SEEPlugin()
            obj.superClassHidden = 'SEEPlugin';
            obj.pluginStatus = 0;
        end
        
        function obj = ShutDown(obj)
        end
    end
end

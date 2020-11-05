classdef ConfigPlugin < MASSPlugin
%     The abstract Configuration Plugin used to acquire configuration
%     information for the MASS system operation
%
%     Description:
%     The ConfigPlugin's only task is to provide the SEM with a Configuration
%     class-extended object, so that the SEM can configure the MASS system. The MASS
%     framework requires a valid configuration to operate. In this version of the framework,
%     the SEM has three constructors: one which takes a Configuration-extended object
%     directly as an argument, and the other two either use a default ConfigPlugin extension
%     when no argument is supplied or take a ConfigPlugin extension object as an
%     argument. Extensions of the ConfigPlugin class could potentially present a GUI, so
%     that a user could create and save particular configurations at will. In Appendix B, we
%     provide a simple, default ConfigPlugin extension that allows a user to choose from
%     pre-defined configurations from the command line in MATLAB.
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
%     
%     Methods:
%     Init() = Plugin-specific initialization procedure. Called by SEM during initialization phase.
%     Update() = Plugin-specific task procedure. Called by SEM during runtime after a new
%     	data-block has been acquired.
%     Shutdown() = Plugin-specific shutdown procedure. Called by SEM during shutdown phase.
%     
%     See also massInfo.
%
%     See Sect. 3.6.2 in [1]
%
%     [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.


   properties (GetAccess = public, SetAccess = protected)
        % Data Provided to SEM
        config = [];
    end
    
    methods
        %Constructor
        function obj=ConfigPlugin()
            obj.superClassHidden = 'ConfigPlugin';
            obj.pluginStatus = 0;
        end
        
        function obj = ShutDown(obj)
        end
    end
    
end

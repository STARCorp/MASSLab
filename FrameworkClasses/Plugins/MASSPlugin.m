classdef (Abstract) MASSPlugin < handle
%     The abstract MASSPlugin defines a base set of fields and methods used
%     by all plugins in the MASS system.  All plugins in MASS extend this
%     class.
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

    
    properties (GetAccess = public, SetAccess = protected)
        pluginName;
        pluginVersion;
        pluginAbbr;
        pluginDescr;
        pluginStatus=0;
        paramSetId;
    end
    
    properties (Access = protected)
        massInfo;
    end
    
    properties (Hidden, Access = protected)
        pluginIdHidden;
        superClassHidden;
    end
    
    methods
        obj = Init(obj);
        obj = Update(obj);
        obj = ShutDown(obj);
        
        function obj = MASSPlugin(), obj.pluginStatus = 0; end
    end
    
    methods (Hidden)
        function out = isMASSPlugin(obj), out=true; end
        
        function out = getSuperClass(obj), out = obj.superClassHidden; end
        function out = getPluginId(obj), out = obj.pluginIdHidden; end
        
        function setMassInfo(obj,MassInfo), obj.massInfo = MassInfo; end
        function setPluginId(obj, PluginId), obj.pluginIdHidden = PluginId; end
    end
    
    methods (Access = protected)
%         function out = getSampRate(obj), out = sem.getSampRate(); end
    end
end


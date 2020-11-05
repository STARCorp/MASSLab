classdef (Sealed) PluginInst < handle
%     Utitlity plugin instance definition
%     
%     Constructor:
%     PluginInst()
%     
%     Properties:
%     pluginClass = A name of a plugin class.
%     pluginParamSetId = A plugin class parameter set identification number.
%     
%     Methods: None
%
%     See Sect. 3.4.4 in [1]
%
%     [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

    properties
        pluginClass='';
        pluginParamSetId=0;
    end
    
    methods
        function obj = PluginInst(PluginClass,PluginParamSetId)
            % PluginInst(PluginClass,PluginParamSetId)
            obj.pluginClass = PluginClass;
            obj.pluginParamSetId=PluginParamSetId;
        end
    end
    
end


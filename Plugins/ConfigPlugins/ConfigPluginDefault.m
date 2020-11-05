classdef ConfigDir < ConfigPlugin
    %A default Confifuration plugin that allows a user to choose from
    %pre-defined configurations in the Configuration folder
    
    properties (Access=private)
        configDir = []; % A directory for configuration files.
    end
    
    methods
        function obj = ConfigDir(ParamSetId)
            obj.pluginName = 'Default Config Plugin';
            obj.pluginVersion ='0.0.1';
            obj.pluginAbbr = 'ConfigPluginDefault';
            obj.pluginDescr = 'Lists Configurations in the Configuration directory for user to choose';
            obj.pluginStatus = 0;
            obj.paramSetId = ParamSetId;
        end
        
        function obj=Init(obj)
            if ~isdir('Configurations')
                
            end
        end
        
        function obj=Run(obj)
            obj.config = [];
            fprintf('\n%s\n','Available Configurations:');
            
            files = dir(fullfile('Configurations','*.m'));
            for kk=1:numel(files)
                fprintf('%d) %s\n', kk,strrep(files(kk).name,'.m',''));
            end
            
            ndx = input('Please type in the number of the Configuration to use:');
            
            strsplit(files(ndx).name,'.');
            obj.config = eval([ans{1} '()']);
        end
        
%         function config = getConfiguration(obj)
%             config = obj.config;
%         end
        
    end
    
end
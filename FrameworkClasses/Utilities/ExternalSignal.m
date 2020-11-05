classdef (Sealed) ExternalSignal
%     The Sealed ExternalSignal class defines data sources or destinations used to
%     acquire input data from or output MASS system data to locations external to the
%     MASS system, respectively. In this version of MASS, the Data Acquisition plugin
%     uses ExternalSignals to acquire observations and side-information, and the Data
%     Output plugin uses an ExternalSignal to define a destination for MASS system
%     outputs.
%     
%     Constructor:
%     ExternalSignal()
%     
%     Properties:
%     name = A descriptive name for identifying the ExternalSignal
%     groupId = An identifier used to group a set of ExternalSignals
%     location = A data location, e.g. a file location, an input device,
%     			 a memory location, etc.
%     varName = A variable name at location, e.g. a variable in a .mat file
%     channel = A channel number for the data source.
%     sampRate = The sampling rate of the signal.
%     type = A data type descriptor for the signal source, e.g. “file”,
%     		 “channel”, “memloc”, etc. used by the DAPlugin and DOPlugin to
%     		 determine how to acquire the signal.
%     
%     Methods: None
%
%     See Sect. 3.4.2 in [1]
%
%     [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
	
    properties 
        id = [];
        name = [];
        groupId = []; 
        sampRate = [];
        location = []; %, Data location identifier, e.g. file location, channel
        channel = [];
        type = []; 
        varName = []; % External Variable name at location
	end
    
    methods
    end
    
end


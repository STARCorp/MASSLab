%      The SourceEstimate class is a Sealed class with two public fields: a float
%      array (Float []) of source estimates’ samples and a float array containing the
%      corresponding CDS used to produce the source estimates. Various systems produce
%      source estimates, and the SourceEstimate class is a container for the signals and the
%      CDS used to create the estimates. This class is provided for generality and may be
%      developed in the future
%      
%      Constructor:
%      SourceEstimate()
%      
%      Properties:
%      sig = An array of source estimate samples
%      cds = A CDS that produces sig when applied to the observations via the CDO.
%      
%      Methods: None
% 
%      See Sect. 3.4.1 in [1]
% 
%      [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%      Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.
%
%    Reference page in Doc Center
%       doc SourceEstimate
%
%

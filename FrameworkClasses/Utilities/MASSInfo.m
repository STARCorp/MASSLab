classdef (Sealed) MASSInfo < handle
%     Provides information about the MASS system to plugins
%     
%     Constructor:
%     MASSinfo()
%     
%     Properties: None
%     
%     Methods:
%     getBlkLen = Returns the data block length.
%     getBlkStep = Returns the data block step.
%     getSampRate = Returns the sampling rate set in configuration.
%     getNumSrc = This function returns an array containing the
%     (possibly time-varying) number of sources that are active in each mixture
%     in a data block. sources at the nth sample of the pth observation. If an
%     SNUM plugin is defined in the MASS configuration, then the SNUM plugin’s
%     output populates the numSrc output of getNumSrc (see Sect. 0).
%     getNumObs = Returns the number of observation signals.
%     getCDS = Returns the current CDS.
%     getCDSPrev = Returns the CDS from the previous block.
%     getCDSFiltLen = Returns the filter length used in the CDS.
%     getCDSFiltOffset = Returns the delay applied in the CDS.
%     getConfig = Returns the configuration used
%     CDO = The CDO function provides the Common Demixing Operation used in the
%     MASS framework, and in this version, it is the BLTI filtering operation
%     given in Sect. 2.2.1.  Sig, Float [] – An [NxP] array of signal samples
%     to be filtered and summed to produce the Q output signals.
%     
%     Krnl, Float [] – An [LxPxQ] sized array of filter coefficients used to
%     filter and sum the P inputs to produce the Q outputs, where L is the
%     filter length. Cnv, String – A string to denote which part of the
%     convolution to use, and can be any of the strings below, and the default
%     is ‘last’.
%     
%     ‘full’ – Produces the full convolution which has a length of M=N+L-1,
%     where N is the length of the input signal and L is the length of the filter.
%     
%     ‘same’, ‘first’, ‘last’ – These produce an output whose length is equal to
%     the length of the input signal, e.g. M=N, where ‘same’ uses the central
%     part of the full convolution, and ‘first’ and ‘last’ produce the first
%     and last parts of the full convolution, respectively.
%     ‘valid’ – Produces the part of the convolution that did not use zero-padding.
%     For a signal of length N and a filter of length L, the result will be of
%     length M=N-L+1 if M>0, or 0, otherwise.
%     
%     out, Float [] – An [MxQ] array of output signal samples, where Q is the
%     output dimension of the Krnl variable above, and M is the signal length
%     determined by the convolution method used in the Cnv variable above.
%     
%     img, Float [] – An [MxPxQ] array of images used to produce the out
%     variable above, where M is the length determined by the convolution
%     method used in the Cnv variable above, and P and Q are dimensions of the
%     Krnl variable above. If we consider that the qth output is the sum of
%     the filtered input signals, then the (m,p,q)th element of img is the mth
%     sample of the filtered pth input used to produce the qth output.
%     SysIdOp = The SysIdOp implements the system identification operator,
%     Id{}, defined in Sect. 1.2.3. SigArr, Float [] – An [NxK] column-oriented
%     array of signal samples to filtered and summed to estimate the signal
%     in Sig, where N is the length of each signal, and K are the number of signals.
%     
%     Sig, Float [] – An [Nx1] column-oriented vector of signals samples to be
%     estimated via the filtered sum of the samples in SigArr.
%     
%     FiltLen, Integer – The filter length(s) used to estimate Sig from SigArr.
%     
%     Offset, Integer – An integer offset applied to Sig before estimation.
%     A positive value is an advance, and a negative value is a delay.
%     
%     krnl, Float [] – An [LxKx1] array of filter coefficients such that CDO(SigArr,krnl) is an
%     estimate of Sig, where L=FiltLen and K is the number of signals in SigArr.
%     
%     offset, Integer – Before estimation, Sig is time-shifted so that the maximum crosscorrelation
%     between Sig and the signal in SigArr with maximum advance relative to
%     Sig is zero, and the Offset is applied. offset is the total offset applied to Sig.
%     ImgOp = The ImgOp implements the imaging operation, Im{}, defined in Sect. 1.2.3.
%     The image estimation is a special case of SysIdOp above when the first argument is a single
%     signal. Once the krnl is acquired from SysIdOp, the signal is filtered
%     via CDO to produce the image.
%     Sig1, Float [] – An [Nx1] column-oriented vector of signal samples, which
%     when filtered, provides an estimate of Sig2.
%     
%     Sig2, Float [] – An [Nx1] column-oriented vector of signal samples to
%     be estimated via filtered vesion of Sig1.
%     
%     FiltLen, Integer – The filter length used to estimate Sig2 from Sig1.
%     
%     Offset, Integer – An integer offset applied to Sig2 before estimation.
%     A positive value is an advance, and a negative value is a delay.
%     
%     img, Float []– The filtered version of Sig1 estimating Sig2.
%     
%     filt, Float [] – The filter used to estimate Sig2 from Sig1. filt is the
%     krnl variable obtained from SysIdOp(Sig1, Sig2, FiltLen, Offset).
%     See SysIdOp above. The img signal is produced by either output of
%     CDO(Sig1, filt). See CDO above.
%     
%     offset, Integer – The total offset applied to Sig2 before estimation. See “offset” in
%     SysIdOp above.
%     CDSEstimator = The CDSEstimator function estimates the CDS for a source
%     estimate. In this work, the CDS is a linear filter array, and CDSEstimator
%     is equivalent to SysIdOp when the SigArr variable is the observation data,
%     FiltLen = MASSInfo.getCDSFiltLen(), and
%     Offset = MASSInfo.getCDSFiltOffset().
%     Sig, Float [] – An [Nx1] column-oriented vector of signal samples for
%     which a CDS is to be estimated from the [NxP] array of observation samples.
%     
%     krnl, Float [] – An [LxPx1] sized array of filter coefficients used to
%     filter and sum the P observation signals to produce an estimate of Sig,
%     where L is the filter length given in getCDSFiltLen().
%     
%     offset, Integer – An offset applied to Sig prior to CDS estimation.
%     See “offset” in SysIdOp above.
%
%     See Sect. 3.4.3 in [1]
%
%     [1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation",
%     Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

    properties (Hidden)
        sem = [];
    end
    
    methods (Hidden)
        function out = getConfig(obj), out = obj.sem.getConfig; end
    end
    
    methods
        function obj = MASSInfo(SEM)
            obj.sem = SEM;
        end
        
        %Data retrieval functions
        function out = getBlkLen(obj), out = obj.sem.getBlkLen; end
        
        function out = getBlkStep(obj), out = obj.sem.getBlkStep; end
        
        function out = getSampRate(obj), out = obj.sem.getSampRate; end
        
        function out = getNumObsSig(obj), out = obj.sem.getNumObsSig; end
        
        function out = getNumSrcSig(obj), out = obj.sem.getNumSrcSig; end
        
        function out = getNumSrc(obj), out = obj.sem.getNumSrc; end
        
        function out = getCDS(obj), out = obj.sem.getCDS;  end
        
        function out = getCDSPrev(obj), out = obj.sem.getCDSPrev; end
        
        function out = getCDSFiltLen(obj), out = obj.sem.getCDSFiltLen; end
        
        function out = getCDSFiltOffset(obj), out = obj.sem.getCDSFiltOffset; end
        
        
        
        % Miscellaneous Sig Proc functions
        function [img,filt,offset] = ImgOp(obj,S,X,FILTLEN,OFFSET)
            [img,filt,offset] = obj.sem.ImgOp(S,X,FILTLEN,OFFSET);
        end
        
        function [out,img] = CDO(obj,SIG,KRNL,CNV)
            if nargin<3, CNV=[]; end
            [out,img] = obj.sem.CDO(SIG,KRNL,CNV);
        end
        
        function [krnl,offset] = SysIdOp(obj,SIGARR,SIG,FILTLEN,OFFSET)
            [krnl,offset] = obj.sem.SysIdOp(SIGARR,SIG,FILTLEN,OFFSET);
%             krnl3_plot(krnl,10);
        end
       
        function [krnl,offset] = CDSEstimator(obj,SIG)
            [krnl,offset] = obj.sem.CDSEstimator(SIG,FILTLEN,OFFSET);
        end
    end
    
end


A Framework for Multiple Algorithm Source Separation

SUMMARY:
This code implements the framework described in [1].  Although the MASS framework can be used to research blind/semi-blind/informed source separation in a multi-channel domain, MASS allows for the study of many single/multi-channel, general signal processing topics with the added benefits of easily transmitted configurations for experiment reproduction and plugin-able data metrics.  This repo will allow users to develop the MASS framework.

To execute the Examples, all directories and sub-directories need to be on the MatLab path.

A complete explanation of this code can be found in [1], which is supplied in pdf format in the Docs folder of this repo.

[1] Gilbert, K.D., "A Framework for Multiple Algorithm Source Separation", Ph.D. Dissertation, University of Massachusetts Dartmouth, Jan. 2019.

REPO FOLDER SUMMARY:
1) EXAMPLES: Any new user should start here.  Read [1] alongside the examples.
2) CONFIGURATIONS:  The heart of MASS.  Understand Configurations. Go to 1) if necessary.
3) DATASETS: This data is provided to study MASS and reproduce the results in [1].  You can use your own data.
4) DOCS: For now, [1]. Later, tutorials.
5) FRAMEWORK CLASSES: the classes that DEFINE the plugins and utilities in the MASS framework. 
6) PLUGINS: the extensions of the Framework Plugins that do the work.  Inspect the examples given here to understand how to implement your methods.
7) FUNCTIONS: Miscellaneous functions imported by other pieces of the framework.
8) MASS_SEM:  Controller. See Ch. 2 in [1] for overview, see Sects. 3.1 & 3.2 in [1] for general MASS framework relevancy, and see Sect. 3.7 in [1] for details of usage.










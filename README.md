# S-Curve Generator #

This easy-to-use MATLAB code generates the S-shaped curve for a well-stirred reactor using arc-length continuation, performed using [MatCont](https://sourceforge.net/projects/matcont/).

## Prerequisites ##

This code makes use of the following MATLAB toolboxes

* [Cantera](http://cantera.org/docs/sphinx/html/index.html) 
* [MatCont](https://sourceforge.net/projects/matcont/)
* [MATLAB-YAML](http://vision.is.tohoku.ac.jp/~kyamagu/software/yaml/)


## How to use ##

Provide the required inputs in the YAML format. The important parameters are

* Palette : List the compounds in the fuel
* Composition : Mole fractions of each of the palette compounds
* Mechanism : Can be provided in CTI or XML format
* Mixture Name : Corresponds to which mixture is to be used in the mechanism
* Pressure
* Temperature
* Volume of combustor
* Equivalence Ratio

Once this is done, just go to `gen_s_curve.m` and 
* input the `go_backwards` option to indicate direction of the S-curve generation
* specify `start_mdot`, which corresponds to the initial mass flow rate. 

Note that when you go backwards, you should specify high initial mass flow rates and the opposite in the other case.

Running the code multiple times continues the previous solution. Remember that the tangent direction reverses at each limit point.

Following this, options for arc-length continuation can be specified. These are discussed in detail in the MatCont [documentation](https://sourceforge.net/projects/matcont/files/NewestDocumentation/) (Link might expire eventually, go to SourceForge repo if required) 


## Example ## 

An example curve for 1-step methane is as follows

![Example-Figure](https://image.ibb.co/fZ5RRm/sample.jpg)



## Who do I talk to? ##

* Repo owner or admin : [Pavan Bharadwaj](https://github.com/gpavanb)
* Other community or team contact : The code was developed at the Flow Physics and Computational Engineering group at Stanford University. Please direct any official queries to [Prof. Matthias Ihme](mailto:mihme@stanford.edu)

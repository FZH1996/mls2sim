MLS2Sim
=======

MLS2Sim is a Matlab library for communication with [S2Sim](https://github.com/asakyurek/S2Sim).
The library defines Matlab classes and functions for formatting and parsing messages and data structures defined in S2Sim.
It will be kept updated to support the most current version of the S2Sim communication protocol.

Requirements
------------

The library requires the Instrument Control Toolbox of Matlab for TCP/IP communication.
It has been tested with Matlab 2012a.
However it should work on all newer versions of Matlab, and perhaps some older versions.
In the future, the dependency on the Instrument Control Toolbox will be removed by using a Java-based web-socket library directly.

Installation
------------

Download all the files into a folder, for example `mls2sim`, which is accessible from Matlab.
In Matlab, add the path of `mls2sim` by calling `addpath` followed by the path.
The command can be added to the script `startup.m` to make MLS2Sim available by default.

Documentation
-------------

Currently there is no manual for the library.
Many functions and classes in the library have extensive help lines and comments, which will help the user to understand how they work.
Several test scripts are provided in the subfolder `tests` to help the user start using MLS2Sim.

A manual for MLS2Sim may be written in the future.

About Us
--------

- MLS2Sim is developed at the [mLAB](http://mlab.seas.upenn.edu/) - Real-Time and Embedded Systems Lab at the University of Pennsylvania.
- It is partially supported by the [TerraSwarm](http://www.terraswarm.org/) Research Center.
- The main developer is [Truong X. Nghiem](http://www.seas.upenn.edu/~nghiem/).
- The advisor is [Prof. Rahul Mangharam](http://www.seas.upenn.edu/~rahulm/).


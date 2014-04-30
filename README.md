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
In Matlab, add the following paths by calling `addpath`:

- (Path to MLS2Sim)
- (Path to MLS2Sim)/utils

The command can be added to the script `startup.m` to make MLS2Sim available by default.

Documentation
-------------

Currently there is no official manual for the library.
Many functions and classes in the library have extensive help lines and comments, which will help the user to understand how they work.
Several test scripts are provided in the subfolder `tests` to help the user start using MLS2Sim.

Currently, only a few messages are implemented in the library, mostly for synchronous clients.
Unsupported incoming messages are wrapped in an object of class `S2SIMMsgDataRaw`.
To implement a new message type, you need to create a new subclass of `S2SIMMsgData` and update the file `private/CreateDataObject.m` accordingly.
If possible, please ask me to merge your code into the library.
If you don't want to write the code, you can email me to ask for support of that message type; however I don't guarantee that I will work on it soon.

The `utils` folder contains some useful functions for working with S2Sim, for example to convert back and forth between Epoch time values and Matlab's DateNum values (Matlab's internal date and time representation).

A manual for MLS2Sim may be written in the future.

About Us
--------

- MLS2Sim is developed at the [mLAB](http://mlab.seas.upenn.edu/) - Real-Time and Embedded Systems Lab at the University of Pennsylvania.
- It is partially supported by the [TerraSwarm](http://www.terraswarm.org/) Research Center.
- The main developer is [Truong X. Nghiem](http://www.seas.upenn.edu/~nghiem/).
- The advisor is [Prof. Rahul Mangharam](http://www.seas.upenn.edu/~rahulm/).


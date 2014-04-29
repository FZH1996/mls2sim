classdef S2SimClientApp < handle
    %S2SimClientApp A periodically triggered S2Sim client.
    %   This class defines a framework for creating an S2Sim client in
    %   Matlab, which is executed periodically. Examples include
    %   discrete-time control systems, building simulators like EnergyPlus.
    %   Necessary methods are defined for the execution and communication
    %   between the client and S2Sim. A new client can be created by
    %   subclassing this parent class and implement/override the
    %   appropriate methods.
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
    %             University of Pennsylvania
    
    
    properties (Access=protected)
        SS_socket               % the tcpip socket object for connecting with S2Sim
        SS_server = '';
        SS_port = [];
        SS_name = '';           % name of the client/object in S2Sim system
        SS_timeout = [];        % timeout for connection with S2Sim
        bRunning = false;
    end
    
    methods
        function obj = S2SimClientApp
        end
        
        function start(obj)
        end
        
        function b = isRunning(obj)
            b = obj.bRunning;
        end
    end
    
    methods (Access=protected)
        % These methods are to implement the operation of the client, and
        % should be overridden/implemented by the subclass.
        function initialize(obj)
        end
    end
    
    methods (Access=protected)
        % These methods are to implement the error handling mechanism,
        % and should be overridden/implemented by the subclass.
        function ErrorInit(obj)
        end
    end
    
end


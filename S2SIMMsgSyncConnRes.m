classdef S2SIMMsgSyncConnRes < S2SIMMsgData
    %Class for S2SIM message's data: Synchronous Client Connection Response
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
        
    properties (GetAccess=public,SetAccess=protected)
        Result = uint32(0);  % request result [1:4]
        CurrentTime = int32(0);  % system time (epoch) [5:8]
        NumberClients = uint16(0);  % number of clients [9:10]
        SystemMode = uint16(0);  % system mode [11:12]
        TimeStep = int32(0);  % system time step (in seconds) [13:16]
    end
    
    methods
        function obj = S2SIMMsgSyncConnRes(varargin)
            obj = obj@S2SIMMsgData(varargin{:});
        end
    end
    
    methods
        % This function returns the message's data as a vector of bytes
        % (uint8). The data will be converted to uint8 by using uint8(),
        % not typecast(), so you may lose data if the returned data is not
        % already in byte format.
        function data = FormatData(obj)
            error('A client should not format a server''s response message.');
        end
        
        % This function parses the data structure, stored in a vector of
        % uint8, to extract the details specific to the message type.
        function obj = ParseData(obj, data)
            % Request result
            obj.Result = fromBytesNBO(data(1:4), 'uint32');
            obj.CurrentTime = fromBytesNBO(data(5:8), 'int32');
            obj.NumberClients = fromBytesNBO(data(9:10), 'uint16');
            obj.SystemMode = fromBytesNBO(data(11:12), 'uint16');
            obj.TimeStep = fromBytesNBO(data(13:16), 'int32');
        end
    
        function t = GetMessageType(obj)
            % Return the message type as an uint16
            t = uint16(1);
        end
        
        function id = GetMessageID(obj)
            % Return the message ID as an uint16
            id = uint16(5);
        end
    end
    
end


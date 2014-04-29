classdef S2SIMMsgSysTimeRes < S2SIMMsgData
    %Class for S2SIM message's data: System Time Response (type:1, id:7)
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
        
    properties (GetAccess=public,SetAccess=protected)
        CurrentTime = int32(0);  % system time (epoch) [1:4]
    end
    
    methods
        function obj = S2SIMMsgSysTimeRes(varargin)
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
            obj.CurrentTime = fromBytesNBO(data(1:4), 'int32');
        end
    
        function t = GetMessageType(obj)
            % Return the message type as an uint16
            t = uint16(1);
        end
        
        function id = GetMessageID(obj)
            % Return the message ID as an uint16
            id = uint16(7);
        end
    end
    
end


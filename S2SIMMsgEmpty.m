classdef S2SIMMsgEmpty < S2SIMMsgData
    %Class for S2SIM message's data: empty message (e.g. to prompt S2Sim).
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
    
    properties (Access=protected)
        MsgType
        MsgID
    end
    
    methods
        function obj = S2SIMMsgEmpty(type, id)
            % Create a message data object with given type and id
            % type/id could be a number or a string (hex number)
            narginchk(2, inf);
            
            if ischar(type)
                obj.MsgType = hex2dec(type);
            else
                obj.MsgType = uint16(type);
            end
            if ischar(id)
                obj.MsgID = hex2dec(id);
            else
                obj.MsgID = uint16(id);
            end
        end

        % This function returns the message's data as a vector of bytes
        % (uint8). The data will be converted to uint8 by using uint8(),
        % not typecast(), so you may lose data if the returned data is not
        % already in byte format.
        function data = FormatData(~)
            data = uint8([]);
        end
        
        % This function parses the data structure, stored in a vector of
        % uint8, to extract the details specific to the message type.
        function obj = ParseData(obj, ~)
        end
    
        function t = GetMessageType(obj)
            % Return the message type as an uint16
            t = uint16(obj.MsgType);
        end
        
        function id = GetMessageID(obj)
            % Return the message ID as an uint16
            id = uint16(obj.MsgID);
        end
    end
    
end


classdef S2SIMMsgDataRaw < S2SIMMsgData
    %Class for raw S2SIM message's data (no parsing).
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
        
    properties (Access=protected)
        RawData = uint8([]);   % This is the raw data
        MsgType = uint16(0);
        MsgID = uint16(0);
    end
    
    methods
        function obj = S2SIMMsgDataRaw(data, type, id)
            % S2SIMMsgDataRaw(data, msgType, msgID)
            % All arguments are optional
            if nargin > 0
                obj = ParseData(obj, data);
                if nargin > 1
                    obj.MsgType = uint16(type);
                    if nargin > 2
                        obj.MsgID = uint16(id);
                    end
                end
            end
        end
    end
    
    methods
        % This function returns the message's data as a vector of bytes
        % (uint8). The data will be converted to uint8 by using uint8(),
        % not typecast(), so you may lose data if the returned data is not
        % already in byte format.
        function data = FormatData(obj)
            data = obj.RawData;
        end
        
        % This function parses the data structure, stored in a vector of
        % uint8, to extract the details specific to the message type.
        function obj = ParseData(obj, data)
            obj.RawData = cast(data, 'uint8');
        end
    
        function t = GetMessageType(obj)
            % Return the message type as an uint16
            t = obj.MsgType;
        end
        
        function obj = SetMessageType(obj, type)
            obj.MsgType = uint16(type);
        end
        
        function id = GetMessageID(obj)
            % Return the message ID as an uint16
            id = obj.MsgID;
        end
        
        function obj = SetMessageID(obj, id)
            obj.MsgID = uint16(id);
        end
    end
    
end


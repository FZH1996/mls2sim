classdef S2SIMMsgSyncConnReq < S2SIMMsgData
    %Class for S2SIM message's data: Synchronous Client Connection Request
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
        
    properties (SetAccess=protected,GetAccess=public)
        ObjName = '';  % Object name (string)
    end
    
    methods
        function obj = S2SIMMsgSyncConnReq(name)
            if nargin > 0
                assert(ischar(name) && isvector(name),...
                    'Object name must be a string.');
                obj.ObjName = name;
            end
        end

        % This function returns the message's data as a vector of bytes
        % (uint8). The data will be converted to uint8 by using uint8(),
        % not typecast(), so you may lose data if the returned data is not
        % already in byte format.
        function data = FormatData(obj)
            % number of 0x00 bytes padding
            R = mod(length(obj.ObjName), 4);
            data = [uint8(obj.ObjName), repmat(uint8(0), 1, 4-R)];
        end
        
        % This function parses the data structure, stored in a vector of
        % uint8, to extract the details specific to the message type.
        function obj = ParseData(obj, data)
            obj.ObjName = deblank(char(data));
        end
    
        function t = GetMessageType(obj)
            % Return the message type as an uint16
            t = uint16(1);
        end
        
        function id = GetMessageID(obj)
            % Return the message ID as an uint16
            id = uint16(4);
        end
    end
    
end


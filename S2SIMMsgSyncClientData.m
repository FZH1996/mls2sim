classdef S2SIMMsgSyncClientData < S2SIMMsgData
    %Class for S2SIM message's data: Synchronous Client Data (type 3, id 5)
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
    
    properties (GetAccess=public, SetAccess=protected)
        Demand = uint32(0);  % the energy demand, in Watts, and should be uint32
    end
    
    methods
        function obj = S2SIMMsgSyncClientData(demand)
            if nargin > 0
                obj = SetDemand(obj, demand);
            end
        end
        
        function obj = SetDemand(obj, demand)
            obj.Demand = uint32(demand);
        end

        % This function returns the message's data as a vector of bytes
        % (uint8). The data will be converted to uint8 by using uint8(),
        % not typecast(), so you may lose data if the returned data is not
        % already in byte format.
        function data = FormatData(obj)
            data = toBytesNBO(uint32(obj.Demand));
        end
        
        % This function parses the data structure, stored in a vector of
        % uint8, to extract the details specific to the message type.
        function obj = ParseData(obj, data)
            obj.Demand = fromBytesNBO(data(1:4), 'uint32');
        end
    
        function t = GetMessageType(~)
            % Return the message type as an uint16
            t = uint16(3);
        end
        
        function id = GetMessageID(~)
            % Return the message ID as an uint16
            id = uint16(5);
        end
    end
    
end


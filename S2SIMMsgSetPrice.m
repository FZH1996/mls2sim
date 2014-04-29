classdef S2SIMMsgSetPrice < S2SIMMsgData
    %Class for S2SIM message's data: Set Current Price (from S2Sim)
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
        
    properties (GetAccess=public,SetAccess=protected)
        TimeBegin = uint32(0);  % beginning time for the price(s)
        Prices = uint32(0);  % price values, as a vector of single-precision floating numbers
    end
    
    methods
        function obj = S2SIMMsgSetPrice(varargin)
            obj = obj@S2SIMMsgData(varargin{:});
        end
    end
    
    methods
        % This function returns the message's data as a vector of bytes
        % (uint8). The data will be converted to uint8 by using uint8(),
        % not typecast(), so you may lose data if the returned data is not
        % already in byte format.
        function data = FormatData(obj) %#ok<MANU,STOUT>
            error('A client should not format a server''s response message.');
        end
        
        % This function parses the data structure, stored in a vector of
        % uint8, to extract the details specific to the message type.
        function obj = ParseData(obj, data)
            obj.TimeBegin = fromBytesNBO(data(1:4), 'uint32');

            N = double(fromBytesNBO(data(5:8), 'uint32'));  % number of price points
            assert(N > 0, 'S2Sim error: number of price points must be > 0.');
            assert(length(data) >= 8 + N*4, 'S2Sim error: not enough data for price points.');
            
            obj.Prices = fromBytesNBO(data(9:(8+N*4)), 'uint32')';
        end
    
        function t = GetMessageType(~)
            % Return the message type as an uint16
            t = uint16(3);
        end
        
        function id = GetMessageID(~)
            % Return the message ID as an uint16
            id = uint16(2);
        end
    end
    
end


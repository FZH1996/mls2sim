classdef S2SIMMsgData
    %Base Class for S2SIM message's data.
    %   This class defines the basic structure that represents the data in
    %   an S2SIM message. Each type of messages should implement a subclass
    %   of this class and provide methods and properties specific to that
    %   type.
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
        
    methods
        function obj = S2SIMMsgData(data)
            % if there is an argument, it should be the data to be parsed
            if nargin > 0
                obj = ParseData(obj, data);
            end
        end
    end
    
    methods (Abstract)
        % These abstract methods must be defined by the subclass for
        % specific message types
        
        % This function returns the message's data as a vector of bytes
        % (uint8). The data will be converted to uint8 by using uint8(),
        % not typecast(), so you may lose data if the returned data is not
        % already in byte format.
        data = FormatData(obj);
        
        % This function parses the data structure, stored in a vector of
        % uint8, to extract the details specific to the message type.
        obj = ParseData(obj, data);
    
        t = GetMessageType(obj);  % Return the message type as an uint16
        id = GetMessageID(obj);  % Return the message ID as an uint16
    end
    
end


classdef S2SIMMessage
    %S2SIMMessage Class for an S2SIM message.
    %   This class defines the basic structure for an S2SIM message. It
    %   provides the abilities to parse the header of a message and
    %   extract the data. The actual data fields need to be parsed and
    %   extracted by a subclass inherited from class S2SIMMsgData.
    %
    %   This class supports S2SIM communication protocol version 1.1.
    %
    %Message Properties:
    %   SenderID    - ID of the sender (uint16)
    %   ReceiverID  - ID of the receiver (uint16)
    %   SeqNumber   - sequence number of the sent message (uint32)
    %
    %Message Methods:
    %
    %
    %An S2SM message is parsed as follows:
    %   - First, the byte vector is parsed by Message class to extract
    %   the header information and the message's data:
    %           message = S2SIMMessage(theMessageBytes);
    %   - Then access the data by calling message.Data, which is an object
    %   of a subclass of S2SIMMsgData, based on the actual type of the message.
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
    
    properties
        SenderID = 0;   % uint16
        ReceiverID = 0; % uint16
        SeqNumber = 0;  % uint32
    end
    
    properties (Access=protected, Constant)
        startOfMessage = uint8([hex2dec('12') hex2dec('34') hex2dec('56') hex2dec('78')]);
        endOfMessage = uint8([hex2dec('FE') hex2dec('DC') hex2dec('BA') hex2dec('98')]);
    end
    
    properties (Access=public, Constant)
        % Commonly used constants
        S2SimAddress = uint16(0);
        NewClientAddress = uint16(hex2dec('FFFF'));
    end
        
    properties (SetAccess=protected,GetAccess=public)
        % Users should not have access to these internal data of the
        % message. Subclasses should be used to store the data.
        Data            % the message's data, subclass of MsgData

    end
    
    methods
        function obj = S2SIMMessage(msg)
            if nargin > 0
                if isa(msg, 'S2SIMMessage')
                    obj = msg;
                elseif isa(msg, 'S2SIMMsgData')
                    obj.Data = msg;
                elseif isscalar(msg) && (isa(msg, 'double') || isa(msg, 'tcpip'))
                    % If msg is a scalar double number then it's a file
                    % handle (for a stream of bytes)
                    obj = obj.ParseMessageFromFile(msg);
                elseif isvector(msg) && isa(msg, 'uint8')
                    obj = obj.ParseMessage(msg);  % msg must be a vector of uint8 values
                else
                    error('The message to be parsed must be either from a file or a vector of uint8 (byte) values.');
                end
            else
                % an empty argument list
                obj.Data = S2SIMMsgDataRaw();  % Data is empty; make sure it's a MsgData subclass
            end
        end
        
        function msg = FormatMessage(obj)
            % Format the entire message as a vector of bytes (uint8), ready
            % to be sent to S2SIM
            
            % Update the message's data
            data = cast(obj.Data.FormatData, 'uint8');
            data = data(:).';  % convert to row vector
            DataSize = length(data);
            
            % Get the message type and ID
            MsgType = obj.Data.GetMessageType;
            MsgID = obj.Data.GetMessageID;
            
            % format the message
            msg = [obj.startOfMessage,...
                toBytesNBO(uint16(obj.SenderID)),...
                toBytesNBO(uint16(obj.ReceiverID)),...
                toBytesNBO(uint32(obj.SeqNumber)),...
                toBytesNBO(uint16(MsgType)),...
                toBytesNBO(uint16(MsgID)),...
                toBytesNBO(uint32(DataSize)),...
                data,...
                obj.endOfMessage];
        end
        
        function obj = SetData(obj, data)
            assert(isa(data, 'S2SIMMsgData'),...
                'The message''s data must be an object of class "S2SIMMsgData"');
            obj.Data = data;
        end
    end
    
    methods (Access=protected)
        function obj = ParseMessage(obj, msg)
            % This function parses a message (vector of bytes uint8) and
            % create a Message object. It will recognize different message
            % types, and if such type is supported, it will create the
            % respective data object.
            
            error('Parsing a data vector is not yet supported.');
        end
        
        function obj = ParseMessageFromFile(obj, thefile)
            % This function reads and parses a message from a file and
            % create a Message object. It will recognize different message
            % types, and if such type is supported, it will create the
            % respective data object.
            
            % IMPORTANT: tcpip object is different from normal file object
            % It DOES NOT convert the read data into appropriate type, but
            % always returns double precision values. So we MUST convert
            % the read data to uint8.
            % Furthermore, the read data is always a column vector.
            
            % Read the header and check it (4 bytes)
            nRead = 4;
            [data, count] = fread(thefile, nRead, 'uint8');
            data = uint8(data)';
            if count < nRead || ...
                    typecast(data, 'uint32') ~= typecast(obj.startOfMessage, 'uint32')
                error('Invalid message: message header not matched.');
            end
            
            % Get the ID's (two uint16)
            nRead = 4;
            [data, count] = fread(thefile, nRead, 'uint8');
            data = uint8(data)';
            if count < nRead
                error('Invalid message: ID''s not found.');
            end
            obj.SenderID = fromBytesNBO(data(1:2), 'uint16');
            obj.ReceiverID = fromBytesNBO(data(3:4), 'uint16');
            
            % Get the sequence number (one uint32)
            nRead = 4;
            [data, count] = fread(thefile, nRead, 'uint8');
            data = uint8(data)';
            if count < nRead
                error('Invalid message: sequence number not found.');
            end
            obj.SeqNumber = fromBytesNBO(data, 'uint32');
            
            % Get the message type and ID (two uint16)
            nRead = 4;
            [data, count] = fread(thefile, nRead, 'uint8');
            data = uint8(data)';
            if count < nRead
                error('Invalid message: message type/ID not found.');
            end
            msgType = fromBytesNBO(data(1:2), 'uint16');
            msgID = fromBytesNBO(data(3:4), 'uint16');
            
            % Get the message data length (uint32)
            nRead = 4;
            [data, count] = fread(thefile, nRead, 'uint8');
            data = uint8(data)';
            if count < nRead
                error('Invalid message: data length not found.');
            end
            nRead = double(fromBytesNBO(data, 'uint32'));  % very stupid that tcpip/fread does not accept integer numbers

            % Get the message data (nRead bytes)
            [msgData, count] = fread(thefile, nRead, 'uint8');
            msgData = uint8(msgData)';
            if count < nRead
                error('Invalid message: message''s data not found.');
            end
            
            % Get and check the "message ends" signature (4 bytes)
            nRead = 4;
            [data, count] = fread(thefile, nRead, 'uint8');
            data = uint8(data)';
            if count < nRead || ...
                    typecast(data, 'uint32') ~= typecast(obj.endOfMessage, 'uint32')
                error('Invalid message: message end not matched.');
            end
            
            % Create the data object
            obj.Data = CreateDataObject(msgType, msgID, msgData);
        end
    end
    
end


function obj = CreateDataObject( msgType, msgID, msgData )
%CREATEDATAOBJECT Create the S2SIM data object corresponding to type & ID
%   Return an object of a subclass of S2SIMMsgData.
%   Only work for parsing received data into objects, not to create
%   messages to be sent to servers.
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

switch msgType
    case 1  % CONNECTION CONTROL
        switch msgID
            case 5  % Synchronous Client Connection Response 
                obj = S2SIMMsgSyncConnRes(msgData);
            case 7  % System Time Response
                obj = S2SIMMsgSysTimeRes(msgData);
            case 9  % System Version Response
                obj = S2SIMMsgSysVerRes(msgData);
            otherwise
                CreateRawDataObject;
        end
    case 3  % PRICE SIGNALING
        switch msgID
            case 2  % Set Current Price
                obj = S2SIMMsgSetPrice(msgData);
            otherwise
                CreateRawDataObject;
        end
    otherwise
        CreateRawDataObject;
end

    function CreateRawDataObject
        % Create raw (unknown) data object. To be called for unsupported
        % messages.
        obj = S2SIMMsgDataRaw(msgData, msgType, msgID);
    end

end


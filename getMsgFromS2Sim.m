function [status, msg, seq] = getMsgFromS2Sim( socket, msgType, msgID, nTrials, async )
%GETMSGFROMS2SIM A wrapper function to receive the next message from S2Sim.
%   [...] = getMsgFromS2Sim(socket)
%gets the next message from S2Sim (communication through socket).
%
%   [...] = getMsgFromS2Sim(socket, msgType, msgID, nTrials)
%gets the next message of a given type and id from S2Sim, after at most
%nTrials (default: 10) unmatched messages.  If msgID is omitted or empty,
%any message of type msgType will be matched.  If msgType is a string
%instead of a number, messages of class ['S2SIMMsg' msgType] will match
%(msgID will be ignored).
%
%   [status, msg, seq] = getMsgFromS2Sim(...)
%returns:
%   + status = 0 if successful; > 0 if there is an error in the
%     communication (e.g. time-out) or in the message format (e.g.
%     message's header is invalid); < 0 if no messages were matched after
%     nTrials messages.
%   + msg is the matched received message, which is an object of class
%     S2SIMMessage. If the function failed (status ~= 0) then msg will be
%     an error message string.
%   + seq is the sequence number from the message (convenient for using in
%     the next function call to send a message to S2Sim).
%
%   [status, msg, seq] = getMsgFromS2Sim(..., async)
%reads with asynchronous mode switched on or off based on the argument
%async = true or false.  If async = false (default), the function will wait
%until messages arrive or until timeout (which results in status > 0; see
%above).  If async = true, it will not wait and return immediately with
%status = 2 if there is no data in the input buffer (if there is another
%error, e.g. invalid message format, status = 1).  Therefore, depending on
%the application, a status of 2 could be an error or not.
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

matching = nargin > 1 && ~isempty(msgType);  % Do we need to match specific message class(es)
if matching
    matchingName = ischar(msgType);
    matchingType = isnumeric(msgType) && msgType >= 0;
    assert(matchingName || matchingType, ...
        'Argument msgType must be either a string or a non-negative number.');
    
    if matchingName
        msgType = ['S2SIMMsg' msgType];  % the full class name of the data object
    else
        msgType = double(msgType);
        matchingID = nargin > 2 && ~isempty(msgID) && isnumeric(msgID) && msgID >= 0;
        if matchingID
            msgID = double(msgID);
        end
    end
    
    if nargin < 4 || isempty(nTrials) || nTrials < 1
        nTrials = 10;
    end
end

if nargin < 5 || isempty(async)
    async = false;
else
    async = boolean(async);
end

seq = 0;
status = -1;  % status < 0 if no messages were matched after nTrials messages

while nTrials > 0
    % In async mode, if no data is available in the input buffer, return
    % immediately
    if async && socket.BytesAvailable == 0
        status = 2;
        msg = 'Async mode: no bytes available';
        return;
    end
    
    try
        msg = S2SIMMessage(socket);
    catch err
        status = 1;  % status code > 0 if communication or message format error
        msg = err.message;
        return;
    end
    
    % a message has been received, if a message class is specified, we need
    % to check if the new message matches the specification
    if matching
        if matchingName
            if isa(msg.Data, msgType)  % matched
                status = 0;
            end
        else % matching by type and id
            if double(msg.Data.getMessageType()) == msgType &&...
                (~matchingID || double(msg.Data.getMessageID()) == msgID)
                status = 0;
            end
        end
    else
        status = 0;  % accept the message if no matching is required
    end
    
    if status == 0
        seq = msg.SeqNumber;
        return;
    end
    
    nTrials = nTrials - 1;
end

end


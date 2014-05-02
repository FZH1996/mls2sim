function [status, socket, id, seq, info ] = connectToS2Sim( server, port, name, timeout )
%CONNECTTOS2SIM Connect to an S2Sim server as a client.
%
% status is 0 if successful, -1 if failed because of communication or
%   because of incorrect messages (then
%   socket will be the exception object in this case), >0 if failed because
%   of S2Sim system (e.g. object not found, in this case socket will be []
%   and id will contain the error message).
% socket is the tcpip socket object, which is valid if and only if status
%   is 0 (successful).
% id is the ID of the client if status = 0; otherwise it is [] if status =
%   -1 and is the error message if status = 1.
% seq is the sequence number of communication between the client and S2Sim.
% info is an S2SIMMsgSyncConnRes object, which contains more information on
%   the S2Sim's current state. It is [] if there is any error.
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

narginchk(3, inf);

if nargin > 3
    assert(isscalar(timeout) && isnumeric(timeout) && timeout > 0, ...
        'TimeOut must be a positive number or inf.');
else
    timeout = [];
end

% status = 0;
id = [];
info = [];
seq = [];

% Open socket
socket = tcpip(server, port, 'NetworkRole', 'client');
if ~isempty(timeout)
    set(socket, 'Timeout', timeout);
end

try
    fopen(socket);
catch err
    status = -1;
    socket = err;
    return;
end

% Send the registration message
try
    sendMsgToS2Sim(socket, S2SIMMessage.NewClientAddress, 0, S2SIMMsgSyncConnReq(name));
catch err
    status = -1;
    fclose(socket);
    
    socket = err;
    return;
end

%% Receive response
try
    rcvMsg = S2SIMMessage(socket);
catch err
    status = -1;
    fclose(socket);
    
    socket = err;
    return;
end

rcvData = rcvMsg.Data;
if isa(rcvData, 'S2SIMMsgSyncConnRes')
    status = rcvData.Result;
    if status ~= 0
        fclose(socket);
        delete(socket);
        socket = [];
        
        switch status
            case 1
                id = 'Object Id Not Found';
            otherwise
                id = 'Unknown S2Sim error';
        end
        
        return;
    end
    id = rcvMsg.ReceiverID;
    seq = rcvMsg.SeqNumber;
    info = rcvData;
else
    % Received message is not a connection response --> error
    status = -1;
    fclose(socket);
    
    socket = MException('MLS2SIM:connection', 'Connection request was responded with a wrong message.');
    return;
end


end


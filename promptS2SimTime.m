function [ status, T ] = promptS2SimTime( server, port, timeout )
%PROMPTS2SIMTIME Promt S2Sim server for current time without registering.
%   [ status, T ] = promptS2SimTime( server, port, timeout )
%   prompts the given S2Sim server (at server:port) for its current time
%   without registering a client.  The timeout argument, if provided, is
%   the time-out value for socket communication.
%
%   status is 0 if successful, ~= 0 if there is a communication error.
%   If status is 0, T is the server's time (Epoch time value, double type).
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

narginchk(2, inf);

if nargin > 2
    assert(isscalar(timeout) && isnumeric(timeout) && timeout > 0, ...
        'TimeOut must be a positive number or inf.');
else
    timeout = [];
end

% Open socket
socket = tcpip(server, port, 'NetworkRole', 'client');
if ~isempty(timeout)
    set(socket, 'Timeout', timeout);
end

try
    fopen(socket);
catch err
    status = -1;
    T = err.message;
    return;
end

% Send prompt message
try
    sendMsgToS2Sim(socket, S2SIMMessage.NewClientAddress, 0, S2SIMMsgSysTimePrompt());
catch err
    status = -1;
    fclose(socket);
    
    T = err.message;
    return;
end

% Receive response
[status, msg] = getMsgFromS2Sim(socket, 'SysTimeRes');
if status == 0
    rcvData = msg.Data;
    T = double(rcvData.CurrentTime);
else
    % Error
    T = msg;
end

% close and delete the socket
fclose(socket);
delete(socket);

end


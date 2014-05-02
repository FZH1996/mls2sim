function [ status, major, minor ] = promptS2SimVersion( server, port, timeout )
%PROMPTS2SIMVERSION Promt S2Sim server for its version without registering.
%   [ status, major, minor ] = promptS2SimVersion( server, port, timeout )
%   prompts the given S2Sim server (at server:port) for its version
%   without registering a client.  The timeout argument, if provided, is
%   the time-out value for socket communication.
%
%   status is 0 if successful, ~= 0 if there is a communication error.
%   If status is 0, (major, minor) specifies the server's version.
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

narginchk(2, inf);

if nargin > 2
    assert(isscalar(timeout) && isnumeric(timeout) && timeout > 0, ...
        'TimeOut must be a positive number or inf.');
else
    timeout = [];
end

minor = 0;

% Open socket
socket = tcpip(server, port, 'NetworkRole', 'client');
if ~isempty(timeout)
    set(socket, 'Timeout', timeout);
end

try
    fopen(socket);
catch err
    status = -1;
    major = err.message;
    return;
end

% Send prompt message
try
    sendMsgToS2Sim(socket, S2SIMMessage.NewClientAddress, 0, S2SIMMsgSysVerPrompt());
catch err
    status = -1;
    fclose(socket);
    
    major = err.message;
    return;
end

% Receive response
[status, msg] = getMsgFromS2Sim(socket, 'SysVerRes');
if status == 0
    rcvData = msg.Data;
    major = double(rcvData.MajorVersion);
    minor = double(rcvData.MinorVersion);
else
    % Error
    major = msg;
end

% close and delete the socket
fclose(socket);
delete(socket);

end


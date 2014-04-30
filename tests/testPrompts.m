% Test the system time and version prompts (S2Sim ver 1.2+)

server = 'seelabc.ucsd.edu';
port = 26999;
name = 'canyonview_apt';

%% Prompt for version and system time

% Open socket
socket = tcpip(server, port, 'NetworkRole', 'client');
fopen(socket);

try
    sendMsg = S2SIMMessage(S2SIMMsgSysVerPrompt());
    sendMsg.SenderID = sendMsg.NewClientAddress;
    sendMsg.ReceiverID = sendMsg.S2SimAddress;
    sendMsg.SeqNumber = 0;
    sendData = sendMsg.FormatMessage();
    
    % Send the version prompt message
    fwrite(socket, sendData, 'uint8');
    
    % Print out the version
    nWaits = 0;
    while nWaits < 5  % try at most x times
        rcvMsg = S2SIMMessage(socket);
        rcvData = rcvMsg.Data;
        if isa(rcvData, 'S2SIMMsgSysVerRes')
            success = true;
            break;
        end
        nWaits = nWaits + 1;
    end
    if ~success
        error('We have been waiting for a while but did not receive the version message.');
    end
    fprintf('S2Sim Version: %d.%d\n', double(rcvData.MajorVersion), double(rcvData.MinorVersion));
    
    pause(2);
    
    sendMsg = S2SIMMessage(S2SIMMsgSysTimePrompt());
    sendMsg.SenderID = sendMsg.NewClientAddress;
    sendMsg.ReceiverID = sendMsg.S2SimAddress;
    sendMsg.SeqNumber = 0;
    sendData = sendMsg.FormatMessage();
    
    % Send the time prompt message
    fwrite(socket, sendData, 'uint8');
    
    % Print out the time
    nWaits = 0;
    while nWaits < 5  % try at most x times
        rcvMsg = S2SIMMessage(socket);
        rcvData = rcvMsg.Data;
        if isa(rcvData, 'S2SIMMsgSysTimeRes')
            success = true;
            break;
        end
        nWaits = nWaits + 1;
    end
    if ~success
        error('We have been waiting for a while but did not receive the system time message.');
    end
    fprintf('S2Sim Current Time is: %d, which is %s\n',...
        double(rcvData.CurrentTime), datestr(epoch2matlab(rcvData.CurrentTime)));
catch err
    fclose(socket);
    delete(socket);
    rethrow(err);
end
fclose(socket);
delete(socket);
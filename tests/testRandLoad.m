% Test S2Sim by sending random load

server = 'seelabc.ucsd.edu';
port = 26999;
name = 'canyonview_apt';


%% Connect to S2Sim

[status, socket, id, ~, info ] = connectToS2Sim( server, port, name );
if status ~= 0
    disp('Error while connecting to S2Sim:');
    if status < 0
        fprintf('Connection error: %s.\n', socket.message);
    else
        fprintf('S2Sim error: %s.\n', id);
    end
    return;
end
fprintf('Successfully connected to S2Sim with ID: %d.\n', id);
fprintf('Current server time: %d, time step: %d, number of clients: %d, server mode: %d.\n',...
    info.CurrentTime, info.TimeStep, info.NumberClients, info.SystemMode);

% assert(isa(socket, 'tcpip'), 'socket is not a tcpip object.');


%% Receive price and set demand (randomly)
N = 60;  % number of steps
instants = zeros(N, 1);
prices = ones(N, 1);

for ii = 1:N
    % Wait until we receive a SetPrice message
    success = false;
    nWaits = 0;
    while nWaits < 50  % try at most x times
        rcvMsg = S2SIMMessage(socket);
        rcvData = rcvMsg.Data;
        if isa(rcvData, 'S2SIMMsgSetPrice')
            success = true;
            break;
        end
        nWaits = nWaits + 1;
    end
    if ~success
        error('We have been waiting for a while but did not receive the SetPrice message.');
    end
    
    instants(ii) = double(rcvData.TimeBegin);
    prices(ii) = double(rcvData.Prices(1));
    
    seq = rcvMsg.SeqNumber;
    
    % Respond with my demand
    demand = 20000 + rand()*10000;
    seq = sendDemandToS2Sim( socket, id, seq, demand );
end


%% Disconnect
disconnectFromS2Sim(socket);
clear socket
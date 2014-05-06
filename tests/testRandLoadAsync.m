% Test S2Sim by sending random load. Asynchronous reading.

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
    % Check if we receive a SetPrice message
    [success, rcvMsg, seq] = getMsgFromS2Sim(socket, 'SetPrice', [], [], true);
    if success < 0
        error('We have been waiting for a while but did not receive the SetPrice message.');
    elseif success > 0
        if success ~= 2
            error('Error while receiving messages: %s.', rcvMsg);
        end
    end
    
    if success == 2
        % Async mode: no bytes available --> we do something else
        disp('No input data available: I am going to perform some heavy computation.');
        pause(1);
    else
        % success == 0
        rcvData = rcvMsg.Data;
        
        instants(ii) = double(rcvData.TimeBegin);
        prices(ii) = double(rcvData.Prices(1));
        
        % Respond with my demand
        demand = 20000 + rand()*10000;
        seq = sendDemandToS2Sim( socket, id, seq, demand );
    end
end


%% Disconnect
disconnectFromS2Sim(socket);
clear socket
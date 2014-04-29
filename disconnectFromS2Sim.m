function disconnectFromS2Sim( socket )
%DISCONNECTFROMS2SIM Disconnect from a TCPIP connection to S2Sim.
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

assert(isa(socket, 'tcpip'), 'Input argument must be a tcpip object connection to S2Sim.');

fclose(socket);
delete(socket);

end


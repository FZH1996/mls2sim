function seq = sendDemandToS2Sim( socket, id, seq, demand )
%SENDDEMANDTOS2SIM Send client's demand to S2Sim.
%   newseq = sendDemandToS2Sim( socket, id, seq, demand )
%sends the client's demand to S2Sim server (connected via socket).
%   id is the client's ID
%   seq is the current sequence number (e.g. from the previous message).
%
%   newseq is the new sequence number (e.g. to be used next time).
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

sendMsgToS2Sim( socket, id, seq, S2SIMMsgSyncClientData(demand) );

end


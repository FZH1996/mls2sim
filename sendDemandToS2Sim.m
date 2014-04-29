function seq = sendDemandToS2Sim( socket, id, seq, demand )
%SENDDEMANDTOS2SIM Send client's demand to S2Sim.
%   newseq = sendDemandToS2Sim( socket, id, seq, demand )
%sends the client's demand to S2Sim server (connected via socket).
%   id is the client's ID
%   seq is the current sequence number (e.g. from the previous message).
%
%   newseq is the new sequence number (e.g. to be used next time).ß
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

% Prepare message
demandData = S2SIMMsgSyncClientData(demand);
sendMsg = S2SIMMessage(demandData);
sendMsg.SenderID = id;
sendMsg.ReceiverID = sendMsg.S2SimAddress;
seq = seq + 1;
sendMsg.SeqNumber = seq;
sendData = sendMsg.FormatMessage();

fwrite(socket, sendData, 'uint8');

end


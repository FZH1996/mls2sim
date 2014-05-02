function seq = sendMsgToS2Sim( socket, id, seq, msgData )
%SENDMSGTOS2SIM Send a client's message to S2Sim.
%   newseq = sendMsgToS2Sim( socket, id, seq, msgData )
%sends a message containing the data msgData to S2Sim server.
%   id is the client's ID
%   seq is the current sequence number (e.g. from the previous message).
%   msgData is an object of a subclass of S2SIMMsgData, representing the
%       data to be sent.
%
%   newseq is the new sequence number (e.g. to be used next time).ß
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

assert(isa(msgData, 'S2SIMMsgData'), 'Message''s data must be an object of type S2SIMMsgData.');

% Prepare message
sendMsg = S2SIMMessage(msgData);
sendMsg.SenderID = id;
sendMsg.ReceiverID = sendMsg.S2SimAddress;
seq = seq + 1;
sendMsg.SeqNumber = seq;
sendData = sendMsg.FormatMessage();

fwrite(socket, sendData, 'uint8');

end


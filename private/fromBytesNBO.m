function out = fromBytesNBO( x, type )
%FROMBYTESNBO Convert data from bytes in Network Byte Order.
% A function that converts data from bytes in NBO to (a
% vector of) certain type, taking into account the machine's byte
% order.  For example, if x is a vector of 4 bytes of a double
% value in NBO, and the current machine uses Little Endian, then
% fromBytesNBO(x, 'double') will return a double value in Little
% Endian from those 4 bytes correctly.
%
% x must be of type uint8, otherwise the result will be unexpected.
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

persistent isLittleEndian;

if isempty(isLittleEndian)
    isLittleEndian = checkEndian;
end

if isLittleEndian
    % if little endian then we need to swap the byte order
    out = swapbytes(typecast(x, type));
else
    out = typecast(x, type);
end

end


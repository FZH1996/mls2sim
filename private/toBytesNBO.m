function out = toBytesNBO( x )
%TOBYTESNBO Convert data to bytes in Network Byte Order.
% A function that converts data to NBO then to a vector of
% bytes (uint8). For example, if x is a double in Little Endian,
% then toBytesNBO(x) will first swap the bytes to Big Endian, then
% return the bytes in the accurate order. The data may be a vector
% or a scalar value, but should not be anything else. It should
% already have the correct type, e.g. double if a double type is
% expected, uint32 if a 32-bit integer is expected, etc.
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

persistent isLittleEndian;

if isempty(isLittleEndian)
    isLittleEndian = checkEndian;
end

if isLittleEndian
    % if little endian then we swap the byte order
    out = typecast(swapbytes(x), 'uint8');
else
    out = typecast(x, 'uint8');
end

end


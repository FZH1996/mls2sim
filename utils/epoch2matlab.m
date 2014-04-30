function DN = epoch2matlab( EpochTime )
%EPOCH2MATLAB Convert Epoch/UNIX time to Matlab's datenum format.
%   DateNum = epoch2matlab( EpochTime )
%   returns the Matlab's DateNum time equivalent to the given Epoch/UNIX
%   time.
%
%   Epoch time = number of seconds from 00:00:00 UTC, January 1, 1970.
%   Matlab's DateNum time = (real) number of days from 1-Jan-0000.
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

time_reference = datenum('1970', 'yyyy');
DN = time_reference + double(EpochTime) / 86400;

end


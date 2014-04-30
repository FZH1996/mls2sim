function EpochTime = matlab2epoch( DN )
%MATLAB2EPOCH Convert Matlab's datenum format to Epoch/UNIX time.
%   EpochTime = matlab2epoch( DateNum )
%   returns the Epoch/UNIX time equivalent to the given Matlab's DateNum 
%   time.
%
%   Epoch time = number of seconds from 00:00:00 UTC, January 1, 1970.
%   Matlab's DateNum time = (real) number of days from 1-Jan-0000.
%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)

time_reference = datenum('1970', 'yyyy');
EpochTime = round(86400*(DN - time_reference));

end


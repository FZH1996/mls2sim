% Test the system time and version prompts (S2Sim ver 1.2+)

server = 'seelabc.ucsd.edu';
port = 26999;

%% Prompt for version and system time

[ status, major, minor ] = promptS2SimVersion( server, port );

if status ~= 0
    error('Cannot get the version from S2Sim server.');
end
fprintf('S2Sim Version: %d.%d\n', major, minor);
    
pause(2);
    
[ status, ServerTime ] = promptS2SimTime( server, port );

if status ~= 0
    error('Cannot get the time from S2Sim server.');
end

fprintf('S2Sim Current Time is: %d, which is %s\n',...
    ServerTime, datestr(epoch2matlab(ServerTime)));

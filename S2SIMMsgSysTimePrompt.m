classdef S2SIMMsgSysTimePrompt < S2SIMMsgEmpty
    %Class for S2SIM message's data: System Time Promp (type:1, id:6).
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
        
    methods
        function obj = S2SIMMsgSysTimePrompt()
            obj = obj@S2SIMMsgEmpty(1, 6);
        end
    end
    
end


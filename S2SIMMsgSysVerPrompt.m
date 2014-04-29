classdef S2SIMMsgSysVerPrompt < S2SIMMsgEmpty
    %Class for S2SIM message's data: System Version Promp (type:1, id:8).
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
        
    methods
        function obj = S2SIMMsgSysVerPrompt()
            obj = obj@S2SIMMsgEmpty(1, 8);
        end
    end
    
end


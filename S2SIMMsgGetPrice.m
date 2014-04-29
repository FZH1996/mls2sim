classdef S2SIMMsgGetPrice < S2SIMMsgEmpty
    %Class for S2SIM message's data: Get Price (type:3, id:1).
    %
    % (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
        
    methods
        function obj = S2SIMMsgGetPrice()
            obj = obj@S2SIMMsgEmpty(3, 1);
        end
    end
    
end


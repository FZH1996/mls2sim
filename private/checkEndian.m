function isLittle = checkEndian

%
% (C) 2014 by Truong X. Nghiem (nghiem@seas.upenn.edu)
[~,~,endian] = computer;
isLittle = isequal(endian, 'L');
end
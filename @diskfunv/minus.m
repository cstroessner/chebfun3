function f = minus( f, g )
% - MINUS. Minus of two DISKFUNV.  
%   F - G subtracts the DISKFUNV F from G componentwise.
%
%   minus(F, G) is called for the syntax f - g.

f = plus( f, uminus( g ) );

end

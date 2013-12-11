function g = csc(f, pref)
%CSC   Cosecant of a CHEBFUN.
%   CSC(F) computes the cosecant of the CHEBFUN F.
%
%   CSC(F, PREF) does the same but uses the CHEBPREF object PREF when
%   computing the composition.
%
% See also ACSC, CSCD.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org for Chebfun information.

% Obtain preferences:
if ( nargin == 1 )
    pref = chebpref();
end

% Call the compose method:
g = compose(f, @csc, pref);

end
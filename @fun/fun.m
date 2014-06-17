classdef fun % (Abstract) 
%FUN   Approximate functions on arbitrary domains.
%   Abstract (interface) class for approximating functions on the arbitrary 
%   intervals.
%
% Constructor inputs:
%   FUN.CONSTRUCTOR(OP, DATA, PREF) is essentially a wrapper for
%   CLASSICFUN.CONSTRUCTOR(OP, DATA, PREF).
%
% See also DELTAFUN, CLASSICFUN.

% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUN Class Description:
%  [TODO]
%
% Class diagram: [<<CHEBFUN>>] <>-- [<<FUN>>] <----[<<classicfun>>]
%                                             <----[    deltafun  ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright 2014 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% The Constructor:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods ( Access = public, Static = true )
        
        function obj = constructor(op, data, pref)
            
            % Parse inputs.
            if ( nargin < 1 )
                % We can't return an empty FUN, so pass an empty OP down.
                op = [];
            end

            if ( (nargin < 2) || isempty(data) )
                data = struct();
            end

            if ( (nargin < 3) || isempty(pref) )
                pref = chebfunpref();
            else
                pref = chebfunpref(pref);
            end

            % TODO:  Allow construction of DELTAFUNs as well?
            if ( isa(op, 'fun') )
                % OP is already a FUN!
                obj = op;
            else
                obj = classicfun.constructor(op, data, pref);
            end
            
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% ABSTRACT STATIC METHODS REQUIRED BY THIS CLASS.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Access = public, Abstract = true, Static = true )

        % Map from [-1, 1] to the domain of the FUN.
        m = createMap(domain);  
        
        % Make a FUN. (Constructor shortcut)
        f = make(varargin);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% PRIVATE STATIC METHODS REQUIRED BY THIS CLASS.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Static = true )
        % Edge detector.
        [edge, vscale] = detectEdge(op, domain, hscale, vscale, pref);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% ABSTRACT NON-STATIC METHODS REQUIRED BY THIS CLASS.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Abstract = true, Static = false )
        
    end
    
end
function f = diff( f, varargin )
% DIFF    Derivative of a diskfun in Cartesian coordinates.
%
%  F = DIFF( F ) computes the first derivative of F with respect to x.
%
%  F = DIFF( F, DIM )  computes the first derivative of F. If DIM = 1, the
%  derivative is taken in the x-direction. If DIM = 2, the derivative
%  is taken in the y-direction.
%
%  F = DIFF( F, DIM, K) computes the kth derivatives of F in the variable
%  given by DIM.
%
%  See also GRADIENT, LAPLACIAN

% Parse user inputs:
if ( nargin == 1 )
    dim = 1;
    K = 1;
elseif ( nargin == 2 )
    dim = varargin{1};
    K = 1;
else
    dim = varargin{1};
    K = varargin{2};
end



if ( dim ~= 1 && dim ~= 2  )
    error('DISKFUN:DIFF:DIM', 'Unrecognized coordinate dimension');
end

if ( abs( K - round(K) ) > eps )
    error('DISKFUN:DIFF:DIFFORDER', 'Fractional derivatives not allowed')
end
K = round( K );


% Implement higher derivatives as repeated (iterated) differentiation
for j=1:K
    f = onediff(f, dim);
end

end
% TODO: This code will not work for complex valued spherefuns, if we ever
% allow them.
% realf = isreal(f);

function f = onediff(f, dim)

f=simplify(f); 

% We are going to work at the tech level to make things faster.
[C, D, R] = cdr( f );

% Do everything with even length columns since then no special
% modifications are required for dividing the cosine/sine series expansion.
n = length(C)+mod(length(C),2);
m = length(R);

% The variable coefficients in the definitions of the derivatives means
% that the length of the columns and rows will increase by one wave number
% after taking the derivatives with respect to x and y. 
m = m+2;
n=n+2;

% Matrices for multiplying by sin/cos and 1/r in coefficient space.

Msinm = .5i*spdiags(ones(m,1)*[-1,1],[-1 1],m,m);

Mcosm = .5*spdiags(ones(m,1)*[1,1],[-1 1],m,m);
Mn = ultraS.multmat(n, [0;1], 0); %used for the 1/r multiply


% Work at the tech level to make things faster.
ctechs = C;
rtechs = R.funs{1}.onefun;

% alias to get the extra zeros in place
ctechs = chebfun(chebtech2.alias(C.coeffs, n), 'coeffs'); 
rtechs.coeffs = rtechs.alias(rtechs.coeffs, m); 

% Compute the derivatives
dCdr = diff(ctechs);
dRdth = diff(rtechs)/pi;

% get 1/r term
C_cfs = chebtech2.alias(ctechs.coeffs, n);

rinv = Mn \ C_cfs; 

if (dim==1) %d/dx 

    %CDR for -1/r.*sinth.*d/dth
    C1 = rinv; 
    R1 = -Msinm*dRdth.coeffs;
    
    %CDR for costh.*d/dr
    
    C2 = dCdr.coeffs;
    R2 = Mcosm*rtechs.coeffs;
    
else  %d/dy
    
    %CDR for 1/r.*costh.*d/dth
    C1 = rinv; 
    R1 = Mcosm*dRdth.coeffs;
    
    %CDR for sinth.*d/dr
    
    C2 = dCdr.coeffs;
    R2 = Msinm*rtechs.coeffs;
end

    % Put pieces back together
    f1 = f; 
    %c1cols = real(C1);
    %f1.cols= c1cols;
    f1.cols = chebfun(C1, 'coeffs'); 
    r1techs = real(trigtech({'',R1}));
    f1.rows.funs{1}.onefun = r1techs;
    
    % Parity changes
    temp = f1.idxPlus;
    f1.idxPlus = f1.idxMinus;
    f1.idxMinus = temp;

    f2 = f; 
    f2.cols = chebfun(C2, 'coeffs'); 
    r2techs = real(trigtech({'',R2}));
    f2.rows.funs{1}.onefun = r2techs;

    % Parity changes
    temp = f2.idxPlus;
    f2.idxPlus = f2.idxMinus;
    f2.idxMinus = temp;

    % Compression plus may not preserve the expansion properties we want.
    % So we sample each piece add them together and construct a spherefun.
    % TODO: Fix this so everything is done in coefficient space, like this
    % f = f1 + f2;        
    m = m + mod(m, 2); 
    
    f = diskfun(sample(f1,m,n)+sample(f2,m,n));    
end


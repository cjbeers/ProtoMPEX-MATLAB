function [ y,dy ] = sgolay_t(x,N,F,W,DIM)
%smoothes and calculates the first differential / derivative of function
%using a savitsky golay method. The differentiation is done by the last
%terms of the convolution, this can be optimized: see matricial product
%with the filtering matrix instead as in sgolayfilt
%If the data comes as a matrix, DIM is the direction where you filter and
%differentiate 1 lines and 2 collumns

% % Here is a random example for a cubic function with noise. if you run this
% % piece of code you will generate a noisy function x with a perfect derivative
% % dx. the first plot will show the noisy function and its filtered result (y);
% % the second plot shows the noisy dervivative (diff(x)) in green the perfect
% derivative (dx) and the filtered derivative (dy)
% xx=1:100;
% x=-0.005*(xx-35).^4-0.3*xx.^3+10*xx.^2+35+3000*randn(1,size(xx,2));
% dx=-0.005*4*(xx-35).^3-3*0.3*xx.^2+2*10*xx;
% [ y,dy ] = sgolay_t(x,5,71);
% figure;plot(x);hold on;plot(y,'color','red')
% figure;plot(dx);hold on;plot(dy,'color','red');plot(diff(x),'color','green')
% 
% error(nargchk(3,5,nargin,'struct'));

% Modification added by JF Caneses on 2017_07_30
narginchk(3,5);

% Check if the input arguments are valid
if round(F) ~= F, error(message('signal:sgolay_t:MustBeIntegerFrameLength')), end
if rem(F,2) ~= 1, error(message('signal:sgolay_t:SignalErr')), end
if round(N) ~= N, error(message('signal:sgolay_t:MustBeIntegerPolyDegree')), end
if N > F-1, error(message('signal:sgolay_t:InvalidRangeDegree')), end

if nargin < 5, DIM = []; end

% Check the input data type. Single precision is not supported.
% % % try
% % %     chkinputdatatype(x,k,F,W,DIM);
% % % catch ME
% % %     throwAsCaller(ME);
% % % end

%Calculo das matrizes de filtro e de diferenciadores: 
%A matriz filtro é igual a matriz da funçao sgolay
M=(F-1)/2;
e=eye(F);
aux=repmat((-M:M),F,1);
p=zeros(F,N+1);
dp=zeros(F,N);
h=zeros(F,F);
dh=h;
for i=1:F
p(i,:)=polyfit(aux(i,:),e(i,:),N);
h(i,:)=polyval(p(i,:),-M:M);
dp(i,:)=polyder(p(i,:));
dh(i,:)=polyval(dp(i,:),-M:M);
end



% Reshape X into the right dimension.
if isempty(DIM)
	% Work along the first non-singleton dimension
	[x, nshifts] = shiftdim(x);
else
	% Put DIM in the first dimension (this matches the order 
	% that the built-in filter function uses)
	perm = [DIM,1:DIM-1,DIM+1:ndims(x)];
	x = permute(x,perm);
end

% if size(x,1) < F, error(message('signal:sgolayfilt:InvalidDimensionsTooSmall')), end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Edit by JF Caneses 2017_07_30
if size(x,1) < F, error('signal sgolayfilt InvalidDimensionsTooSmall'), end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
%Filter function
% Preallocate output
y = zeros(size(x));

%compute steady-state
ytemp= filter(h((F-1)./2+1,:),1,x);
y((F+1)/2:end-(F+1)/2+1,:) = ytemp(F:end,:);
%compute transient off
y(end-(F+1)/2+2:end,:) = flipud(h(1:(F-1)/2,:))*flipud(x(end-(F-1):end,:));
%compute transient on
y(1:(F+1)/2-1,:) = flipud(h((F-1)/2+2:end,:))*flipud(x(1:F,:));

%%
%Calculate derivative;
%Please note that if the step in your sample (dx) is different that 1, you
%should divide this by dx
dy = zeros(size(x));
dh=dh.';
%compute steady-state
dytemp= filter(-dh((F-1)./2+1,:),1,x);
dy((F+1)/2:end-(F+1)/2+1,:) = dytemp(F:end,:);
% compute transient off
dy(end-(F+1)/2+2:end,:) = flipud(-dh(1:(F-1)/2,:))*flipud(x(end-(F-1):end,:));
% %compute transient on
dy(1:(F+1)/2-1,:) = flipud(-dh((F-1)/2+2:end,:))*flipud(x(1:F,:));
%%
% Convert Y to the original shape of X
if isempty(DIM)
	y = shiftdim(y, -nshifts);
    dy = shiftdim(dy, -nshifts);
else
	y = ipermute(y,perm);
    dy = ipermute(dy,perm);
end


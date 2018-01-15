function out = rhs
out{1} = @init;
out{2} = @fun_eval;
out{3} = []; % @jacobian;
out{4} = []; % @jacobianp;
out{5} = []; % @hessians;
out{6} = []; % @hessiansp;
out{7} = []; % @der3;
out{8} = [];
out{9} = [];
% --------------------------------------------------------------------------
function res = fun_eval(t,kmrgd,mdot_,varargin)

global gas options;

% UNPACK ARGUMENTS
n_sp = varargin{1};
stoich_prefactor = varargin{2};
mass = varargin{3};
fuel_mw = varargin{4};
air_mw = varargin{5};
enthalpy_fuel = varargin{6};
enthalpy_air = varargin{7};
Y_fuel = cell2mat(varargin(8:n_sp+7));
Y_ox = cell2mat(varargin(n_sp+8:2*n_sp+7));

% Last element is internal energy
Y_trunc = kmrgd(1:end-1);
T = kmrgd(end);

% N-1 species equations and 1 enthalpy equation
res = zeros(n_sp,1);
Y = [Y_trunc;1-sum(Y_trunc)];
set(gas,'T',T,'Rho',mass/options.volume,'Y',Y);

h = enthalpy_mass(gas);
cv = cv_mass(gas);
prod_rates = netProdRates(gas);
mw = molecularWeights(gas);

factor = mdot_/(options.phi * fuel_mw);
mdot_o_ = factor * (1.0 + 3.76) * stoich_prefactor * air_mw;
mdot_out_ = mdot_ + mdot_o_;

for i = 1:n_sp-1
    res(i) = prod_rates(i)*options.volume*mw(i);
    
    % fuel inlet
    res(i) = res(i) + (mdot_)*(Y_fuel(i) - Y(i));
    
    % oxidizer inlet
    res(i) = res(i) + (mdot_o_)*(Y_ox(i) - Y(i));
end
    
res(n_sp) = -mdot_out_*h + ...
             mdot_*enthalpy_fuel + ...
             mdot_o_*enthalpy_air;
    
% prefactors
res(1:end-1) = res(1:end-1)*(1.0/mass);
res(end) = res(end)*(1.0/(mass*cv));

% --------------------------------------------------------------------------
function [tspan,y0,options] = init
handles = feval(rhs);
y0 = [0];
tspan = [0 10];
% --------------------------------------------------------------------------

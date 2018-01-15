function [args,seed] = initialize_reactor

global gas options go_backwards;

gas = Solution(strcat('../',options.cti_file),options.mixture_name);
n_sp = nSpecies(gas);

% INDEX FOR ARGS
% n_sp - 1
% stoich_prefactor - 2
% mass - 3
% fuel_mw - 4
% air_mw - 5
% enthalpy_fuel - 6
% enthalpy_air - 7
% Y_fuel - 8:n_sp+7
% Y_ox - n_sp+8:2*n_sp+7

args = zeros(1,2*n_sp+7);
args(1) = n_sp;

% compute fuel and air mass flow rates
% every stoichiometric hydrocarbon mixture reaction is of the form
% CmHn + (m + 0.25*n)(O2 + 3.76 N2) -> products
% here, (m + 0.25*n) is called the stoich_prefactor
stoich_prefactor = 0.0;
for idx = 1:length(options.palette)
    species = options.palette(idx);
    species = species{1};
    stoich_prefactor = stoich_prefactor + ...
        options.comp(idx)* ...
        (nAtoms(gas,species,'C') + ...
        0.25 * nAtoms(gas,species,'H'));
    args(2) = stoich_prefactor;
    
    % create a reservoir for the fuel inlet
    comp_string = set_gas_using_palette(options);
    set(gas,'T',options.temp,'P',oneatm);
    setMoleFractions(gas,comp_string);
    fuel_mw = meanMolecularWeight(gas);
    args(4) = fuel_mw;
    args(6) = enthalpy_mass(gas);
    args(8:n_sp+7) = massFractions(gas);
    
    % use predefined function Air() for the air inlet
    set(gas,'T',options.temp,'P',oneatm);
    setMoleFractions(gas,'O2:1,N2:3.76');
    air_mw = meanMolecularWeight(gas);
    args(5) = air_mw;
    args(7) = enthalpy_mass(gas);
    args(n_sp+8:2*n_sp+7) = massFractions(gas);
    
    % create the combustor, and fill it in initially with equilibrium composition
    o_frac = stoich_prefactor/options.phi;
    n_frac = 3.76*o_frac;
    ox_string = strcat(',O2:',num2str(o_frac),',N2:',num2str(n_frac));
    set(gas,'T',options.temp,'P',oneatm);
    fin_string = strcat(comp_string,ox_string);
    setMoleFractions(gas,fin_string);
    combustor = IdealGasReactor(gas);
    gasMass = mass(combustor);
    args(3) = gasMass;
    if (~go_backwards)
         equilibrate(gas,'HP');
    end
    set(gas,'T',temperature(gas),'Rho',gasMass/options.volume,'Y',massFractions(gas));
    Y = massFractions(gas);
    seed = [Y(1:end-1);temperature(gas)];
end

end

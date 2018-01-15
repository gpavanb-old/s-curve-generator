function [comp_string] = set_gas_using_palette(options)
x = options.comp;
comp_string = '';

for idx = 1:length(options.palette)
    compound = options.palette(idx);
    comp_string = strcat(comp_string,compound,':',num2str(x(idx)));
    if idx ~= length(x)
        comp_string = strcat(comp_string,',');
    end
end

comp_string = char(comp_string);

end


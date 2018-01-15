classdef Options
    properties
        phi
        pres
        temp
        volume
        
        cti_file
        mixture_name
        
        palette
        comp
    end
    methods
        function obj = Options(file)
            yamlObj = YAML.read(file);
            
            % ASSIGN TO OPTIONS
            obj.phi = yamlObj.equivalence_ratio;
            obj.pres = yamlObj.pressure;
            obj.temp = yamlObj.temperature;
            obj.volume = yamlObj.volume;
            obj.cti_file = yamlObj.cti_file;
            obj.mixture_name = yamlObj.mixture_name;
            
            obj.palette = yamlObj.palette;
            obj.comp = yamlObj.composition;            
        end
    end
end
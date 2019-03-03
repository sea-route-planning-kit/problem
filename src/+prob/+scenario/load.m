function scenario = load(fileName)
    scenario = simulator.scenario.parse(jsondecode(fileread(fileName)));
end
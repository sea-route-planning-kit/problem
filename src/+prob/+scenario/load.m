function scenario = load(fileName)
    scenario = prob.scenario.parse(jsondecode(fileread(fileName)));
end
function problem = load(shipFileName, scenarioFileName)
    problem.ship = prob.ship.load(shipFileName);
    problem.scenario = prob.scenario.load(scenarioFileName);
end
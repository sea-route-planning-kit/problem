function ship = load(fileName)
    ship = simulator.ship.parse(jsondecode(fileread(fileName)));
end
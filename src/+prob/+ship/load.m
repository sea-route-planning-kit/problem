function ship = load(fileName)
    ship = prob.ship.parse(jsondecode(fileread(fileName)));
end
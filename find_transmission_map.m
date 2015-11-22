function [tranmission_map] = find_transmission_map(TI, TA_airlight)
    w = 0.95;
    tranmission_map = 1 - w * find_darkchannel(TI ./TA_airlight);


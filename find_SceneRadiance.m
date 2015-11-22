function final_img = find_SceneRadiance(TI, TA_matrix, transmission_map)
    dims = size(TI);
    final_img = TI;
    t0 = 0.1;
    for m = 1 : dims(1)
        for n = 1 : dims(2)
            for k = 1 : 3
                final_img(m,n, k) = (((TI(m,n, k) - TA_matrix(m, n, k))) / max(transmission_map(m,n), t0)) + TA_matrix(m, n, k);
            end         
        end
    end

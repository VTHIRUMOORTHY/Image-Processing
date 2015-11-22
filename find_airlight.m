function [brightest_pixel] = find_airlight(DC, I)
    [ r c v] = find(DC);
    sorted_v = sort(v, 'descend');
    [x y ~] = size(DC);
    no_of_pixels = x * y;
    top = ceil(.001 * no_of_pixels);
    mymin_in_vec = sorted_v(top);
    [nr nc nv] = find(DC >= mymin_in_vec);
        no_of_elem = size(nr);
    brightest_pixel_r = I(nr(1), nc(1), 1);
    brightest_pixel_g =  I(nr(1), nc(1), 2);
    brightest_pixel_b =  I(nr(1), nc(1), 3);
    for m = 1 : no_of_elem
        if (brightest_pixel_r < I(nr(m), nc(m),1))
            brightest_pixel_r = I(nr(m), nc(m),1);
        end
        if (brightest_pixel_g < I(nr(m), nc(m),2))
            brightest_pixel_g = I(nr(m), nc(m),2);
        end
        if (brightest_pixel_b < I(nr(m), nc(m),3))
            brightest_pixel_b = I(nr(m), nc(m),3);
        end
    end
    brightest_pixel = [brightest_pixel_r  brightest_pixel_g  brightest_pixel_b];
    disp(brightest_pixel);

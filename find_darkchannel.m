function[dc] = find_darkchannel(I)
 [x y ~] = size(I);
    patch_size = 15;
     I = padarray(I, [floor(patch_size/2) floor(patch_size/2)], 'symmetric');
         for m = 1:x
         for n = 1:y
             patch_r = I(m:(m+patch_size-1), n:(n+patch_size-1),1);
             patch_g = I(m:(m+patch_size-1), n:(n+patch_size-1),2);
             patch_b = I(m:(m+patch_size-1), n:(n+patch_size-1),3);
             J(m,n,1) = min(patch_r(:));
             J(m,n,2) = min(patch_g(:));
             J(m,n,3) = min(patch_b(:));
             dc(m,n) = min(J(m,n, :));
         end
     end

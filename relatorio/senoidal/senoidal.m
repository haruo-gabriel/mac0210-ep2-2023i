function senoidal(p)
  I = zeros(p, p, 3);
  for i = 1:p
    for j = 1:p
      rad_i = deg2rad(i);
      rad_j = deg2rad(j);
      I(i, j, 1) = (sin(rad_i) + 1) * 255 / 2;
      I(i, j, 2) = (((sin(rad_i) + sin(rad_j))/2) + 1) * 255 / 2;
      I(i, j, 3) = (sin(rad_i) + 1) * 255 / 2;
    endfor
  endfor
  imshow(uint8(I));
  imwrite(uint8(I), 'senoidal.png', 'Quality', 100);
endfunction

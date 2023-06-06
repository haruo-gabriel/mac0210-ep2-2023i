function polinomial(p)
  I = zeros(p, p, 3);
  for i = 1:p
    for j = 1:p
      I(i, j, 1) = 255 * (150-i)/(j-i);
      I(i, j, 2) = 255 * ((150-i)/(j-i))^2;
      I(i, j, 3) = 255 * ((150-i)/(j-i))^3;
    endfor
  endfor
  imshow(uint8(I));
  imwrite(uint8(I), 'polinomial.png', 'png', 'Quality', 100);
endfunction
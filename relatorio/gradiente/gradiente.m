function cor(p)
  I = zeros(p, p, 3);
  for i = 1:p
    for j = 1:p
      I(i, j, 1) = 255 * i / p;
      I(i, j, 2) = 255 * j / p;
      I(i, j, 3) = 1;
    endfor
  endfor
  imshow(uint8(I));
  imwrite(uint8(I), 'cor.png', 'Quality', 100);
endfunction
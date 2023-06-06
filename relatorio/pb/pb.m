function pb(p)
  I = zeros(p, p, 3);
  for i = 1:p
    for j = 1:p
      if mod(i, 7) == 0 || mod(j, 23) == 0
        I(i, j, 1) = 255;
        I(i, j, 2) = 255;
        I(i, j, 3) = 255;
      else
        I(i, j, 1) = 0;
        I(i, j, 2) = 0;
        I(i, j, 3) = 0;
      endif
    endfor
  endfor
  imshow(uint8(I));
  imwrite(uint8(I), 'pb.png', 'Quality', 100);
endfunction

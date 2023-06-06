function notc1(p)
  I = zeros(p, p, 3);
  for i = 1:p
    for j = 1:p
      if i == 0 || j == 0
        I(i, j, :) = [0, 0, 0];
      else
        %I(i, j, :) = [(i^2 * sin(1/i)/p), (j^2 * sin(1/i))/p, ((i+j)^2 * sin(1/i))/p];
        %I(i, j, :) = [(i^2 * sin(1/i)), (j^2 * sin(1/i)), (j^2 * sin(1/j))];
        I(i, j, :) = [255*(i^2 * sin(1/i))/p, 255*(j^2 * sin(1/i))/p, 255*(i+j)/p];
        %I(i, j, :) = [(i^2 * sin(1/i)), (j^2 * sin(1/j)), ((i+j)^2 * sin(1/(i+j)))];
        %I(i, j, :) = [(i^2 * sin(1/i)), (j^2 * sin(1/j)), (j^2 * sin(1/i))];
      endif
    endfor
  endfor
  imshow(uint8(I));
  imwrite(uint8(I), 'notc1.png', 'png', 'Quality', 100);
endfunction
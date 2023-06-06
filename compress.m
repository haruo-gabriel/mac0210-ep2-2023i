function compress(originalImg, k)
  I_original = imread(originalImg);
  [p, ~, ~] = size(I_original);
  % n = floor((p-k)/(k+1));
  mask = mod(1:p, k+1) == 0;
  I_compressed = I_original(mask, mask, : );
  imwrite(uint8(I_compressed), 'compressed.png', 'Quality', 100);
end
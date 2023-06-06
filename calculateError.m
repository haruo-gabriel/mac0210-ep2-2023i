function calculateError(originalImg, decompressedImg)
  I_original = imread(originalImg);
  [p, ~, ~] = size(I_original);
  I_original = im2double(I_original);
  I_decompressed = imread(decompressedImg);
  [p2, ~, ~] = size(I_decompressed);
  I_decompressed = im2double(I_decompressed);
  if (p != p2)
    error("Imagens de tamanhos diferentes");
  else
    % erro por canal
    errR = 0.0;
    errG = 0.0;
    errB = 0.0;
    for i = 1:p
      for j = 1:p
        errR += (I_original(i, j, 1) - I_decompressed(i, j, 1))^2;
        errG += (I_original(i, j, 2) - I_decompressed(i, j, 2))^2;
        errB += (I_original(i, j, 3) - I_decompressed(i, j, 3))^2;
      endfor
    endfor
    errR /= p^2;
    errR = sqrt(errR);
    errG /= p^2;
    errG = sqrt(errG);
    errB /= p^2;
    errB = sqrt(errB);
    
    %ta dando diferente
    %errR = norm(I_original(:, :, 1) - I_decompressed(:, :, 1), 'fro') / norm(I_original(:, :, 1), 'fro');
    %errG = norm(I_original(:, :, 2) - I_decompressed(:, :, 2), 'fro') / norm(I_original(:, :, 2), 'fro');
    %errB = norm(I_original(:, :, 3) - I_decompressed(:, :, 3), 'fro') / norm(I_original(:, :, 3), 'fro');

    % erro TOTAL
    err = (errR + errG + errB) / 3;
    disp(err);

  endif
endfunction

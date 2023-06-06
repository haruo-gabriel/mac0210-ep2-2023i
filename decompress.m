function decompress(compressedImg, method, k, h)
  I_compressed = imread(compressedImg);
  [n, ~, ~] = size(I_compressed);
  p = n + (n-1)*k;
  I_decompressed = zeros(p, p, 3);

  switch method
    case 1 % bilinear
      H = [1 0 0 0 ;
           1 0 h 0 ;
           1 h 0 0 ;
           1 h h (h*h)
          ];
      F = zeros(4, 3);
      si = 0;
      sj = 0;
      for i = 1:n
        if i == n
          si = 1;
        else
          si = 0;
        endif

        for j = 1:n
          if j == n
            sj = 1;
          else
            sj = 0;
          endif
          F(1, : ) = I_compressed(i, j, : );
          F(2, : ) = I_compressed(i, j+1-sj, : );
          F(3, : ) = I_compressed(i+1-si, j, : );
          F(4, : ) = I_compressed(i+1-si, j+1-sj, : );

          A = H\F; % vetor coluna com os coeficientes

          ii = (i-1)*(k+1) + 1;
          jj = (j-1)*(k+1) + 1;
          % percorre o quadrado de tamanho k+1
          for x = 0:k
            for y = 0:k
              P = [1 ; x*h/(k+1) ; y*h/(k+1) ; x*y*h*h/((k+1)*(k+1))];
              I_decompressed(x+ii, y+jj, : ) = A'*P;
            endfor
          endfor

        endfor 
      endfor

      %imwrite(uint8(I_decompressed), 'decompressed-bilinear.png', 'Quality', 100);
      imwrite(uint8(I_decompressed), 'decompressed.png', 'Quality', 100);

    case 2 % bicúbica
      B = [1 0 0 0 ;
           1 h (h*h) (h*h*h) ;
           0 1 0 0 ;
           0 h (2*h) (3*h*h)
          ];
      Binv = inv(B);
      BTinv = inv(B');
      F = zeros(4, 4, 3);
      si = 0;
      sj = 0;
      for i = 1:n
        if i == n
          si = 1;
        else
          si = 0;
        endif

        for j = 1:n
          if j == n
            sj = 1;
          else
            sj = 0;
          endif
          % matriz F de derivadas parciais 
          F(1, 1, : ) = I_compressed(i, j, : );
          F(1, 2, : ) = I_compressed(i, j+1-sj, : );
          F(1, 3, : ) = dfdy(i, j, I_compressed, n, h);
          F(1, 4, : ) = dfdy(i, j+1-sj, I_compressed, n, h);

          F(2, 1, : ) = I_compressed(i+1-si, j, : );
          F(2, 2, : ) = I_compressed(i+1-si, j+1-sj, : );
          F(2, 3, : ) = dfdy(i+1-si, j, I_compressed, n, h);
          F(2, 4, : ) = dfdy(i+1-si, j+1-sj, I_compressed, n, h);

          F(3, 1, : ) = dfdx(i, j, I_compressed, n, h);
          F(3, 2, : ) = dfdx(i, j+1-sj, I_compressed, n, h);
          F(3, 3, : ) = dfdxdy(i, j, I_compressed, n, h);
          F(3, 4, : ) = dfdxdy(i, j+1-sj, I_compressed, n, h);

          F(4, 1, : ) = dfdx(i+1-si, j, I_compressed, n, h);
          F(4, 2, : ) = dfdx(i+1-si, j+1-sj, I_compressed, n, h);
          F(4, 3, : ) = dfdxdy(i+1-si, j, I_compressed, n, h);
          F(4, 4, : ) = dfdxdy(i+1-si, j+1-sj, I_compressed, n, h);

          % transformação para matriz 4x4x3 dos coeficientes
          F( : , : , 1) = Binv*F( : , : , 1)*BTinv;
          F( : , : , 2) = Binv*F( : , : , 2)*BTinv;
          F( : , : , 3) = Binv*F( : , : , 3)*BTinv;

          ii = (i-1)*(k+1) + 1;
          jj = (j-1)*(k+1) + 1;
          for x = 0:k
            for y = 0:k
              X = [1 , x*h/(k+1) , (x*h/(k+1))^2 , (x*h/(k+1))^3]; % vetor linha
              Y = [1 ; y*h/(k+1) ; (y*h/(k+1))^2 ; (y*h/(k+1))^3]; % vetor coluna
              I_decompressed(x+ii, y+jj, 1) = X*F( : , : , 1)*Y;
              I_decompressed(x+ii, y+jj, 2) = X*F( : , : , 2)*Y;
              I_decompressed(x+ii, y+jj, 3) = X*F( : , : , 3)*Y;
            endfor
          endfor

        endfor 
      endfor

      %imwrite(uint8(I_decompressed), 'decompressed-bicubica.png', 'Quality', 100);
      imwrite(uint8(I_decompressed), 'decompressed.png', 'Quality', 100);

    otherwise
      error('Método inválido. Use 1 para bilinear ou 2 para bicúbica.');
  end

endfunction

function output = dfdx(i, j, matriz, n, h)
  if i > 1 && i < n % caso não-borda
    output = (matriz(i+1, j, : ) - matriz(i-1, j, : )) / (2*h); 
  % casos borda
  elseif i == 1
    output = (matriz(2, j, : ) - matriz(1, j, : )) / h;
  else
    output = (matriz(n, j, : ) - matriz(n-1, j, : )) / h;
  endif
endfunction

function output = dfdy(i, j, matriz, n, h)
  if j > 1 && j < n % caso não-borda
    output = (matriz(i, j+1, : ) - matriz(i, j-1, : )) / (2*h);
  % casos borda
  elseif j == 1 
    output = (matriz(i, 2, : ) - matriz(i, 1, : )) / h;
  else
    output = (matriz(i, n, : ) - matriz(i, n-1, : )) / h;
  endif
endfunction

function output = dfdxdy(i, j, matriz, n, h)
  if i == 1
    output = (dfdy(2, j, matriz, n, h) - dfdy(1, j, matriz, n, h)) / (2*h);
  elseif i == n
    output = (dfdy(n, j, matriz, n, h) - dfdy(n-1, j, matriz, n, h)) / (2*h);
  else
    output = (dfdy(i+1, j, matriz, n, h) - dfdy(i-1, j, matriz, n, h)) / (2*h);
  endif
endfunction

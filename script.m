function script(path,h)
  compress(path,3);
  decompress('compressed.png',1,3,h);
  decompress('compressed.png',2,3,h);
  calculateError(path,'decompressed-bilinear.png');
  calculateError(path,'decompressed-bicubica.png');
endfunction
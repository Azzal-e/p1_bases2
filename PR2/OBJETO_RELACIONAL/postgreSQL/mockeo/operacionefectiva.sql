INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (
  26,
  ROW('ES12','39593283634492562374')::IBAN,
  GREATEST(TO_TIMESTAMP('2024-05-11','YYYY-MM-DD'), (SELECT fechaDeCreacion FROM Cuenta WHERE iban = ROW('ES12','39593283634492562374')::IBAN LIMIT 1) + INTERVAL '1 second'),
  795375614.29,
  'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas',
  'INGRESO',
  4660
);
INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (
  34,
  ROW('ES12','96714089811638967258')::IBAN,
  GREATEST(TO_TIMESTAMP('2024-12-01','YYYY-MM-DD'), (SELECT fechaDeCreacion FROM Cuenta WHERE iban = ROW('ES12','96714089811638967258')::IBAN LIMIT 1) + INTERVAL '1 second'),
  829761618.32,
  'Cras non velit nec nisi vulputate nonummy.',
  'INGRESO',
  4125
);
INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (
  39,
  ROW('ES12','78579706658008173005')::IBAN,
  GREATEST(TO_TIMESTAMP('2024-11-21','YYYY-MM-DD'), (SELECT fechaDeCreacion FROM Cuenta WHERE iban = ROW('ES12','78579706658008173005')::IBAN LIMIT 1) + INTERVAL '1 second'),
  393964629.32,
  'Phasellus in felis. Donec semper sapien a libero.',
  'RETIRADA',
  3332
);
INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (
  43,
  ROW('ES56','66821468873531280560')::IBAN,
  GREATEST(TO_TIMESTAMP('2025-02-07','YYYY-MM-DD'), (SELECT fechaDeCreacion FROM Cuenta WHERE iban = ROW('ES56','66821468873531280560')::IBAN LIMIT 1) + INTERVAL '1 second'),
  77646300.5,
  'Aliquam sit amet diam in magna bibendum imperdiet.',
  'INGRESO',
  7804
);
INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (
  60,
  ROW('ES56','39737108933891563722')::IBAN,
  GREATEST(TO_TIMESTAMP('2024-09-14','YYYY-MM-DD'), (SELECT fechaDeCreacion FROM Cuenta WHERE iban = ROW('ES56','39737108933891563722')::IBAN LIMIT 1) + INTERVAL '1 second'),
  87276994.05,
  'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.',
  'RETIRADA',
  1407
);
INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (
  67,
  ROW('ES34','29897138019421781393')::IBAN,
  GREATEST(TO_TIMESTAMP('2025-02-19','YYYY-MM-DD'), (SELECT fechaDeCreacion FROM Cuenta WHERE iban = ROW('ES34','29897138019421781393')::IBAN LIMIT 1) + INTERVAL '1 second'),
  23150446.02,
  'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.',
  'INGRESO',
  7089
);
INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (
  68,
  ROW('ES12','39593283634492562374')::IBAN,
  GREATEST(TO_TIMESTAMP('2024-04-16','YYYY-MM-DD'), (SELECT fechaDeCreacion FROM Cuenta WHERE iban = ROW('ES12','39593283634492562374')::IBAN LIMIT 1) + INTERVAL '1 second'),
  829765261.68,
  'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.',
  'INGRESO',
  843
);
INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (
  74,
  ROW('ES56','54856322742811821733')::IBAN,
  GREATEST(TO_TIMESTAMP('2024-07-08','YYYY-MM-DD'), (SELECT fechaDeCreacion FROM Cuenta WHERE iban = ROW('ES56','54856322742811821733')::IBAN LIMIT 1) + INTERVAL '1 second'),
  744003120.42,
  'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.',
  'INGRESO',
  6937
);
INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (
  79,
  ROW('ES34','63636612566700038791')::IBAN,
  GREATEST(TO_TIMESTAMP('2025-01-25','YYYY-MM-DD'), (SELECT fechaDeCreacion FROM Cuenta WHERE iban = ROW('ES34','63636612566700038791')::IBAN LIMIT 1) + INTERVAL '1 second'),
  733668686.16,
  'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.',
  'INGRESO',
  8951
);
INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (
  93,
  ROW('ES56','28585662977724343797')::IBAN,
  GREATEST(TO_TIMESTAMP('2024-11-20','YYYY-MM-DD'), (SELECT fechaDeCreacion FROM Cuenta WHERE iban = ROW('ES56','28585662977724343797')::IBAN LIMIT 1) + INTERVAL '1 second'),
  423560731.87,
  'Maecenas tincidunt lacus at velit.',
  'INGRESO',
  3173
);
INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (
  96,
  ROW('ES12','20556946225442951404')::IBAN,
  GREATEST(TO_TIMESTAMP('2024-07-10','YYYY-MM-DD'), (SELECT fechaDeCreacion FROM Cuenta WHERE iban = ROW('ES12','20556946225442951404')::IBAN LIMIT 1) + INTERVAL '1 second'),
  191195910.91,
  'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.',
  'RETIRADA',
  2284
);

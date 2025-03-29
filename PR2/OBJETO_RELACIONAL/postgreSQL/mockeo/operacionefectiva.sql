ALTER TABLE operacion DISABLE TRIGGER trigger_bloquear_insercion_operacion;
ALTER TABLE operacion ENABLE TRIGGER ;
INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal)
VALUES (
  26,
  ROW('ES12', '39593283634492562374')::IBAN,
  NOW(),
  795375614.29,
  'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas',
  'INGRESO',
  4660
);

INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal)
VALUES (
  34,
  ROW('ES12', '96714089811638967258')::IBAN,
  NOW(),
  829761618.32,
  'Cras non velit nec nisi vulputate nonummy.',
  'INGRESO',
  4125
);

INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal)
VALUES (
  39,
  ROW('ES12', '78579706658008173005')::IBAN,
  NOW(),
  393964629.32,
  'Phasellus in felis. Donec semper sapien a libero.',
  'INGRESO',
  3332
);

INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal)
VALUES (
  43,
  ROW('ES56', '66821468873531280560')::IBAN,
  NOW(),
  77646300.5,
  'Aliquam sit amet diam in magna bibendum imperdiet.',
  'INGRESO',
  7804
);

INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal)
VALUES (
  60,
  ROW('ES56', '39737108933891563722')::IBAN,
  NOW(),
  87276994.05,
  'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.',
  'INGRESO',
  1407
);

INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal)
VALUES (
  67,
  ROW('ES34', '29897138019421781393')::IBAN,
  NOW(),
  23150446.02,
  'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.',
  'INGRESO',
  7089
);

INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal)
VALUES (
  68,
  ROW('ES12', '39593283634492562374')::IBAN,
  NOW(),
  829765261.68,
  'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.',
  'INGRESO',
  843
);

INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal)
VALUES (
  74,
  ROW('ES56', '54856322742811821733')::IBAN,
  NOW(),
  744003120.42,
  'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.',
  'INGRESO',
  6937
);

INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal)
VALUES (
  79,
  ROW('ES34', '63636612566700038791')::IBAN,
  NOW(),
  733668686.16,
  'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.',
  'INGRESO',
  8951
);

INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal)
VALUES (
  93,
  ROW('ES56', '28585662977724343797')::IBAN,
  NOW(),
  423560731.87,
  'Maecenas tincidunt lacus at velit.',
  'INGRESO',
  3173
);

INSERT INTO OperacionEfectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal)
VALUES (
  96,
  ROW('ES12', '20556946225442951404')::IBAN,
  NOW(),
  191195910.91,
  'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.',
  'INGRESO',
  2284
);

ALTER TABLE operacion ENABLE TRIGGER trigger_bloquear_insercion_operacion;

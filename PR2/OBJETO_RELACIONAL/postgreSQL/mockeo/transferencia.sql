ALTER TABLE operacion DISABLE TRIGGER trigger_bloquear_insercion_operacion;
INSERT INTO Transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion)
VALUES (
  4,
  ROW('ES12', '30455232435145075363')::IBAN,
  ROW('ES12','78579706658008173005')::IBAN,
  NOW(),
  218464836.96,
  'Sed ante.'
);

INSERT INTO Transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion)
VALUES (
  7,
  ROW('ES56', '28585662977724343797')::IBAN,
  ROW('ES12','78579706658008173005')::IBAN,
  NOW(),
  702761725.77,
  'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.'
);

INSERT INTO Transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion)
VALUES (
  63,
  ROW('ES34', '11044307893755950863')::IBAN,
  ROW('ES56','54856322742811821733')::IBAN,
  NOW(),
  399009657.36,
  'Nulla ut erat id mauris vulputate elementum.'
);

INSERT INTO Transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion)
VALUES (
  64,
  ROW('ES12', '19066975309618186907')::IBAN,
  ROW('ES56','39737108933891563722')::IBAN,
  NOW(),
  772701005.03,
  'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.'
);

INSERT INTO Transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion)
VALUES (
  66,
  ROW('ES34', '98977805973753243086')::IBAN,
  ROW('ES56','31939040909526775383')::IBAN,
  NOW(),
  616241137.19,
  'Morbi a ipsum. Integer a nibh.'
);

INSERT INTO Transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion)
VALUES (
  70,
  ROW('ES34', '48441738462668426426')::IBAN,
  ROW('ES12','22783323320297873720')::IBAN,
  NOW(),
  485492446.71,
  'Nulla tellus. In sagittis dui vel nisl.'
);

INSERT INTO Transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion)
VALUES (
  83,
  ROW('ES34', '63636612566700038791')::IBAN,
  ROW('ES12','28259001570344567796')::IBAN,
  NOW(),
  974906701.04,
  'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.'
);

INSERT INTO Transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion)
VALUES (
  85,
  ROW('ES56', '45655246066221445082')::IBAN,
  ROW('ES34','31369550843662602947')::IBAN,
  NOW(),
  418832502.06,
  'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.'
);

INSERT INTO Transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion)
VALUES (
  86,
  ROW('ES34', '48441738462668426426')::IBAN,
  ROW('ES34','81427160483942628213')::IBAN,
  NOW(),
  518419679.02,
  'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.'
);

INSERT INTO Transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion)
VALUES (
  89,
  ROW('ES56', '75944321162844038572')::IBAN,
  ROW('ES56','87755248292858336056')::IBAN,
  NOW(),
  278936883.73,
  'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae'
);

INSERT INTO Transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion)
VALUES (
  53,
  ROW('ES12', '22783323320297873720')::IBAN,
  ROW('ES12','20556946225442951404')::IBAN,
  NOW(),
  713009156.77,
  'Sed vel enim sit amet nunc viverra dapibus.'
);

ALTER TABLE operacion ENABLE TRIGGER trigger_bloquear_insercion_operacion;

INSERT INTO operacionefectiva VALUES (
  OPERACIONEFECTIVAUDT(
    26,
    TO_TIMESTAMP('2024-05-11', 'YYYY-MM-DD'),
    795375614.29,
    'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12'
     AND c.cuenta_iban.NUMEROCUENTA = '39593283634492562374'),
    'Ingreso',
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 4660)
  )
);
INSERT INTO operacionefectiva VALUES (
  OPERACIONEFECTIVAUDT(
    34,
    TO_TIMESTAMP('2024-12-01', 'YYYY-MM-DD'),
    829761618.32,
    'Cras non velit nec nisi vulputate nonummy.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12'
     AND c.cuenta_iban.NUMEROCUENTA = '96714089811638967258'),
    'Ingreso',
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 4125)
  )
);
INSERT INTO operacionefectiva VALUES (
  OPERACIONEFECTIVAUDT(
    39,
    TO_TIMESTAMP('2024-11-21', 'YYYY-MM-DD'),
    393964629.32,
    'Phasellus in felis. Donec semper sapien a libero.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12'
     AND c.cuenta_iban.NUMEROCUENTA = '78579706658008173005'),
    'Retirada',
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 3332)
  )
);
INSERT INTO operacionefectiva VALUES (
  OPERACIONEFECTIVAUDT(
    43,
    TO_TIMESTAMP('2025-02-07', 'YYYY-MM-DD'),
    77646300.5,
    'Aliquam sit amet diam in magna bibendum imperdiet.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56'
     AND c.cuenta_iban.NUMEROCUENTA = '66821468873531280560'),
    'Ingreso',
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 7804)
  )
);
INSERT INTO operacionefectiva VALUES (
  OPERACIONEFECTIVAUDT(
    60,
    TO_TIMESTAMP('2024-09-14', 'YYYY-MM-DD'),
    87276994.05,
    'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56'
     AND c.cuenta_iban.NUMEROCUENTA = '39737108933891563722'),
    'Retirada',
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 1407)
  )
);
INSERT INTO operacionefectiva VALUES (
  OPERACIONEFECTIVAUDT(
    67,
    TO_TIMESTAMP('2025-02-19', 'YYYY-MM-DD'),
    23150446.02,
    'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES34'
     AND c.cuenta_iban.NUMEROCUENTA = '29897138019421781393'),
    'Ingreso',
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 7089)
  )
);
INSERT INTO operacionefectiva VALUES (
  OPERACIONEFECTIVAUDT(
    68,
    TO_TIMESTAMP('2024-04-16', 'YYYY-MM-DD'),
    829765261.68,
    'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12'
     AND c.cuenta_iban.NUMEROCUENTA = '39593283634492562374'),
    'Ingreso',
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 843)
  )
);
INSERT INTO operacionefectiva VALUES (
  OPERACIONEFECTIVAUDT(
    74,
    TO_TIMESTAMP('2024-07-08', 'YYYY-MM-DD'),
    744003120.42,
    'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56'
     AND c.cuenta_iban.NUMEROCUENTA = '54856322742811821733'),
    'Ingreso',
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 6937)
  )
);
INSERT INTO operacionefectiva VALUES (
  OPERACIONEFECTIVAUDT(
    79,
    TO_TIMESTAMP('2025-01-25', 'YYYY-MM-DD'),
    733668686.16,
    'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES34'
     AND c.cuenta_iban.NUMEROCUENTA = '63636612566700038791'),
    'Ingreso',
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 8951)
  )
);
INSERT INTO operacionefectiva VALUES (
  OPERACIONEFECTIVAUDT(
    93,
    TO_TIMESTAMP('2024-11-20', 'YYYY-MM-DD'),
    423560731.87,
    'Maecenas tincidunt lacus at velit.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56'
     AND c.cuenta_iban.NUMEROCUENTA = '28585662977724343797'),
    'Ingreso',
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 3173)
  )
);
INSERT INTO operacionefectiva VALUES (
  OPERACIONEFECTIVAUDT(
    96,
    TO_TIMESTAMP('2024-07-10', 'YYYY-MM-DD'),
    191195910.91,
    'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12'
     AND c.cuenta_iban.NUMEROCUENTA = '20556946225442951404'),
    'Retirada',
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 2284)
  )
);

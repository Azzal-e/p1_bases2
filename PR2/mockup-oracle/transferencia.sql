INSERT INTO transferencia VALUES (
  TRANSFERENCIAUDT(
    4,
    TO_TIMESTAMP('2024-07-13', 'YYYY-MM-DD'),
    218464836.96,
    'Sed ante.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12' AND c.cuenta_iban.NUMEROCUENTA = '30455232435145075363'),
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12' AND c.cuenta_iban.NUMEROCUENTA = '78579706658008173005')
  )
);
INSERT INTO transferencia VALUES (
  TRANSFERENCIAUDT(
    7,
    TO_TIMESTAMP('2024-12-01', 'YYYY-MM-DD'),
    702761725.77,
    'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56' AND c.cuenta_iban.NUMEROCUENTA = '28585662977724343797'),
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12' AND c.cuenta_iban.NUMEROCUENTA = '78579706658008173005')
  )
);
INSERT INTO transferencia VALUES (
  TRANSFERENCIAUDT(
    63,
    TO_TIMESTAMP('2024-12-02', 'YYYY-MM-DD'),
    399009657.36,
    'Nulla ut erat id mauris vulputate elementum.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES34' AND c.cuenta_iban.NUMEROCUENTA = '11044307893755950863'),
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56' AND c.cuenta_iban.NUMEROCUENTA = '54856322742811821733')
  )
);
INSERT INTO transferencia VALUES (
  TRANSFERENCIAUDT(
    64,
    TO_TIMESTAMP('2024-12-13', 'YYYY-MM-DD'),
    772701005.03,
    'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12' AND c.cuenta_iban.NUMEROCUENTA = '19066975309618186907'),
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56' AND c.cuenta_iban.NUMEROCUENTA = '39737108933891563722')
  )
);
INSERT INTO transferencia VALUES (
  TRANSFERENCIAUDT(
    66,
    TO_TIMESTAMP('2025-02-24', 'YYYY-MM-DD'),
    616241137.19,
    'Morbi a ipsum. Integer a nibh.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES34' AND c.cuenta_iban.NUMEROCUENTA = '98977805973753243086'),
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56' AND c.cuenta_iban.NUMEROCUENTA = '31939040909526775383')
  )
);
INSERT INTO transferencia VALUES (
  TRANSFERENCIAUDT(
    70,
    TO_TIMESTAMP('2024-07-18', 'YYYY-MM-DD'),
    485492446.71,
    'Nulla tellus. In sagittis dui vel nisl.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES34' AND c.cuenta_iban.NUMEROCUENTA = '48441738462668426426'),
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12' AND c.cuenta_iban.NUMEROCUENTA = '22783323320297873720')
  )
);
INSERT INTO transferencia VALUES (
  TRANSFERENCIAUDT(
    83,
    TO_TIMESTAMP('2024-11-19', 'YYYY-MM-DD'),
    974906701.04,
    'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES34' AND c.cuenta_iban.NUMEROCUENTA = '63636612566700038791'),
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12' AND c.cuenta_iban.NUMEROCUENTA = '28259001570344567796')
  )
);
INSERT INTO transferencia VALUES (
  TRANSFERENCIAUDT(
    85,
    TO_TIMESTAMP('2024-06-30', 'YYYY-MM-DD'),
    418832502.06,
    'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56' AND c.cuenta_iban.NUMEROCUENTA = '45655246066221445082'),
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES34' AND c.cuenta_iban.NUMEROCUENTA = '31369550843662602947')
  )
);
INSERT INTO transferencia VALUES (
  TRANSFERENCIAUDT(
    86,
    TO_TIMESTAMP('2024-12-20', 'YYYY-MM-DD'),
    518419679.02,
    'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES34' AND c.cuenta_iban.NUMEROCUENTA = '48441738462668426426'),
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES34' AND c.cuenta_iban.NUMEROCUENTA = '81427160483942628213')
  )
);
INSERT INTO transferencia VALUES (
  TRANSFERENCIAUDT(
    89,
    TO_TIMESTAMP('2024-08-09', 'YYYY-MM-DD'),
    278936883.73,
    'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56' AND c.cuenta_iban.NUMEROCUENTA = '75944321162844038572'),
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56' AND c.cuenta_iban.NUMEROCUENTA = '87755248292858336056')
  )
);
INSERT INTO transferencia VALUES (
  TRANSFERENCIAUDT(
    53,
    TO_TIMESTAMP('2024-08-21', 'YYYY-MM-DD'),
    713009156.77,
    'Sed vel enim sit amet nunc viverra dapibus.',
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12' AND c.cuenta_iban.NUMEROCUENTA = '22783323320297873720'),
    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES12' AND c.cuenta_iban.NUMEROCUENTA = '20556946225442951404')
  )
);

INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES12', '63386391639509154692'),
    DATE '2024-09-03',
    500000,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '62518750A'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 6155)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES12', '19066975309618186907'),
    DATE '2024-10-19',
    5000500,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '50943440A'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 4432)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES34', '31369550843662602947'),
    DATE '2024-10-02',
    1000000000,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '90823320U'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 7866)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES34', '95823418951133805386'),
    DATE '2024-05-12',
    6500,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '89105939Q'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 8960)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES34', '41599621800670573931'),
    DATE '2024-10-03',
    8965,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '62036271Z'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 7155)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES34', '31525405907703374532'),
    DATE '2025-03-04',
    900000,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '89105939Q'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 1799)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES56', '95721866181692902389'),
    DATE '2024-05-28',
    756233,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '53238190Q'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 8234)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES56', '39737108933891563722'),
    DATE '2024-10-27',
    796651,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '63768230V'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 5907)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES12', '20556946225442951404'),
    DATE '2025-01-10',
    115698,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '90823320U'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 9411)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES34', '24388154781140011050'),
    DATE '2024-11-07',
    50,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '28920732N'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 1943)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES12', '28259001570344567796'),
    DATE '2024-07-11',
    466696,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '63768230V'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 7386)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES56', '87755248292858336056'),
    DATE '2024-09-07',
    78965,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '28363321J'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 7056)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES56', '75944321162844038572'),
    DATE '2024-07-31',
    445000,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '77890637Z'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 3235)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES56', '31939040909526775383'),
    DATE '2024-10-23',
    899635,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '27185841G'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 7939)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES34', '23099416274385634819'),
    DATE '2024-05-12',
    889992,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '87350791B'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 2808)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES34', '17187876983952761222'),
    DATE '2025-02-12',
    780000,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '28920732N'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 3421)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES34', '63636612566700038791'),
    DATE '2024-07-21',
    220000,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '28363321J'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 4287)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES12', '30455232435145075363'),
    DATE '2025-01-08',
    35000,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '94970522M'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 9978)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES56', '25900081263026151382'),
    DATE '2025-02-05',
    12500,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '53238190Q'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 1857)
  )
);
INSERT INTO cuentacorriente VALUES (
  CUENTACORRIENTEUDT(
    IBAN('ES34', '52442712565312760550'),
    DATE '2025-02-15',
    30000,
    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '53238190Q'),
    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = 5272)
  )
);

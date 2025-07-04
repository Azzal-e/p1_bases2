-- Desactivar los triggers antes de las inserciones
ALTER TABLE cuenta DISABLE TRIGGER trigger_bloquear_insercion_cuenta;
ALTER TABLE Cuenta DISABLE TRIGGER trigger_cuenta_con_titular;
ALTER TABLE CuentaCorriente DISABLE TRIGGER trigger_cuenta_corriente_con_titular;
ALTER TABLE CuentaAhorro DISABLE TRIGGER trigger_cuenta_ahorro_con_titular;
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES34', '59848086950453251393'), DATE '2024-03-20', 3.28);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES12', '71700268326559429666'), DATE '2024-06-26', 1.81);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES34', '29897138019421781393'), DATE '2024-11-18', 4.44);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES12', '78579706658008173005'), DATE '2024-03-29', 3.34);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES34', '98977805973753243086'), DATE '2024-12-03', 1.15);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES56', '54856322742811821733'), DATE '2025-01-23', 3.85);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES56', '28585662977724343797'), DATE '2024-03-25', 2.92);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES56', '18544530822542755553'), DATE '2024-07-28', 1.21);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES12', '39593283634492562374'), DATE '2024-10-30', 3.83);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES34', '62500829720914686128'), DATE '2024-04-14', 1.06);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES34', '11044307893755950863'), DATE '2024-11-05', 4.83);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES12', '96714089811638967258'), DATE '2025-02-07', 1.75);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES12', '22783323320297873720'), DATE '2025-01-13', 1.72);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES34', '81427160483942628213'), DATE '2024-10-14', 2.37);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES34', '74499062111399068675'), DATE '2025-03-13', 4.81);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES56', '66821468873531280560'), DATE '2024-05-17', 3.96);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES34', '48441738462668426426'), DATE '2024-06-07', 1.88);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES56', '45655246066221445082'), DATE '2024-12-28', 1.67);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES56', '30773994417471705062'), DATE '2024-09-10', 3.77);
INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES (ROW('ES12', '15874622282914628495'), DATE '2024-07-30', 2.87);
-- Reactivar los triggers después de las inserciones
ALTER TABLE cuenta ENABLE TRIGGER trigger_bloquear_insercion_cuenta;
ALTER TABLE Cuenta ENABLE TRIGGER trigger_cuenta_con_titular;
ALTER TABLE CuentaCorriente ENABLE TRIGGER trigger_cuenta_corriente_con_titular;
ALTER TABLE CuentaAhorro ENABLE TRIGGER trigger_cuenta_ahorro_con_titular;

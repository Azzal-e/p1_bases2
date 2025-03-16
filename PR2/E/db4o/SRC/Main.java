import java.util.Date;
public class Main {
    public static void main(String[] args) {
        DatabaseManager db = new DatabaseManager("banco.db4o");

        // Crear cliente
        Cliente cliente1 = new Cliente("12345678A", "Juan Pérez", "juan@example.com", "Calle Falsa 123", "600123456", new Date());
        db.guardarCliente(cliente1);
        System.out.println("Cliente guardado: " + cliente1);

        // Crear oficina
        Oficina oficina1 = new Oficina(1, "Gran Vía, Madrid", "915678901");
        db.guardarOficina(oficina1);
        System.out.println("Oficina guardada: " + oficina1);

        // Crear cuenta corriente
        IBAN iban1 = new IBAN("ES12", "345678901234567890");
        CuentaCorriente cuenta1 = new CuentaCorriente(iban1, new Date(), cliente1, oficina1);
        db.guardarCuenta(cuenta1);
        System.out.println("Cuenta guardada: " + cuenta1);

        // Crear cuenta ahorro
        IBAN iban2 = new IBAN("ES34", "987654321098765432");
        CuentaAhorro cuenta2 = new CuentaAhorro(iban2, new Date(), cliente1, 1.5);
        db.guardarCuenta(cuenta2);
        System.out.println("Cuenta de ahorro guardada: " + cuenta2);

        // Crear operación de ingreso
        OperacionEfectiva ingreso = new OperacionEfectiva(cuenta1.getIBAN(), new Date(), 500, "Ingreso en cuenta", cuenta1, oficina1, TipoOperacion.INGRESO);
        db.actualizarOperacionCuenta(ingreso.getCuentaEmisora());
        System.out.println("Operación guardada: " + ingreso);

        // Crear transferencia
        Transferencia transferencia = new Transferencia(cuenta1.getIBAN(), new Date(), 200, "Pago a otra cuenta", cuenta1, cuenta2);
        db.actualizarOperacionCuenta(transferencia.getCuentaEmisora());
        System.out.println("Transferencia guardada: " + transferencia);

        // Mostrar todas las cuentas
        System.out.println("Lista de cuentas en la base de datos:");
        for (Cuenta cuenta : db.obtenerCuentas()) {
            System.out.println(cuenta);
        }

        // Mostrar todas las operaciones
        System.out.println("Lista de operaciones en la base de datos:");
        for (Operacion operacion : db.obtenerOperaciones()) {
            System.out.println(operacion);
        }

        db.cerrar();
    }
}

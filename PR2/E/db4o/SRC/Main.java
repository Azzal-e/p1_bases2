import java.util.Date;
import java.io.File;
import java.time.LocalDate;
import java.time.ZoneId;

public class Main {
    public static void main(String[] args) {

        // Eliminar el archivo de la base de datos si existe
        File dbFile = new File("test.db4o");
        if (dbFile.exists()) {
            if (dbFile.delete()) {
                System.out.println("Base de datos eliminada correctamente.");
            } else {
                System.out.println("Error al eliminar la base de datos.");
            }
        }
        // Crear un DatabaseManager para interactuar con la base de datos
        DatabaseManager dbManager = new DatabaseManager("test.db4o");

        try {
            // Eliminar todo lo que habia en la base de datos
            
            // Guardar clientes
            dbManager.guardarCliente("Juan Pérez", "12345678A", "123456789", "juanperez@example.com", "Calle Falsa 123", new Date(90, 5, 15)); // Año, mes, día (viejo formato)
            dbManager.guardarCliente("María López", "87654321B", "987654321", "marialopez@example.com", "Calle Verdadera 456", new Date(85, 7, 20));

            // Guardar una oficina
            dbManager.guardarOficina(1001, "Calle Principal 789", "600123456");

            // Obtener clientes y mostrar su información
            Cliente cliente1 = dbManager.obtenerCliente("12345678A");
            System.out.println("Cliente 1: " + cliente1);

            Cliente cliente2 = dbManager.obtenerCliente("87654321B");
            System.out.println("Cliente 2: " + cliente2);

            // Guardar cuentas corrientes y de ahorro
            dbManager.guardarCuentaCorriente(
                new IBAN("ES12", "34567890123456789012"),
                Date.from(LocalDate.of(2020, 1, 1).atStartOfDay(ZoneId.systemDefault()).toInstant()),
                "12345678A",
                1001
            ); // Oficinas con código 1001

            dbManager.guardarCuentaAhorro(
                new IBAN("ES98", "76543210123456789012"),
                Date.from(LocalDate.of(2021, 2, 1).atStartOfDay(ZoneId.systemDefault()).toInstant()),
                "87654321B",
                2.5
            );

            // Ver el saldo total de un cliente
            double saldoTotalCliente1 = dbManager.obtenerSaldoTotalCliente("12345678A");
            System.out.println("Saldo total de cliente1: " + saldoTotalCliente1);

            // Ver cuentas de cliente
            System.out.println("Cuentas de cliente1: ");
            for (Cuenta cuenta : dbManager.obtenerCuentasCliente("12345678A")) {
                System.out.println(cuenta);
            }
            // Obtener clientes y mostrar su información
            Cliente cliente = dbManager.obtenerCliente("12345678A");
            System.out.println("Cliente 1: " + cliente);
            // Realizar una operación efectiva
            dbManager.guardarOperacion_efectiva(new IBAN("ES12","34567890123456789012"), new Date(122, 5, 10), 500.0, "Ingreso en cuenta", 1001, TipoOperacion.INGRESO);
            // Mostrar las operaciones
            System.out.println("Operaciones cliente1: ");
            for (Operacion op : dbManager.obtenerOperacionesCliente("12345678A")) {
                System.out.println(op);
            }

            // Realizar una transferencia
            dbManager.guardarOperacion_transferencia(new IBAN("ES12","34567890123456789012"), new Date(123, 5, 15), 200.0, "Transferencia entre cuentas", new IBAN("ES98","76543210123456789012"));

            // Ver las operaciones de transferencia
            System.out.println("Operaciones Transferencia: ");
            for (Transferencia transferencia : dbManager.obtenerOperacionesTransferencia()) {
                System.out.println(transferencia);
            }

            // eliminar cuenta
            dbManager.eliminarCuenta(new IBAN("ES12", "34567890123456789012"));
            //Mostrar cuentas cliente
            System.out.println("Cuentas de cliente1: ");
            for (Cuenta cuenta : dbManager.obtenerCuentasCliente("12345678A")) {
                System.out.println(cuenta);
            }
            // Eliminar cliente
            dbManager.eliminarCliente("12345678A");
            // Verificar que el cliente ha sido eliminado
            try {
                Cliente clienteEliminado = dbManager.obtenerCliente("12345678A");
            } catch (IllegalArgumentException e) {
                System.out.println(e.getMessage());
            }

            System.out.println("FIN.");
        } catch (IllegalArgumentException e) {
            System.out.println(e.getMessage());
        } finally {
            // Cerrar la base de datos al final
            dbManager.cerrar();
        }
    }
}

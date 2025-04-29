package uni;

import javax.persistence.*;
import java.time.LocalDate;
import java.sql.Date;
import java.time.LocalDateTime;
import java.sql.Timestamp;
import java.math.BigDecimal;
import java.util.Set;
import java.util.HashSet;

public class Test {
    public static void main(String[] args) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("banquitoPU");
        EntityManager em = emf.createEntityManager();

        em.getTransaction().begin();

        // --- Oficina ---
        int codigoOficina = 1;
        Oficina oficina = em.find(Oficina.class, codigoOficina);
        if (oficina == null) {
            oficina = new Oficina();
            oficina.setCodigoOficina(codigoOficina);
            oficina.setDireccion("Av. Universidad 123");
            oficina.setTelefono("+34911112222");
            em.persist(oficina);
            System.out.println("Oficina insertada correctamente");
        }
        else{
            System.out.println("Oficina ya existente");
        }

        // --- Cuenta Ahorro ---
        IBAN ibanAhorro = new IBAN("ES76", "1234567890123456789012");
        CuentaAhorro cuentaAhorro = em.find(CuentaAhorro.class, ibanAhorro);
        if (cuentaAhorro == null) {
            cuentaAhorro = new CuentaAhorro(
                ibanAhorro,
                Date.valueOf(LocalDate.now()),
                new BigDecimal("1000.0"),
                new BigDecimal("1.5")
            );
            em.persist(cuentaAhorro);
            System.out.println("Cuenta de ahorro insertada correctamente");
        }
        else{
            System.out.println("Cuenta de ahorro ya existente");
        }            

        // --- Cuenta Corriente ---
        IBAN ibanCorriente = new IBAN("ES76", "1111222233334444555566");
        CuentaCorriente cuentaCorriente = em.find(CuentaCorriente.class, ibanCorriente);
        if (cuentaCorriente == null) {
            cuentaCorriente = new CuentaCorriente(
                ibanCorriente,
                Date.valueOf(LocalDate.now()),
                new BigDecimal("2000.0"),
                oficina
            );
            em.persist(cuentaCorriente);
            System.out.println("Cuenta corriente insertada correctamente");
        }
        else{
            System.out.println("Cuenta corriente ya existente");
        }     

        // --- Cliente ---
        String dniCliente = "12345678A";
        Cliente cliente = em.find(Cliente.class, dniCliente);
        if (cliente == null) {
            cliente = new Cliente();
            cliente.setDni(dniCliente);
            cliente.setNombre("Irene");
            cliente.setApellidos("Pérez Gómez");
            cliente.setFechaDeNacimiento(Date.valueOf(LocalDate.of(2000, 2, 1)));
            cliente.setTelefono("+34600123456");
            cliente.setDireccion("Calle Ejemplo, 42");
            cliente.setEmail("irene@example.com");
            em.persist(cliente);
            System.out.println("Cliente insertado correctamente");
        }
        else{
            System.out.println("Cliente ya existente");
        }     

        // Asociar cuentas al cliente (solo si no están ya asociadas)
        if (!cliente.getCuentas().contains(cuentaAhorro)) {
            cliente.getCuentas().add(cuentaAhorro);
        }
        if (!cliente.getCuentas().contains(cuentaCorriente)) {
            cliente.getCuentas().add(cuentaCorriente);
        }
        em.merge(cliente);

        // --- Operaciones sobre Cuenta Ahorro ---
        crearOperacionEfectivo(em, oficina, ibanAhorro, "INGRESO", new BigDecimal("100.00"), "Ingreso en cuenta de ahorro");
        System.out.println("Operacion efectiva insertada correctamente");
        crearOperacionRetirada(em, oficina, ibanAhorro, new BigDecimal("50.00"), "Retirada de cuenta de ahorro");
        System.out.println("Operacion retirada insertada correctamente");


        // --- Operaciones sobre Cuenta Corriente ---
        crearOperacionEfectivo(em, oficina, ibanCorriente, "INGRESO", new BigDecimal("200.00"), "Ingreso en cuenta corriente");
        System.out.println("Operacion efectiva insertada correctamente");
        crearOperacionRetirada(em, oficina, ibanCorriente, new BigDecimal("100.00"), "Retirada de cuenta corriente");
        System.out.println("Operacion retirada insertada correctamente");

        // --- Transferencia ---
        crearTransferencia(em, oficina, ibanCorriente, ibanAhorro, new BigDecimal("300.00"), "Transferencia de cuenta corriente a cuenta de ahorro");
        System.out.println("Transferencia insertada correctamente");

        em.getTransaction().commit();
        em.close();
        emf.close();
    }

    private static void crearOperacionEfectivo(EntityManager em, Oficina oficina, IBAN cuenta, String tipo, BigDecimal cuantia, String descripcion) {
        Efectivo operacion = new Efectivo();
        OperacionId id = new OperacionId();
        id.setCuentaEmisora(cuenta);
        operacion.setOperacionId(id);
        operacion.setFechaYHora(Timestamp.valueOf(LocalDateTime.now()));
        operacion.setCuantia(cuantia);
        operacion.setDescripcion(descripcion);
        operacion.setOficina(oficina);
        operacion.setTipoOperacion(tipo);
        em.persist(operacion);
    }

    private static void crearOperacionRetirada(EntityManager em, Oficina oficina, IBAN cuenta, BigDecimal cuantia, String descripcion) {
        Retirada operacion = new Retirada();
        OperacionId id = new OperacionId();
        id.setCuentaEmisora(cuenta);
        operacion.setOperacionId(id);
        operacion.setFechaYHora(Timestamp.valueOf(LocalDateTime.now()));
        operacion.setCuantia(cuantia);
        operacion.setDescripcion(descripcion);
        operacion.setOficina(oficina);
        operacion.setTipoOperacion("RETIRADA");
        em.persist(operacion);
    }

    private static void crearTransferencia(EntityManager em, Oficina oficina, IBAN cuentaEmisora, IBAN cuentaReceptora, BigDecimal cuantia, String descripcion) {
        Transferencia transferencia = new Transferencia();
        OperacionId id = new OperacionId();
        id.setCuentaEmisora(cuentaEmisora);
        transferencia.setOperacionId(id);
        transferencia.setFechaYHora(Timestamp.valueOf(LocalDateTime.now()));
        transferencia.setCuantia(cuantia);
        transferencia.setDescripcion(descripcion);
        transferencia.setCuentaReceptora(cuentaReceptora);
        transferencia.setTipoOperacion("TRANSFERENCIA");
        em.persist(transferencia);
    }
}
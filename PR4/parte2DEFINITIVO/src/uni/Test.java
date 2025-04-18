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




        Oficina oficina = new Oficina();
        oficina.setCodigoOficina(1);
        oficina.setDireccion("Av. Universidad 123");
        oficina.setTelefono("+34911112222");
        em.persist(oficina);




        IBAN ibanAhorro = new IBAN("ES76", "1234567890123456789012");
        CuentaAhorro cuentaAhorro = new CuentaAhorro(
            ibanAhorro,
            Date.valueOf(LocalDate.now()),
            new BigDecimal("1000.0"),
            new BigDecimal("1.5")
        );
        em.persist(cuentaAhorro);

        IBAN ibanCorriente = new IBAN("ES76", "1111222233334444555566");
        CuentaCorriente cuentaCorriente = new CuentaCorriente(
            ibanCorriente,
            Date.valueOf(LocalDate.now()),
            new BigDecimal("2000.0"),
            oficina
        );
        em.persist(cuentaCorriente);




        Cliente cliente = new Cliente();
        cliente.setDni("12345678A");
        cliente.setNombre("Irene");
        cliente.setApellidos("Pérez Gómez");
        LocalDate nacimiento = LocalDate.of(2000, 2, 1); 
        cliente.setFechaDeNacimiento(Date.valueOf(nacimiento));
        cliente.setTelefono("+34600123456");
        cliente.setDireccion("Calle Ejemplo, 42");
        cliente.setEmail("irene@example.com");
        em.persist(cliente);

        cliente.getCuentas().add(cuentaAhorro);
        cliente.getCuentas().add(cuentaCorriente);
        em.merge(cliente); 

        // Operaciones efectivas/retiradas sobre Cuenta Ahorro:
        Efectivo ingresoAhorro = new Efectivo();
        OperacionId id1 = new OperacionId();
        id1.setCuentaEmisora(ibanAhorro);
        ingresoAhorro.setOperacionId(id1);
        ingresoAhorro.setFechaYHora(Timestamp.valueOf(LocalDateTime.now()));
        ingresoAhorro.setCuantia(new BigDecimal("100.00"));
        ingresoAhorro.setDescripcion("Ingreso en cuenta de ahorro");
        ingresoAhorro.setOficina(oficina);
        ingresoAhorro.setTipoOperacion("INGRESO");
        em.persist(ingresoAhorro);


        Retirada retiradaAhorro = new Retirada();
        OperacionId id2 = new OperacionId();
        id2.setCuentaEmisora(ibanAhorro);
        retiradaAhorro.setOperacionId(id2);
        retiradaAhorro.setFechaYHora(Timestamp.valueOf(LocalDateTime.now()));
        retiradaAhorro.setCuantia(new BigDecimal("50.00"));
        retiradaAhorro.setDescripcion("Retirada de cuenta de ahorro");
        retiradaAhorro.setOficina(oficina);
        retiradaAhorro.setTipoOperacion("RETIRADA");
        em.persist(retiradaAhorro);



        // Operaciones efectivas/retiradas sobre Cuenta Corriente:
        Efectivo ingresoCorriente = new Efectivo();
        OperacionId id3 = new OperacionId();
        id3.setCuentaEmisora(ibanCorriente);
        ingresoCorriente.setOperacionId(id3);
        ingresoCorriente.setFechaYHora(Timestamp.valueOf(LocalDateTime.now()));
        ingresoCorriente.setCuantia(new BigDecimal("200.00"));
        ingresoCorriente.setDescripcion("Ingreso en cuenta corriente");
        ingresoCorriente.setOficina(oficina);
        ingresoCorriente.setTipoOperacion("INGRESO");
        em.persist(ingresoCorriente);


        Retirada retiradaCorriente = new Retirada();
        OperacionId id4 = new OperacionId();
        id4.setCuentaEmisora(ibanCorriente);
        retiradaCorriente.setOperacionId(id4);
        retiradaCorriente.setFechaYHora(Timestamp.valueOf(LocalDateTime.now()));
        retiradaCorriente.setCuantia(new BigDecimal("100.00"));
        retiradaCorriente.setDescripcion("Retirada de cuenta corriente");
        retiradaCorriente.setOficina(oficina);
        retiradaCorriente.setTipoOperacion("RETIRADA");
        em.persist(retiradaCorriente);




        // Transferencia:
        Transferencia transferencia = new Transferencia();
        OperacionId id5 = new OperacionId();
        id5.setCuentaEmisora(ibanCorriente);
        transferencia.setOperacionId(id5);
        transferencia.setFechaYHora(Timestamp.valueOf(LocalDateTime.now()));
        transferencia.setCuantia(new BigDecimal("300.00"));
        transferencia.setDescripcion("Transferencia de cuenta corriente a cuenta de ahorro");
        transferencia.setCuentaReceptora(ibanAhorro);
        transferencia.setTipoOperacion("TRANSFERENCIA");
        em.persist(transferencia);




        em.getTransaction().commit();
        em.close();
        emf.close();

        System.out.println("¡Oficina, Cuenta, Cliente, Operacion y Titular insertadas correctamente!");
    }

}

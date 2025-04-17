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

        IBAN iban = new IBAN("ES76", "1234567890123456789012");

        Cuenta cuenta = new Cuenta();
        cuenta.setIban(iban);
        cuenta.setFechaDeCreacion(Date.valueOf(LocalDate.now()));
        cuenta.setSaldo(new BigDecimal("1000.0"));
        cuenta.setEsCuentaCorriente(false);
        cuenta.setInteres(new BigDecimal("1.5"));
        cuenta.setOficina(null); 
        em.persist(cuenta);

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

        Set<Cuenta> cuentas = new HashSet<>();
        cuentas.add(cuenta);
        cliente.setCuentas(cuentas);
        em.merge(cliente);

        Operacion operacion = new Operacion();
        operacion.setCodigo(1);
        operacion.setCuentaEmisora(iban);
        operacion.setFechaYHora(Timestamp.valueOf(LocalDateTime.now()));
        operacion.setDescripcion("Ingreso inicial");
        operacion.setCuantia(new BigDecimal("500.00"));
        operacion.setTipoOperacion("INGRESO");
        operacion.setCuentaReceptora(null); 
        operacion.setOficina(oficina);
        em.persist(operacion);

        em.getTransaction().commit();
        em.close();
        emf.close();

        System.out.println("¡Oficina, Cuenta, Cliente, Operacion y Titular insertadas correctamente!");
    }
}

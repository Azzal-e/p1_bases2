package uni;

import javax.persistence.*;
import javax.persistence.criteria.*;

import java.time.LocalDate;
import java.sql.Date;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

public class Test {
    private static void insertClients(EntityManager em) {
        Cliente cliente;
        String path = "bin/data/cliente.csv";

        try(BufferedReader br = new BufferedReader(new FileReader(path))) {
            String linea;
            while ((linea = br.readLine()) != null) {
                String[] columnas = linea.split(";");
                cliente = new Cliente();
                cliente.setDni(columnas[0]);
                cliente.setNombre(columnas[1]);
                cliente.setApellidos(columnas[2]);
                String fecha[] = columnas[3].split("-");
                LocalDate nacimiento = LocalDate.of(Integer.parseInt(fecha[0]), Integer.parseInt(fecha[1]), Integer.parseInt(fecha[2]));
                cliente.setFechaDeNacimiento(Date.valueOf(nacimiento));
                cliente.setTelefono(columnas[4]);
                cliente.setDireccion(columnas[5]);
                cliente.setEmail(columnas[6]);
                em.persist(cliente);
            }
            System.out.println("Los clientes se han insertado correctamente.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void insertCuentaAhorro(EntityManager em) {
        String path = "bin/data/cuenta_ahorro.csv";
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String linea;
            while ((linea = br.readLine()) != null) {
                String[] columnas = linea.split(";");
                String fecha[] = columnas[2].split("-");
                LocalDate creacion = LocalDate.of(Integer.parseInt(fecha[0]), Integer.parseInt(fecha[1]), Integer.parseInt(fecha[2]));
                CuentaAhorro cuenta = new CuentaAhorro(new IBAN(columnas[0], columnas[1]), Date.valueOf(creacion), new BigDecimal(columnas[3]), new BigDecimal(columnas[4]));
                em.persist(cuenta);
            }
            System.out.println("Las cuentas de ahorro se han insertado correctamente.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void insertCuentaCorriente(EntityManager em) {
        String path = "bin/data/cuenta_corriente.csv";
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String linea;
            while ((linea = br.readLine()) != null) {
                String[] columnas = linea.split(";");
                String fecha[] = columnas[2].split("-");
                LocalDate creacion = LocalDate.of(Integer.parseInt(fecha[0]), Integer.parseInt(fecha[1]), Integer.parseInt(fecha[2]));
                Oficina oficina = em.find(Oficina.class, Integer.parseInt(columnas[4]));
                CuentaCorriente cuenta = new CuentaCorriente(new IBAN(columnas[0], columnas[1]), Date.valueOf(creacion), new BigDecimal(columnas[3]), oficina);
                em.persist(cuenta);
            }
            System.out.println("Las cuentas corrientes se han insertado correctamente.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void insertEfectivo(EntityManager em) {
        String path = "bin/data/efectivo.csv";
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String linea;
            while ((linea = br.readLine()) != null) {
                String[] columnas = linea.split(";");
                String fecha[] = columnas[2].split("-");
                LocalDate creacion = LocalDate.of(Integer.parseInt(fecha[0]), Integer.parseInt(fecha[1]), Integer.parseInt(fecha[2]));
                Oficina oficina = em.find(Oficina.class, Integer.parseInt(columnas[5]));
                Efectivo efectivo = new Efectivo(new IBAN(columnas[0], columnas[1]), Date.valueOf(creacion), new BigDecimal(columnas[3]), new String(columnas[4]), oficina);
                em.persist(efectivo);
            }
            System.out.println("Las operaciones efectivas se han insertado correctamente.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void insertRetirada(EntityManager em) {
        String path = "bin/data/retirada.csv";
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String linea;
            while ((linea = br.readLine()) != null) {
                String[] columnas = linea.split(";");
                String fecha[] = columnas[2].split("-");
                LocalDate creacion = LocalDate.of(Integer.parseInt(fecha[0]), Integer.parseInt(fecha[1]), Integer.parseInt(fecha[2]));
                Oficina oficina = em.find(Oficina.class, Integer.parseInt(columnas[5]));
                Retirada retirada = new Retirada(new IBAN(columnas[0], columnas[1]), Date.valueOf(creacion), new BigDecimal(columnas[3]), columnas[4], oficina);
                em.persist(retirada);
            }
            System.out.println("Las operaciones de retirada se han insertado correctamente.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void insertTransferencia(EntityManager em) {
        String path = "bin/data/transferencia.csv";
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String linea;
            while ((linea = br.readLine()) != null) {
                String[] columnas = linea.split(";");
                String fecha[] = columnas[4].split("-");
                LocalDate creacion = LocalDate.of(Integer.parseInt(fecha[0]), Integer.parseInt(fecha[1]), Integer.parseInt(fecha[2]));
                Transferencia transferencia = new Transferencia(new IBAN(columnas[0], columnas[1]), new IBAN(columnas[2], columnas[3]), Date.valueOf(creacion), new BigDecimal(columnas[5]), columnas[6]);
                em.persist(transferencia);
            }
            System.out.println("Las operaciones de transferencia se han insertado correctamente.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void insertOficinas(EntityManager em) {
        String path = "bin/data/oficinas.csv";
    
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String linea;
            while ((linea = br.readLine()) != null) {
                String[] columnas = linea.split(";");
                Oficina oficina = new Oficina();
                oficina.setCodigoOficina(Integer.parseInt(columnas[0]));
                oficina.setDireccion(columnas[1]);
                oficina.setTelefono(columnas[2]);
                em.persist(oficina);
            }
            System.out.println("Las oficinas se han insertado correctamente.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void insertTitulares(EntityManager em) {
        String path = "bin/data/titular.csv";
    
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String linea;
            while ((linea = br.readLine()) != null) {
                String[] columnas = linea.split(";");
                Cliente cliente = em.find(Cliente.class, columnas[0]);
                Cuenta cuenta = em.find(Cuenta.class, new IBAN(columnas[1], columnas[2]));
                cliente.getCuentas().add(cuenta);
                em.merge(cliente);
            }
            System.out.println("Los titulares de las cuentas se han establecido correctamente.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private static void querysJPQL(EntityManager em) {
        // Obtener los 20 clientes con más saldo total en sus cuentas y que tengan un saldo total superior a 5000 euros, ordenados de mayor a menor saldo.
        String queryString = "SELECT c.dni, c.nombre, cuenta.iban.prefijoIBAN, cuenta.iban.numeroDeCuenta, SUM(cuenta.saldo) " +
                     "FROM Cliente c " +
                     "JOIN c.cuentas cuenta " +
                     "GROUP BY c.dni, c.nombre, cuenta.iban.prefijoIBAN, cuenta.iban.numeroDeCuenta " +
                     "HAVING SUM(cuenta.saldo) > 5000 " +
                     "ORDER BY SUM(cuenta.saldo) DESC";
        Query query = em.createQuery(queryString);
        query.setMaxResults(20); // Limitar a 20 filas
        List<Object[]> res = query.getResultList();
        for (Object[] resultado : res) {
            String dni = (String) resultado[0];
            String nombre = (String) resultado[1];
            String prefijoIBAN = (String) resultado[2];
            String numeroDeCuenta = (String) resultado[3];
            BigDecimal saldoTotal = (BigDecimal) resultado[4];
            System.out.println("Cliente: " + nombre + " (" + dni + "), Cuenta: " + prefijoIBAN + numeroDeCuenta + ", Saldo Total: " + saldoTotal);
        }

        // Listar oficinas que tengan más de 10 operaciones asociadas en orden descendente por el número de operaciones.
        String queryString2 = "SELECT o.codigoOficina, o.direccion, o.telefono, COUNT(op) " +
                     "FROM Oficina o " +
                     "JOIN o.operaciones op " +
                     "GROUP BY o.codigoOficina, o.direccion, o.telefono " +
                     "HAVING COUNT(op) > 15" +
                     "ORDER BY COUNT(op) DESC";
        Query query2 = em.createQuery(queryString2);
        List<Object[]> res2 = query2.getResultList();
        for (Object[] resultado : res2) {
            Integer codigoOficina = (Integer) resultado[0];
            String direccion = (String) resultado[1];
            String telefono = (String) resultado[2];
            Long numOperaciones = (Long) resultado[3];
            System.out.println("Oficina: " + codigoOficina + ", Dirección: " + direccion + ", Teléfono: " + telefono + ", Número de Operaciones: " + numOperaciones);
        }

        // Obtener los 10 clientes que más han movido dinero en operaciones de tipo TRANSFERENCIA, indicando el número total de transferencias realizadas y la suma total transferida, ordenados por la suma total en orden descendente.
        String queryString3 = "SELECT c.dni, c.nombre, COUNT(t), SUM(t.cuantia) " +
        "FROM Cliente c, Transferencia t " +
        "JOIN c.cuentas cu " +
        "WHERE t.operacionId.cuentaEmisora = cu.iban " +
        "GROUP BY c.dni, c.nombre " +
        "ORDER BY SUM(t.cuantia) DESC";

        Query query3 = em.createQuery(queryString3);
        query3.setMaxResults(10); // Limitar a 10 filas
        List<Object[]> resultados = query3.getResultList();

        for (Object[] fila : resultados) {
            System.out.println("Cliente: " + fila[1] + " (" + fila[0] + "), Nº Transferencias: " + fila[2] + ", Total Transferido: " + fila[3]);
        }
    }

    private static void querysCriteriaAPI(EntityManager em) {
        CriteriaBuilder cb = em.getCriteriaBuilder();
    
        // === CONSULTA 1: Clientes con más saldo total ===
        CriteriaQuery<Object[]> cq1 = cb.createQuery(Object[].class);
        Root<Cliente> cliente = cq1.from(Cliente.class);
        Join<Cliente, Cuenta> cuenta = cliente.join("cuentas");
    
        Expression<BigDecimal> sumaSaldo = cb.sum(cuenta.get("saldo"));
        cq1.multiselect(
                cliente.get("dni"),
                cliente.get("nombre"),
                cuenta.get("iban").get("prefijoIBAN"),
                cuenta.get("iban").get("numeroDeCuenta"),
                sumaSaldo
        );
        cq1.groupBy(
                cliente.get("dni"),
                cliente.get("nombre"),
                cuenta.get("iban").get("prefijoIBAN"),
                cuenta.get("iban").get("numeroDeCuenta")
        );
        cq1.having(cb.gt(sumaSaldo, new BigDecimal("5000")));
        cq1.orderBy(cb.desc(sumaSaldo));
    
        TypedQuery<Object[]> query1 = em.createQuery(cq1);
        query1.setMaxResults(20);
        List<Object[]> resultados1 = query1.getResultList();
    
        for (Object[] resultado : resultados1) {
            String dni = (String) resultado[0];
            String nombre = (String) resultado[1];
            String prefijoIBAN = (String) resultado[2];
            String numeroDeCuenta = (String) resultado[3];
            BigDecimal saldoTotal = (BigDecimal) resultado[4];
            System.out.println("Cliente: " + nombre + " (" + dni + "), Cuenta: " + prefijoIBAN + numeroDeCuenta + ", Saldo Total: " + saldoTotal);
        }
    
        // === CONSULTA 2: Oficinas con más de 15 operaciones ===
        CriteriaQuery<Object[]> cq2 = cb.createQuery(Object[].class);
        Root<Oficina> oficina = cq2.from(Oficina.class);
        Join<Oficina, Operacion> operacion = oficina.join("operaciones");
    
        Expression<Long> countOperaciones = cb.count(operacion);
    
        cq2.multiselect(
                oficina.get("codigoOficina"),
                oficina.get("direccion"),
                oficina.get("telefono"),
                countOperaciones
        );
        cq2.groupBy(
                oficina.get("codigoOficina"),
                oficina.get("direccion"),
                oficina.get("telefono")
        );
        cq2.having(cb.gt(countOperaciones, 15L));
        cq2.orderBy(cb.desc(countOperaciones));
    
        List<Object[]> resultados2 = em.createQuery(cq2).getResultList();
    
        for (Object[] resultado : resultados2) {
            Integer codigo = (Integer) resultado[0];
            String direccion = (String) resultado[1];
            String telefono = (String) resultado[2];
            Long numOperaciones = (Long) resultado[3];
            System.out.println("Oficina: " + codigo + ", Dirección: " + direccion + ", Teléfono: " + telefono + ", Nº Operaciones: " + numOperaciones);
        }

        // === CONSULTA 3: Obtener los 10 clientes que más han movido dinero en operaciones de tipo TRANSFERENCIA, indicando el número total de transferencias realizadas y la suma total transferida, ordenados por la suma total en orden descendente. ===
        CriteriaQuery<Object[]> cq3 = cb.createQuery(Object[].class);
        Root<Cliente> clientes = cq3.from(Cliente.class);
        Root<Transferencia> transferencia = cq3.from(Transferencia.class);
        cq3.multiselect(
            clientes.get("dni"),
            clientes.get("nombre"),
            cb.count(transferencia),
            cb.sum(transferencia.get("cuantia"))
        );
        Join<Cliente, Cuenta> cuentas = clientes.join("cuentas");
        cq3.where(cb.equal(cuentas.get("iban"), transferencia.get("operacionId").get("cuentaEmisora")));
        cq3.groupBy(clientes.get("dni"), clientes.get("nombre"));
        cq3.orderBy(cb.desc(cb.sum(transferencia.get("cuantia"))));
        
        TypedQuery<Object[]> query3 = em.createQuery(cq3);
        query3.setMaxResults(10); // Limitar a 10 filas

        List<Object[]> resultados3 = query3.getResultList();
        
        for (Object[] fila : resultados3) {
            System.out.println("Cliente: " + fila[1] + " (" + fila[0] + "), Nº Transferencias: " + fila[2] + ", Total Transferido: " + fila[3]);
        }
    }
    

    public static void main(String[] args) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("banquitoPU");
        EntityManager em = emf.createEntityManager();

        em.getTransaction().begin();

        // Inserción de los datos a partir de los ficheros csv delimitados por ';'
        insertClients(em);
        insertOficinas(em);
        insertCuentaAhorro(em);
        insertCuentaCorriente(em);
        insertTitulares(em);
        insertEfectivo(em);
        insertRetirada(em);
        insertTransferencia(em);

        em.getTransaction().commit();
        System.out.println("¡Oficina, Cuenta, Cliente, Operacion y Titular insertadas correctamente!");

        /* CONSULTAS JPQL*/
        querysJPQL(em);
        /* CONSULTAS CRITERIA API */
        querysCriteriaAPI(em);

        em.close();
        emf.close();
    }

}

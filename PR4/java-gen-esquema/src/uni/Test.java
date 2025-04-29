package uni;

import java.time.LocalDate;
import java.util.List;
import java.time.LocalDateTime;
import java.sql.Date;
import java.sql.Timestamp;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.PersistenceException;
import javax.persistence.NamedQuery;
import javax.persistence.NoResultException;
import javax.persistence.Query;



public class Test {
    private static EntityManagerFactory entityManagerFactory = null;
    private final EntityManager entityManager;

    public Test() {
        if (entityManagerFactory == null) {
            entityManagerFactory = Persistence.createEntityManagerFactory("UnidadPersistenciaBanquito");
        }
        entityManager = entityManagerFactory.createEntityManager();
    }

    public void prueba() {

        EntityTransaction trans = entityManager.getTransaction();
        trans.begin();
        
        try {
        	
            // Creación de direcciones
            Direccion d1 = crearDireccion("Teruel", 50001, "calle a");
            Direccion d2 = crearDireccion("Huesca", 50002, "calle b");
            Direccion d3 = crearDireccion("Zaragoza", 50003, "calle c");
            Direccion d4 = crearDireccion("Zaragoza", 50005, "calle a");


        	
            // Persistir direcciones primero
            entityManager.persist(d1);
            entityManager.persist(d2);
            entityManager.persist(d3);
            entityManager.persist(d4);
	        Direccion d5 = crearDireccion("Zaragoza", 50006, "Avenida Principal 10");
	        entityManager.persist(d5);

            // Creación y persistencia de clientes
            Cliente cliente1 = crearCliente("25796324X", "Juan", "Perez Lopez", 
                                          "lopez123@gmail.com", LocalDate.of(1990, 5, 20), 
                                          "654321987", d1);
            Cliente cliente2 = crearCliente("12345678Y", "Maria", "Gomez Ruiz", 
                                          null, LocalDate.of(1985, 3, 15), 
                                          "654321987", d2);
            entityManager.persist(cliente1);
            entityManager.persist(cliente2);

            // Creación y persistencia de oficinas
            Oficina oficina1 = crearOficina(1234, d3, "87654321");
            Oficina oficina2 = crearOficina(5678, d4, "12345678");
            entityManager.persist(oficina1);
            entityManager.persist(oficina2);

            // Creación de cuentas (asignando oficinas antes de persistir)
            CuentaAhorro cuentaAhorro1 = crearCuentaAhorro("ES", "1234567891357801234", 
                                                         LocalDate.of(2023, 10, 1), 0.05f);
          
            cuentaAhorro1.addCliente(cliente1);
            entityManager.persist(cuentaAhorro1);

            CuentaCorriente cuentaCorriente1 = crearCuentaCorriente("ES", "1234567890124680132", 
                                                                  LocalDate.of(2022, 10, 1));
            cuentaCorriente1.setOficina(oficina1); // Asignar oficina
            cuentaCorriente1.addCliente(cliente2);
            entityManager.persist(cuentaCorriente1);

            // Creación y persistencia de operaciones
            LocalDateTime fechaOperacion = LocalDateTime.of(2023, 10, 1, 12, 30, 50);
            
            Ingreso ingreso1 = new Ingreso(1, cuentaCorriente1, Timestamp.valueOf(fechaOperacion), 
                                         "KEBAB 5 EUROS", 5);
            ingreso1.setSucursalDeOperacion(oficina2);
            entityManager.persist(ingreso1);

            Retirada retirada1 = new Retirada(2, cuentaCorriente1, Timestamp.valueOf(fechaOperacion), 
                                            null, 25.4);
            retirada1.setSucursalDeOperacion(oficina2);
            entityManager.persist(retirada1);

            Transferencia transferencia1 = new Transferencia(3, cuentaCorriente1, 
                                                           Timestamp.valueOf(fechaOperacion), 
                                                           "De nada", 10);
            transferencia1.setCuentaReceptora(cuentaAhorro1);
            entityManager.persist(transferencia1);
         
	
	         // Clientes adicionales con diferentes características
	         Cliente cliente3 = crearCliente("98765432Z", "Ana", "Martinez Sol", 
	                                       "ana.martinez@example.com", LocalDate.of(2000, 12, 5), 
	                                       "600112233", d3);
	         Cliente cliente4 = crearCliente("45678901W", "Pedro", "Garcia", 
	                                       null, LocalDate.of(1975, 7, 30), 
	                                       "699887766", d1); // Misma dirección que cliente1
	         Cliente cliente5 = crearCliente("11122334Q", "Laura", "Fernandez", 
	                                       "laura.fernandez@bank.com", LocalDate.of(1995, 2, 28), 
	                                       "655444333", d4); // Dirección de oficina2
	         entityManager.persist(cliente3);
	         entityManager.persist(cliente4);
	         entityManager.persist(cliente5);
	
	         // Oficina adicional en misma ciudad pero distinto código postal
	         Oficina oficina3 = crearOficina(9100, d5, "87654321");
	         entityManager.persist(oficina3);
	
	         // Cuentas adicionales con diferentes características
	         CuentaAhorro cuentaAhorro2 = crearCuentaAhorro("ES", "9876543210987654321", 
	                                                      LocalDate.of(2024, 1, 15), 0.03f);
	         cuentaAhorro2.addCliente(cliente2);
	         cuentaAhorro2.addCliente(cliente3); // Cuenta compartida
	         entityManager.persist(cuentaAhorro2);
	
	         CuentaCorriente cuentaCorriente2 = crearCuentaCorriente("ES", "1122334455667788990", 
	                                                               LocalDate.of(2020, 5, 1));
	         cuentaCorriente2.setOficina(oficina3);
	         cuentaCorriente2.addCliente(cliente4);
	         entityManager.persist(cuentaCorriente2);
	
	         // Cuenta sin clientes asociados (caso límite)
	         //try {
	        //	 CuentaAhorro cuentaAhorro3 = crearCuentaAhorro("ES", "0000000000000000000", 
	          //                                            LocalDate.now(), 0.02f);
	         	//entityManager.persist(cuentaAhorro3);
	         //}catch(PersistenceException e) {
	        	// System.out.println("Problema de cuenta sin cliente");
	         //}
	         // Operaciones adicionales con diferentes patrones
	         LocalDateTime fechaHoy = LocalDateTime.now();
	
	         // 1. Operaciones en diferentes fechas
	         Ingreso ingreso2 = new Ingreso(4, cuentaAhorro2, 
	                                      Timestamp.valueOf(fechaHoy.minusDays(2)), 
	                                      "Nómina", 1500.50);
	         ingreso2.setSucursalDeOperacion(oficina2);
	         entityManager.persist(ingreso2);
	
	         Retirada retirada2 = new Retirada(5, cuentaCorriente2, 
	                                         Timestamp.valueOf(fechaHoy.minusMonths(1)), 
	                                         "Cajero automático", 200);
	         retirada2.setSucursalDeOperacion(oficina3);
	         entityManager.persist(retirada2);
	
	         // 2. Transferencia entre cuentas de diferentes tipos
	         Transferencia transferencia2 = new Transferencia(6, cuentaCorriente1, 
	                                                        Timestamp.valueOf(fechaHoy), 
	                                                        "Pago compartido", 75.30);
	         transferencia2.setCuentaReceptora(cuentaAhorro2);
	         entityManager.persist(transferencia2);
	
	         // 3. Operaciones con importes extremos
	         Ingreso ingreso3 = new Ingreso(7, cuentaAhorro1, 
	                                      Timestamp.valueOf(fechaHoy.minusYears(1)), 
	                                      "Lotería", 1000000);
	         ingreso3.setSucursalDeOperacion(oficina2);
	         entityManager.persist(ingreso3);
	
	         Retirada retirada3 = new Retirada(8, cuentaCorriente2, 
	                                         Timestamp.valueOf(fechaHoy), 
	                                         "Inversión", 50000);
	         retirada3.setSucursalDeOperacion(oficina3);
	         entityManager.persist(retirada3);
	
	         // 4. Operaciones sin sucursal asociada
	         Retirada retirada4 = new Retirada(9, cuentaAhorro2, 
	                                         Timestamp.valueOf(fechaHoy), 
	                                         "Compra online", 89.90);
	         retirada4.setSucursalDeOperacion(oficina3);
	         entityManager.persist(retirada4);
	
	         // 5. Operaciones recurrentes en misma cuenta
	    
	         for(int i = 10; i <= 15; i++) {
	             Ingreso ingresoRecurrente = new Ingreso(i, cuentaCorriente1, 
	                                                   Timestamp.valueOf(fechaHoy.minusDays(i)), 
	                                                   "Ingreso recurrente", 100 * i);
	             ingresoRecurrente.setSucursalDeOperacion(oficina3);
	             entityManager.persist(ingresoRecurrente);
	         }
	
	
	         // 7. Operación con descripción larga
	         String descripcionLarga = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " +
	                                 "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
	         Ingreso ingreso4 = new Ingreso(17, cuentaAhorro1, 
	                                      Timestamp.valueOf(fechaHoy), 
	                                      descripcionLarga, 250);
	         ingreso4.setSucursalDeOperacion(oficina1);
	         entityManager.persist(ingreso4);
	
	         

            trans.commit();
            System.out.println("TODAS LAS OPERACIONES SE COMPLETARON CORRECTAMENTE\n\n");
            
            try {
                // 1. Consulta original sin cambios
                Query q1 = entityManager.createQuery(
                    "SELECT ce.iban.prefijo, ce.iban.numeroDeCuenta, COUNT(oe) as cuentaOp " +
                    "FROM OFICINA o " +
                    "JOIN o.operacionesEfectivas oe " +
                    "JOIN oe.opId.cuentaEmisora ce " +
                    "WHERE o.codigo = :codigo " +
                    "GROUP BY ce.iban.prefijo, ce.iban.numeroDeCuenta " +
                    "ORDER BY cuentaOp DESC");
                
                q1.setParameter("codigo", 9100);
                q1.setMaxResults(1);
                
                // 2. Obtener clave primaria
                Object[] resultado = (Object[]) q1.getSingleResult();
                String prefijo = (String) resultado[0];
                String numeroCuenta = (String) resultado[1];
                Long operaciones = (Long) resultado[2];
                
                // 3. Obtener entidad COMPLETA con find()
                IBAN iban = new IBAN(prefijo, numeroCuenta); // Clave compuesta
                Cuenta cuenta = entityManager.find(Cuenta.class, iban);
                
                // 4. Mostrar usando toString() y detalles específicos
                System.out.println("=== CUENTA COMPLETA (usando toString()) ===");
                System.out.println(cuenta); // Implícitamente llama a cuenta.toString()
                
                
                System.out.println("\nTotal operaciones: " + operaciones);

            } catch (NoResultException e) {
                System.out.println("No hay operaciones para esta oficina");
            }
            
            
            // Consulta 2. Suma de saldo de  todas las cuentas de un cliente
            Query q2 = entityManager.createQuery("select SUM(cc.saldo) as saldoTotal " 
            									+ "from CLIENTE c, in (c.cuentas) cc " 
            									+ "where c.DNI = ?1");
            q2.setParameter(1,"25796324X");
            Double sumaSaldos = (Double) q2.getSingleResult();
            System.out.println("SALDO TOTAL DE CLIENTE 25796324 : " + sumaSaldos);
            
            // Consulta 3. Obtener a todas las cuentas corrientes que hayan realizado transferencias en una oficina distinta a su adscrita
            
            Query q3 = entityManager.createQuery("select distinct cc "
            									 + "FROM CUENTA_CORRIENTE cc, "
            									 + "in(cc.operacionesComoEmisora) op, "
            									 + "in(op.sucursalDeOperacion) ofi "
            									 + "WHERE TYPE(op) IN (INGRESO, RETIRADA) "
            									 + "AND ofi.codigo <> cc.oficinaAdscrita.codigo ");

            List<CuentaCorriente> resultados = q3.getResultList(); // Lista de CuentaCorriente, no Object[]
            for (CuentaCorriente cuenta : resultados) {
                System.out.println(cuenta.toString());
                System.out.println("  Oficina adscrita real: " + cuenta.getOficina().getCodigo());
            }
            
            
            
        } catch (PersistenceException e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            System.err.println("ERROR EN LA PERSISTENCIA: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (entityManager != null && entityManager.isOpen()) {
                entityManager.close();
            }
        }
    }

    // Métodos auxiliares (igual que en la versión anterior)
    private Direccion crearDireccion(String ciudad, int codPostal, String direccion) {
        Direccion d = new Direccion();
        d.setCiudad(ciudad);
        d.setCodPostal(codPostal);
        d.setDireccion(direccion);
        return d;
    }

    private Cliente crearCliente(String dni, String nombre, String apellidos, 
                               String email, LocalDate fechaNac, 
                               String telefono, Direccion direccion) {
        return new Cliente(dni, nombre, apellidos, email, 
                          Date.valueOf(fechaNac), telefono, direccion);
    }

    private Oficina crearOficina(int codigo, Direccion direccion, String telefono) {
        return new Oficina(codigo, direccion, telefono);
    }

    private CuentaAhorro crearCuentaAhorro(String prefijo, String numero, 
                                         LocalDate fechaCreacion, float interes) {
        return new CuentaAhorro(prefijo, numero, Date.valueOf(fechaCreacion), interes);
    }

    private CuentaCorriente crearCuentaCorriente(String prefijo, String numero, 
                                               LocalDate fechaCreacion) {
        return new CuentaCorriente(prefijo, numero, Date.valueOf(fechaCreacion));
    }
    
    public static void cerrar() {
        try {
			try {
				if (entityManagerFactory != null && entityManagerFactory.isOpen()) {
				    entityManagerFactory.close();
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }

    public static void main(String[] args) {
        Test t = new Test();
        try {
            t.prueba();
        } finally {
            Test.cerrar();
        }
    }
}
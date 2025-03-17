import com.db4o.*;
import java.util.List;
import java.util.Date;
import java.util.ArrayList;


public class DatabaseManager {
    private ObjectContainer db;

    public DatabaseManager(String filename) {
        db = Db4oEmbedded.openFile(Db4oEmbedded.newConfiguration(), filename);
    }

    public void guardarCliente(String nombre, String dni, String telefono, String email, String direccion, Date fechaNacimiento) {
        if(!db.query(c -> c.getDNI().equals(dni)).isEmpty()){
            throw new IllegalArgumentException("Error: ya existe un cliente con ese DNI");
        }
        else{
            Cliente cliente = new Cliente(nombre, direccion, telefono, email, dni, fechaNacimiento);
            db.store(cliente);
            db.commit();
        }
    }

    public void guardarCuentaCorriente(IBAN IBAN, Date fechaCreacion, String DNI_titular, int codigoOficina){
        // Verificar si ya existe una cuenta con ese IBAN
        ObjectSet<Cuenta> cuentasExistentes = db.query(c -> c instanceof Cuenta && c.getIBAN().equals(IBAN));
        if (!cuentasExistentes.isEmpty()) {
            throw new IllegalArgumentException("Error: ya existe una cuenta con ese IBAN");
        }
        
        //Obtener cliente
        Cliente titular = obtenerCliente(DNI_titular);
    
        // Buscar la oficina correspondiente
        Oficina oficina = obtenerOficina(codigoOficina);

        // Crear y almacenar la cuenta corriente
        CuentaCorriente cuentaCorriente = new CuentaCorriente(IBAN, fechaCreacion, titular, oficina);

        // El cliente ve modificada su lista de cuentas, por lo que se debe actualizar en la base de datos su instancia
        db.store(titular);

        db.store(cuentaCorriente);
        db.commit();
    }
    
    public void guardarCuentaAhorro(IBAN IBAN, Date fechaCreacion, String DNI_titular, double interes){
        if(!db.query(c -> c.getIBAN().equals(IBAN)).isEmpty()){
            throw new IllegalArgumentException("Error: ya existe una cuenta con ese IBAN");
        }
        else{
            //Obtener cliente
            Cliente titular = obtenerCliente(DNI_titular);
            
            CuentaAhorro cuentaAhorro = new CuentaAhorro(IBAN, fechaCreacion, titular, interes);

            // El cliente ve modificada su lista de cuentas, por lo que se debe actualizar en la base de datos su instancia
            db.store(titular);

            db.store(cuentaAhorro);
            db.commit();
        }
    }

    public void guardarOficina(int codigoOficina, String direccion, String telefono){
        if(!db.query(c -> c.getCodigoOficina().equals(codigoOficina)).isEmpty()){
            throw new IllegalArgumentException("Error: ya existe una oficina con ese código");
        }
        else{
            Oficina oficina = new Oficina(codigoOficina, direccion, telefono);
            db.store(oficina);
            db.commit();
        }
    }

    public void guardarOperacion_efectiva(IBAN IBAN_cuentaEmisora, Date fechaYHora, double cuantia, String descripcion, int codigoOficina, TipoOperacion tipoOperacion){
        //Obtener cuenta emisora
        Cuenta cuentaEmisora = obtenerCuenta(IBAN_cuentaEmisora);

        //Obtener oficina
        Oficina oficina = obtenerOficina(codigoOficina);

        OperacionEfectiva operacionEfectiva = new OperacionEfectiva(IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, cuentaEmisora, oficina, tipoOperacion);

        // Operacion efectiva actuliza el saldo de la cuenta emisora, por lo que se debe actualizar en la base de datos su instancia
        db.store(cuentaEmisora);

        db.store(operacionEfectiva);
        db.commit();
    }
    
    public void guardarOperacion_transferencia(IBAN IBAN_cuentaEmisora, Date fechaYHora, double cuantia, String descripcion,  IBAN IBAN_cuentaReceptora){
        //Obtener cuenta emisora
        Cuenta cuentaEmisora = obtenerCuenta(IBAN_cuentaEmisora);

        //Obtener cuenta receptora
        Cuenta cuentaReceptora = obtenerCuenta(IBAN_cuentaReceptora);

        Transferencia transferencia = new Transferencia(IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, cuentaEmisora, cuentaReceptora);

        // Operacion transferencia actuliza el saldo de las cuentas emisora y receptora, por lo que se debe actualizar en la base de datos su instancia
        db.store(cuentaEmisora);
        db.store(cuentaReceptora);

        db.store(transferencia);
        db.commit();
    }
    
   
        

    public Oficina obtenerOficina(int codigoOficina){
        ObjectSet<Oficina> oficinas = db.query(o -> o instanceof Oficina && o.getCodigoOficina() == codigoOficina);
        if (oficinas.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe una oficina con ese código");
        }
        return oficinas.next();
    }

    public Cuenta obtenerCuenta(IBAN IBAN){
        ObjectSet<Cuenta> cuentas = db.query(c -> c instanceof Cuenta && c.getIBAN().equals(IBAN));
        if (cuentas.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe una cuenta con ese IBAN");
        }
        return cuentas.next();
    }

    public Cliente obtenerCliente(String dni){
        ObjectSet<Cliente> clientes = db.query(c -> c instanceof Cliente && c.getDNI().equals(dni));
        if (clientes.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe un cliente con ese DNI");
        }
        return clientes.next();
    }

    public Operacion obtenerOperacion(int codigoOperacion, IBAN IBAN_cuentaEmisora){
        ObjectSet<Operacion> operaciones = db.query(c -> c instanceof Operacion && c.getCodigoOperacion().equals(codigoOperacion) && c.getCuentaEmisora().getIBAN().equals(IBAN_cuentaEmisora));
        if (operaciones.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe una operación con ese código");
        }
        return operaciones.next();
    }

    public void actualizarCliente(String dni, String nombre, String direccion, String telefono, String email){
        Cliente cliente = obtenerCliente(dni);
        if(cliente == null){
            throw new IllegalArgumentException("Error: no existe un cliente con ese DNI");
        }
        else{
            if (nombre != null){
                cliente.setNombre(nombre);
            }
            if (direccion != null){
                cliente.setDireccion(direccion);
            }
            if (telefono != null){
                cliente.setTelefono(telefono);
            }
            if (email != null){
                cliente.setEmail(email);
            }
            db.store(cliente);
            db.commit();
        }
    }

    public void actualizarOficina(int codigoOficina, String direccion, String telefono){
        Oficina oficina = obtenerOficina(codigoOficina);
        if(oficina == null){
            throw new IllegalArgumentException("Error: no existe una oficina con ese código");
        }
        else{
            if (direccion != null){
                oficina.setDireccion(direccion);
            }
            if (telefono != null){
                oficina.setTelefono(telefono);
            }
            db.store(oficina);
            db.commit();
        }
    }

    public void actualizarDatosCuentaCorriente(IBAN IBAN, Date fechaCreacion,int codigoOficina){
        Cuenta cuenta = obtenerCuenta(IBAN);
        if(cuenta == null || !(cuenta instanceof CuentaCorriente)){
            throw new IllegalArgumentException("Error: no existe una cuenta corriente con ese IBAN");
        }
        else{
            if (fechaCreacion != null){
                cuenta.setFechaCreacion(fechaCreacion);
            }
            if (codigoOficina != 0){
                Oficina oficina = obtenerOficina(codigoOficina);
                ((CuentaCorriente) cuenta).setOficina(oficina);
            }
            db.store(cuenta);
            db.commit();
        }
    }

    public void actualizarDatosCuentaAhorro(IBAN IBAN, Date fechaCreacion, double interes){
        Cuenta cuentaAhorro = obtenerCuenta(IBAN);
        if(cuentaAhorro == null || !(cuentaAhorro instanceof CuentaAhorro)){
            throw new IllegalArgumentException("Error: no existe una cuenta ahorro con ese IBAN");
        }
        else{
            if (fechaCreacion != null){
                cuentaAhorro.setFechaCreacion(fechaCreacion);
            }
            if (interes >= 0){
                ((CuentaAhorro) cuentaAhorro).setInteres(interes);
            }
            db.store(cuentaAhorro);
            db.commit();
        }
    }

    public void añadirTitularCuenta(IBAN IBAN, String DNI_titular){
        Cuenta cuenta = obtenerCuenta(IBAN);
        if(cuenta == null){
            throw new IllegalArgumentException("Error: no existe una cuenta con ese IBAN");
        }
        else{
            Cliente titular = obtenerCliente(DNI_titular);
            cuenta.addTitular(titular);
            // Actualizar también nuevo titular de la cuenta
            db.store(titular);
            db.store(cuenta);
            db.commit();
        }
    }

    public void eliminarTitularCuenta(IBAN IBAN, String DNI_titular){
        Cuenta cuenta = obtenerCuenta(IBAN);
        if(cuenta == null){
            throw new IllegalArgumentException("Error: no existe una cuenta con ese IBAN");
        }
        else{
            Cliente titular = obtenerCliente(DNI_titular);
            cuenta.removeTitular(titular);
            db.store(cuenta);
            db.commit();
        }
    }

    public void actualizarOperacionEfectiva(int codigoOperacion, IBAN IBAN_cuentaEmisora, Date fechaYHora, double cuantia, String descripcion, int codigoOficina, TipoOperacion tipoOperacion){
        Operacion operacion = obtenerOperacion(codigoOperacion, IBAN_cuentaEmisora);
        if(operacion == null || !(operacion instanceof OperacionEfectiva)){
            throw new IllegalArgumentException("Error: no existe una operación efectiva con ese código");
        }
        else{
            if (fechaYHora != null){
                operacion.setFechaYHora(fechaYHora);
            }
            if (cuantia >= 0){
                ((OperacionEfectiva) operacion).setCuantia(cuantia);
            }
            if (descripcion != null){
                operacion.setDescripcion(descripcion);
            }
            if (codigoOficina != 0){
                Oficina oficina = obtenerOficina(codigoOficina);
                ((OperacionEfectiva) operacion).setOficina(oficina);
            }
            if (tipoOperacion != null){
                ((OperacionEfectiva) operacion).setTipoOperacion(tipoOperacion);
            }
            // Actualizar cuenta emisora por si se ha actualizado su saldo
            db.store(operacion.getCuentaEmisora());
            db.store(operacion);
            db.commit();
        }
    }

    public void actualizarOperacionTransferencia(int codigoOperacion, IBAN IBAN_cuentaEmisora, Date fechaYHora, double cuantia, String descripcion){
        Operacion operacion = obtenerOperacion(codigoOperacion, IBAN_cuentaEmisora);
        if(operacion == null || !(operacion instanceof Transferencia)){
            throw new IllegalArgumentException("Error: no existe una operación de transferencia con ese código");
        }
        else{
            if (fechaYHora != null){
                operacion.setFechaYHora(fechaYHora);
            }
            if (cuantia >= 0){
                ((Transferencia) operacion).setCuantia(cuantia);
            }
            if (descripcion != null){
                operacion.setDescripcion(descripcion);
            }
            // Actualizar cuenta emisora por si se ha actualizado su saldo
            db.store(operacion.getCuentaEmisora());
            db.store(operacion);
            db.commit();
        }
    }


    public void eliminarCliente(String dni){
        if(db.query(c -> c.getDNI().equals(dni)).isEmpty()){
            throw new IllegalArgumentException("Error: no existe un cliente con ese DNI");
        }
        else{
            // Eliminar todas las cuentas del cliente
            Cliente cliente = obtenerCliente(dni);
            // Obtener las cuentas del cliente para actualizarlas posteriormente
            ArrayList

            cliente.destruirCliente();

            db.commit();
        }
    }

    public void eliminarCuenta(Cuenta cuenta){
        if(db.query(c -> c.getIBAN().equals(cuenta.getIBAN())).isEmpty()){
            throw new IllegalArgumentException("Error: no existe una cuenta con ese IBAN");
        }
        else{
            // Eliminar todas las operaciones de la cuenta
            List<Operacion> operaciones = db.query(c -> c.getCuentaEmisora().equals(cuenta));
            for(Operacion operacion : operaciones){
                eliminarOperacion(operacion);
            }
            // Eliminar cuenta
            db.delete(cuenta);
            db.commit();
        }
    }

    public void eliminarOperacion(Operacion operacion){
        if(db.query(c -> c.getCodigoOperacion().equals(operacion.getCodigoOperacion())).isEmpty()){
            throw new IllegalArgumentException("Error: no existe una operación con ese código");
        }
        else{
            db.delete(operacion);
            db.commit();
        }
    }

    public void eliminarOficina(Oficina oficina){
        if(db.query(c -> c.getCodigoOficina().equals(oficina.getCodigoOficina())).isEmpty()){
            throw new IllegalArgumentException("Error: no existe una oficina con ese código");
        }
        else{
            db.delete(oficina);
            db.commit();
        }
    }

    //algunas Operaciones de consulta
    public Lias

    public void cerrar() {
        db.close();
    }
}

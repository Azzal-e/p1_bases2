import com.db4o.*;
import java.util.List;
import java.util.Date;
import java.util.ArrayList;
import com.db4o.query.Constraint;
import com.db4o.query.Query;


public class DatabaseManager {
    private ObjectContainer db;

    public DatabaseManager(String filename) {
        db = Db4oEmbedded.openFile(Db4oEmbedded.newConfiguration(), filename);
    }

    // Guardar un cliente
    public void guardarCliente(String nombre, String dni, String telefono, String email, String direccion, Date fechaNacimiento) {
        Query query = db.query();
        query.constrain(Cliente.class);
        query.descend("dni").constrain(dni);
        ObjectSet<Cliente> clientesExistentes = query.execute();
        if (!clientesExistentes.isEmpty()) {
            throw new IllegalArgumentException("Error: ya existe un cliente con ese DNI");
        } else {
            Cliente cliente = new Cliente(nombre, direccion, telefono, email, dni, fechaNacimiento);
            db.store(cliente);
            db.commit();
        }
    }

    
    // Guardar una cuenta corriente
    public void guardarCuentaCorriente(IBAN IBAN, Date fechaCreacion, String DNI_titular, int codigoOficina) {
        Query query = db.query();
        query.constrain(Cuenta.class);
        query.descend("IBAN").constrain(IBAN);
        ObjectSet<Cuenta> cuentasExistentes = query.execute();
        if (!cuentasExistentes.isEmpty()) {
            throw new IllegalArgumentException("Error: ya existe una cuenta con ese IBAN");
        }

        // Obtener cliente
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
    
    // Guardar una cuenta de ahorro
    public void guardarCuentaAhorro(IBAN IBAN, Date fechaCreacion, String DNI_titular, double interes) {
        Query query = db.query();
        query.constrain(Cuenta.class);
        query.descend("IBAN").constrain(IBAN);
        ObjectSet<Cuenta> cuentasExistentes = query.execute();
        if (!cuentasExistentes.isEmpty()) {
            throw new IllegalArgumentException("Error: ya existe una cuenta con ese IBAN");
        } else {
            // Obtener cliente
            Cliente titular = obtenerCliente(DNI_titular);

            // Crear cuenta de ahorro
            CuentaAhorro cuentaAhorro = new CuentaAhorro(IBAN, fechaCreacion, titular, interes);

            // El cliente ve modificada su lista de cuentas, por lo que se debe actualizar en la base de datos su instancia
            db.store(titular);

            db.store(cuentaAhorro);
            db.commit();
        }
    }

    // Guardar una oficina
    public void guardarOficina(int codigoOficina, String direccion, String telefono) {
        Query query = db.query();
        query.constrain(Oficina.class);
        query.descend("codigoOficina").constrain(codigoOficina);
        ObjectSet<Oficina> oficinasExistentes = query.execute();
        if (!oficinasExistentes.isEmpty()) {
            throw new IllegalArgumentException("Error: ya existe una oficina con ese código");
        } else {
            Oficina oficina = new Oficina(codigoOficina, direccion, telefono);
            db.store(oficina);
            db.commit();
        }
    }

    // Guardar operación efectiva
    public void guardarOperacion_efectiva(IBAN IBAN_cuentaEmisora, Date fechaYHora, double cuantia, String descripcion, int codigoOficina, TipoOperacion tipoOperacion) {
        // Obtener cuenta emisora
        Cuenta cuentaEmisora = obtenerCuenta(IBAN_cuentaEmisora);

        // Obtener oficina
        Oficina oficina = obtenerOficina(codigoOficina);

        OperacionEfectiva operacionEfectiva = new OperacionEfectiva(IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, cuentaEmisora, oficina, tipoOperacion);

        // Operacion efectiva actualiza el saldo de la cuenta emisora, por lo que se debe actualizar en la base de datos su instancia
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
    
   
        

    // Obtener oficina por código
    public Oficina obtenerOficina(int codigoOficina) {
        Query query = db.query();
        query.constrain(Oficina.class);
        query.descend("codigoOficina").constrain(codigoOficina);
        ObjectSet<Oficina> oficinas = query.execute();
        if (oficinas.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe una oficina con ese código");
        }
        return oficinas.get(0);
    }

    // Obtener cuenta por IBAN
    public Cuenta obtenerCuenta(IBAN IBAN) {
        Query query = db.query();
        query.constrain(Cuenta.class);
        query.descend("IBAN").constrain(IBAN);
        ObjectSet<Cuenta> cuentas = query.execute();
        if (cuentas.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe una cuenta con ese IBAN");
        }
        return cuentas.get(0);
    }

    // Obtener cliente por DNI
    public Cliente obtenerCliente(String dni) {
        Query query = db.query();
        query.constrain(Cliente.class);
        query.descend("dni").constrain(dni);
        ObjectSet<Cliente> clientes = query.execute();
        if (clientes.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe un cliente con ese DNI");
        }
        return clientes.get(0);
    }

    public Operacion obtenerOperacion(int codigoOperacion, IBAN IBAN_cuentaEmisora) {
        // Crear una consulta para obtener operaciones
        Query query = db.query();
        query.constrain(Operacion.class);
        
        // Condición para obtener operaciones con el código y el IBAN de la cuenta emisora
        query.descend("codigoOperacion").constrain(codigoOperacion);
        query.descend("cuentaEmisora").descend("IBAN").constrain(IBAN_cuentaEmisora);
        
        // Ejecutar la consulta
        ObjectSet<Operacion> operaciones = query.execute();
        
        // Verificar si se encontró la operación
        if (operaciones.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe una operación con ese código");
        }
        
        // Retornar la primera operación encontrada
        return operaciones.get(0);
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


    public void eliminarCliente(String dni) {
        // Crear una consulta para obtener el cliente por su DNI
        Query query = db.query();
        query.constrain(Cliente.class);
        query.descend("dni").constrain(dni);
        ObjectSet<Cliente> clientes = query.execute();
        
        if (clientes.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe un cliente con ese DNI");
        } else {
            // Obtener el cliente para eliminar
            Cliente cliente = clientes.get(0);
    
            // Obtener las cuentas del cliente para actualizarlas posteriormente
            ArrayList<Cuenta> cuentasCliente = new ArrayList<>(cliente.getCuentas());
    
            // Llamar al método destruirCliente si es necesario
            cliente.destruirCliente();
    
            for (Cuenta cuenta : cuentasCliente) {
                // Si alguna cuenta no tiene titulares, se lanza excepción
                if (cuenta.getTitulares().isEmpty()) {
                    throw new IllegalArgumentException("Error: la cuenta " + cuenta.getIBAN() + " no tiene titulares");
                }
    
                // Actualizamos las cuentas, porque ha cambiado su lista de titulares.
                db.store(cuenta);
            }
    
            // Eliminar el cliente de la base de datos
            db.delete(cliente);
    
            // Hacer commit para confirmar los cambios
            db.commit();
        }
    }
    

    public void eliminarCuenta(IBAN IBAN) {
        // Crear una consulta para verificar si la cuenta existe por su IBAN
        Query query = db.query();
        query.constrain(Cuenta.class);
        query.descend("IBAN").constrain(IBAN);
        ObjectSet<Cuenta> cuentasExistentes = query.execute();
        
        if (cuentasExistentes.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe una cuenta con ese IBAN");
        } else {
            // Obtener todas las operaciones de la cuenta
            List<Operacion> operaciones =  obtenerOperacionesCuenta(IBAN);
            
            // Eliminar las operaciones de la cuenta
            for (Operacion operacion : operaciones) {
                operacion.destruirOperacion();
                
                // Si la operación es una transferencia, actualizamos la cuenta receptora
                if (operacion instanceof Transferencia) {
                    Transferencia transferencia = (Transferencia) operacion;
                    db.store(transferencia.getCuentaReceptora());
                }
    
                // Eliminar la operación
                db.delete(operacion);
            }
            //Volver a almacenar a todos los titulares de esa cuenta
            // Verificar si la lista de cuentas no está vacía
            if (cuentasExistentes.isEmpty()) {
                return; // Si no hay cuentas, no hacer nada
            }

            // Hacemos una copia de la lista de titulares para evitar ConcurrentModificationException
            List<Cliente> titularesCopy = new ArrayList<>(cuentasExistentes.get(0).getTitulares());

            for (Cliente titular : titularesCopy) {
                cuentasExistentes.get(0).removeTitular(titular);  // Elimina el titular de la cuenta
                db.store(titular);  // Vuelve a almacenar al titular
            }
            // Eliminar la cuenta
            db.delete(cuentasExistentes.get(0));
            
            // Confirmar los cambios realizados en la base de datos
            db.commit();
        }
    }
    

    public void eliminarOperacion(Operacion operacion) {
        // Crear una consulta para verificar si la operación existe por su código
        Query query = db.query();
        query.constrain(Operacion.class);
        query.descend("codigoOperacion").constrain(operacion.getCodigoOperacion());
        ObjectSet<Operacion> operacionesExistentes = query.execute();
        
        if (operacionesExistentes.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe una operación con ese código");
        } else {
            // Destruir la operación antes de eliminarla
            operacion.destruirOperacion();
    
            // Actualizamos la cuenta emisora por si se ha actualizado su saldo
            db.store(operacion.getCuentaEmisora());
    
            // Si la operación es una transferencia, actualizamos la cuenta receptora
            if (operacion instanceof Transferencia) {
                Transferencia transferencia = (Transferencia) operacion;
                db.store(transferencia.getCuentaReceptora());
            }
    
            // Eliminar la operación
            db.delete(operacion);
            
            // Confirmar los cambios en la base de datos
            db.commit();
        }
    }
    

    public void eliminarOficina(Oficina oficina) {
        // Crear una consulta para verificar si la oficina existe por su código
        Query query = db.query();
        query.constrain(Oficina.class);
        query.descend("codigoOficina").constrain(oficina.getCodigoOficina());
        ObjectSet<Oficina> oficinasExistentes = query.execute();
        
        if (oficinasExistentes.isEmpty()) {
            throw new IllegalArgumentException("Error: no existe una oficina con ese código");
        } else {
            // Eliminar la oficina
            db.delete(oficina);
            
            // Confirmar los cambios en la base de datos
            db.commit();
        }
    }
    
    //algunas Operaciones de consulta
    public List<Cuenta> obtenerCuentasCliente(String dni){
        return obtenerCliente(dni).getCuentas();
    }

    public List<Operacion> obtenerOperacionesCuenta(IBAN IBAN){
        // Hacer query en operaciones
        Query query = db.query();
        query.constrain(Operacion.class); 
        query.descend("cuentaEmisora").descend("IBAN").constrain(IBAN);
        ObjectSet<Operacion> operaciones = query.execute();
        return new ArrayList<>(operaciones);
    }

    public List<Operacion> obtenerOperacionesCliente(String dni) {
        // Obtener el cliente por su DNI
        Cliente cliente = obtenerCliente(dni);
    
        // Crear una consulta para obtener las operaciones
        Query query = db.query();
        query.constrain(Operacion.class);
        
        // Buscar operaciones cuya cuenta emisora tenga al cliente como titular
        query.descend("cuentaEmisora").descend("titulares").constrain(cliente);
        
        // Ejecutar la consulta
        ObjectSet<Operacion> operaciones = query.execute();
        
        // Convertir el resultado en una lista y devolverlo
        return new ArrayList<>(operaciones);
    }
    

    public List<Cliente> obtenerClientesConAlMenosNCuentas(int numCuentas) {
        // Crear una consulta para obtener todos los clientes
        Query query = db.query();
        query.constrain(Cliente.class);
        
        // Ejecutar la consulta para obtener todos los clientes
        ObjectSet<Cliente> clientes = query.execute();
    
        // Filtrar los clientes que tienen al menos 'numCuentas' cuentas
        List<Cliente> clientesConAlMenosNCuentas = new ArrayList<>();
        for (Cliente cliente : clientes) {
            if (cliente.getCuentas().size() >= numCuentas) {
                clientesConAlMenosNCuentas.add(cliente);
            }
        }
    
        // Devolver la lista de clientes filtrados
        return clientesConAlMenosNCuentas;
    }
    

    public List<CuentaAhorro> obtenerCuentasAhorro() {
        // Crear una consulta para obtener todas las cuentas de tipo CuentaAhorro
        Query query = db.query();
        query.constrain(CuentaAhorro.class);
        
        // Ejecutar la consulta
        ObjectSet<CuentaAhorro> cuentasAhorro = query.execute();
        
        // Convertir el resultado en una lista y devolverlo
        return new ArrayList<>(cuentasAhorro);
    }
    

    public List<CuentaCorriente> obtenerCuentasCorrientes() {
        // Crear una consulta para obtener todas las cuentas de tipo CuentaCorriente
        Query query = db.query();
        query.constrain(CuentaCorriente.class);
        
        // Ejecutar la consulta
        ObjectSet<CuentaCorriente> cuentasCorrientes = query.execute();
        
        // Convertir el resultado en una lista y devolverlo
        return new ArrayList<>(cuentasCorrientes);
    }
    

    public List<OperacionEfectiva> obtenerOperacionesEfectivas() {
        // Crear una consulta para obtener todas las operaciones de tipo OperacionEfectiva
        Query query = db.query();
        query.constrain(OperacionEfectiva.class);
        
        // Ejecutar la consulta
        ObjectSet<OperacionEfectiva> operacionesEfectivas = query.execute();
        
        // Convertir el resultado en una lista y devolverlo
        return new ArrayList<>(operacionesEfectivas);
    }


    public List<Transferencia> obtenerOperacionesTransferencia() {
        // Crear una consulta para obtener todas las operaciones de tipo Transferencia
        Query query = db.query();
        query.constrain(Transferencia.class);
        
        // Ejecutar la consulta
        ObjectSet<Transferencia> transferencias = query.execute();
        
        // Convertir el resultado en una lista y devolverlo
        return new ArrayList<>(transferencias);
    }
    

    public List<Operacion> obtenerOperacionesCuentaEntreFechas(IBAN IBAN, Date fechaInicio, Date fechaFin) {
        // Crear una consulta para obtener las operaciones de una cuenta entre fechas
        Query query = db.query();
        query.constrain(Operacion.class);
        query.descend("cuentaEmisora").descend("IBAN").constrain(IBAN);
        query.descend("fechaYHora").constrain(fechaInicio).greater();
        query.descend("fechaYHora").constrain(fechaFin).smaller();
    
        // Ejecutar la consulta
        ObjectSet<Operacion> operaciones = query.execute();
    
        // Convertir el resultado en una lista y devolverlo
        return new ArrayList<>(operaciones);
    }
    

    public List<Operacion> obtenerOperacionesClienteEntreFechas(String dni, Date fechaInicio, Date fechaFin) {
        // Obtener el cliente por su DNI
        Cliente cliente = obtenerCliente(dni);
    
        // Crear una consulta para obtener las operaciones de un cliente entre fechas
        Query query = db.query();
        query.constrain(Operacion.class);
        query.descend("cuentaEmisora").descend("titulares").constrain(cliente);
        query.descend("fechaYHora").constrain(fechaInicio).greater();
        query.descend("fechaYHora").constrain(fechaFin).smaller();
    
        // Ejecutar la consulta
        ObjectSet<Operacion> operaciones = query.execute();
    
        // Convertir el resultado en una lista y devolverlo
        return new ArrayList<>(operaciones);
    }
    
    
    public List<Cuenta> obtenerCuentasConSaldoMinimo(double saldoMinimo) {
        // Crear una consulta para obtener las cuentas con un saldo mínimo
        Query query = db.query();
        query.constrain(Cuenta.class);
        query.descend("saldo").constrain(saldoMinimo).greater();
    
        // Ejecutar la consulta
        ObjectSet<Cuenta> cuentas = query.execute();
    
        // Convertir el resultado en una lista y devolverlo
        return new ArrayList<>(cuentas);
    }
    
    
    public double obtenerSaldoTotalCliente(String dni) {
        Cliente cliente = obtenerCliente(dni);
        double saldoTotal = 0.0;
        
        for (Cuenta cuenta : cliente.getCuentas()) {
            saldoTotal += cuenta.getSaldo();
        }
        return saldoTotal;
    }
    
    

    public void cerrar() {
        db.close();
    }
}

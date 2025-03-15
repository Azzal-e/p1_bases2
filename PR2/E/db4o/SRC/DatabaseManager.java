import com.db4o.*;
import java.util.List;

public class DatabaseManager {
    private ObjectContainer db;

    public DatabaseManager(String filename) {
        db = Db4oEmbedded.openFile(Db4oEmbedded.newConfiguration(), filename);
    }

    public void guardarCliente(Cliente cliente) {
        List<Cliente> clientes = db.query(c -> c.getDNI().equals(cliente.getDNI()));
        if(clientes.isEmpty()){
            // Añadir cuentas del cliente que no existan 
            for(Cuenta cuenta : cliente.getCuentas ()){
                if(!db.query(c -> c.getIBAN().equals(cuenta.getIBAN())).isEmpty()){
                    db.store(cuenta);
                }
            }
            db.store(cliente);
            db.commit();
        }
        else{
            throw new IllegalArgumentException("Error: ya existe un cliente con ese DNI");
        }
    }

    public void guardarCuenta(Cuenta cuenta){
        if(!db.query(c -> c.getIBAN().equals(cuenta.getIBAN())).isEmpty()){
            // Añadir titulares de la cuenta que no existan
            for(Cliente titular : cuenta.getTitulares()){
                if(!db.query(c -> c.getDNI().equals(titular.getDNI())).isEmpty()){
                    db.store(titular);
                }
            }
            // Añadir operaciones de la cuenta que no existan
            for(Operacion operacion : cuenta.getOperaciones()){
                if(!db.query(c -> (c.getCodigoOperacion().equals(operacion.getCodigoOperacion()) && c.getIBAN_cuentaEmisora().equals(operacion.getIBAN_cuentaEmisora()))).isEmpty()){
                    db.store(operacion);
                }
            }

            // Si la cuenta es corrriente, añadir oficina que no exista
            if(cuenta instanceof CuentaCorriente){
                if(!db.query(c -> c.getCodigoOficina().equals(((CuentaCorriente) cuenta).getOficina().getCodigoOficina())).isEmpty()){
                    db.store(((CuentaCorriente) cuenta).getOficina());
                }
            }
            db.store(cuenta);
            db.commit();
        }
        else{
            throw new IllegalArgumentException("Error: ya existe una cuenta con ese IBAN");
        }
    }

    public void actualizarOperacionCuenta(Cuenta cuenta){
        if(db.query(c -> c.getIBAN().equals(cuenta.getIBAN())).isEmpty()){
            throw new IllegalArgumentException("Error: no existe una cuenta con ese IBAN");
        }
        else{
            // Añadir operaciones de la cuenta que no existan y actualizar las que existan
            for(Operacion operacion : cuenta.getOperaciones()){
                if(!db.query(c -> (c.getCodigoOperacion().equals(operacion.getCodigoOperacion()) && c.getIBAN_cuentaEmisora().equals(operacion.getIBAN_cuentaEmisora()))).isEmpty()){
                    db.store(operacion);
                }
                // Si operacion es de transferencia, actualizar cuenta receptora
                if(operacion instanceof Transferencia){
                    if(!db.query(c -> c.getIBAN().equals(((Transferencia) operacion).getIBAN_cuentaReceptora())).isEmpty()){
                        db.store(((Transferencia) operacion).getCuentaReceptora());
                    }
                }
            }
            db.commit();
        }
    }

    public void guardarOficina(Oficina oficina){
        if(!db.query(c -> c.getCodigoOficina().equals(oficina.getCodigoOficina())).isEmpty()){
            db.store(oficina);
            db.commit();
        }
        else{
            throw new IllegalArgumentException("Error: ya existe una oficina con ese código");
        }
    }

    public void actualizarCliente(Cliente cliente){
        if(db.query(c -> c.getDNI().equals(cliente.getDNI())).isEmpty()){
            throw new IllegalArgumentException("Error: no existe un cliente con ese DNI");
        }
        else{
            db.store(cliente);
            for(Cuenta cuenta : cliente.getCuentas()){
                // Actualizar cuenta si no existe
                if(!db.query(c -> c.getIBAN().equals(cuenta.getIBAN())).isEmpty()){
                    db.store(cuenta);
                }
            }
            db.commit();
        }
    }

    public void actualizarCuenta(Cuenta cuenta){
        if(db.query(c -> c.getIBAN().equals(cuenta.getIBAN())).isEmpty()){
            throw new IllegalArgumentException("Error: no existe una cuenta con ese IBAN");
        }
        else{
            db.store(cuenta);
            for(Cliente titular : cuenta.getTitulares()){
                if(!db.query(c -> c.getDNI().equals(titular.getDNI())).isEmpty()){
                    db.store(titular);
                }
            }
            db.commit();
        }
    }



    public void actualizarOficina(Oficina oficina){
        if(db.query(c -> c.getCodigoOficina().equals(oficina.getCodigoOficina())).isEmpty()){
            throw new IllegalArgumentException("Error: no existe una oficina con ese código");
        }
        else{
            db.store(oficina);
            db.commit();
        }
    }

    public void eliminarCliente(Cliente cliente){
        if(db.query(c -> c.getDNI().equals(cliente.getDNI())).isEmpty()){
            throw new IllegalArgumentException("Error: no existe un cliente con ese DNI");
        }
        else{
            db.delete(cliente);
            // Eliminar todas las cuentas del cliente que se queden sin titulares
            List<Cuenta> cuentas = db.query(c -> c.getTitulares().contains(cliente));
            for(Cuenta cuenta : cuentas){
                if(cuenta.getTitulares().isEmpty()){
                    eliminarCuenta(cuenta);
                }
            }
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

    // OPERACIONES DE CONSULTAS
    public List<Cliente> obtenerClientes(){
        return db.query(c -> true);
    }

    public List<Cuenta> obtenerCuentas(){
        return db.query(c -> true);
    }

    public List<Operacion> obtenerOperaciones(){
        return db.query(c -> true);
    }

    public List<Oficina> obtenerOficinas(){
        return db.query(c -> true);
    }

    public List<Cliente> obtenerClientesDNI(String dni){
        return db.query(c -> c.getDNI().equals(dni));
    }

    public List<Cuenta> obtenerCuentasIBAN(String iban){
        return db.query(c -> c.getIBAN().equals(iban));
    }

    public List<Operacion> obtenerOperacionesCodigo(String codigo){
        return db.query(c -> c.getCodigoOperacion().equals(codigo));
    }

    public List<Cuenta> obtenerCuentasTitular(String dni){
        return db.query(c -> c.getTitulares().contains(dni));
    }

    public List<Operacion> obtenerOperacionesCuenta(String iban){
        return db.query(c -> c.getCuentaEmisora().equals(iban));
    }

    public List<Cuenta> obtenerCuentasOficina(String codigo){
        return db.query(c -> c.getOficina().getCodigoOficina().equals(codigo));
    }

    public List<Operacion> obtenerOperacionesOficina(String codigo){
        return db.query(c -> c.getOficina().getCodigoOficina().equals(codigo));
    }

    public List<Cliente> obtenerClientesOficina(String codigo){
        return db.query(c -> c.getOficina().getCodigoOficina().equals(codigo));
    }

    public List<Cuenta> obtenerCuentasTitulares(String dni){
        return db.query(c -> c.getTitulares().contains(dni));
    }

    public List<Operacion> obtenerOperacionesCuentaEmisora(String iban){
        return db.query(c -> c.getCuentaEmisora().equals(iban));
    }

    public List<Cuenta> obtenerCuentasAhorro(){
        return db.query(c -> c instanceof CuentaAhorro);
    }

    public List<Cuenta> obtenerCuentasCorriente(){
        return db.query(c -> c instanceof CuentaCorriente);
    }
    public List<Operacion> obtenerOperacionesEfectivas(){
        return db.query(c -> c instanceof OperacionEfectiva);
    }

    public List<Operacion> obtenerOperacionesTransferencia(){
        return db.query(c -> c instanceof OperacionTransferencia);
    }

    public void cerrar() {
        db.close();
    }
}

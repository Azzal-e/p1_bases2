import com.db4o.*;
import java.util.List;

public class DatabaseManager {
    private ObjectContainer db;

    public DatabaseManager(String filename) {
        db = Db4oEmbedded.openFile(Db4oEmbedded.newConfiguration(), filename);
    }

    public void guardarCliente(Cliente cliente) {
        List<Cliente> existente = db.queryByExample(new Cliente(cliente.getDni(), null, null, null, null, null));
        if (!existente.isEmpty()) {
            throw new IllegalArgumentException("Error: Ya existe un cliente con DNI " + cliente.getDni());
        }
        // Añadir cuentas, si no existen
        if()

        db.store(cliente);
        db.commit();
    }


    public void guardarCuenta(Cuenta cuenta) {
        List<Cuenta> cuentaExistente = db.queryByExample(new Cuenta(cuenta.getIBAN(), null, null));
        if (!cuentaExistente.isEmpty()) {
            throw new IllegalArgumentException("Error: Ya existe una cuenta con IBAN " + cuenta.getIBAN());
        }

        List<Cliente> clienteTitular = db.queryByExample(new Cliente(null, null, null, null, cuenta.getTitulares().get(0).getDni(), null));
        if (clienteTitular.isEmpty()) {
            throw new IllegalArgumentException("Error: El titular de la cuenta no está registrado.");
        }

        db.store(cuenta);
        db.commit();
    }

    public void guardarOperacion(Operacion operacion) {
        List<Cuenta> cuentaEmisora = db.queryByExample(new Cuenta(operacion.getIBAN_cuentaEmisora().getIBAN(), null, null));
        if (cuentaEmisora.isEmpty()) {
            throw new IllegalArgumentException("Error: La cuenta emisora no existe.");
        }

        db.store(operacion);
        db.commit();
    }

    public void guardarOficina(Oficina oficina) {
        List<Oficina> oficinaExistente = db.queryByExample(new Oficina(oficina.getCodigoOficina(), oficina.getDireccion(), oficina.getTelefono()));
        if (!oficinaExistente.isEmpty()) {
            throw new IllegalArgumentException("Error: Ya existe una oficina con código " + oficina.getCodigoOficina());
        }
        db.store(oficina);
        db.commit();
    }
mit();
    }

    public List<Cliente> buscarCliente(String dni) {
        return db.queryByExample(new Cliente(null, null, null, null, dni, null));
    }

    public List<Cuenta> buscarCuenta(String iban) {
        return db.queryByExample(new Cuenta(iban, null, null));
    }

    public List<Operacion> buscarOperaciones() {
        return db.query(Operacion.class);
    }


    public void cerrar() {
        db.close();
    }
}

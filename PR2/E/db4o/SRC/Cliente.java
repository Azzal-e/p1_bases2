import java.util.*;
public class Cliente {
    private String nombre;
    private String direccion;
    private String telefono;
    private String email;
    private String dni;
    private Date fechaNacimiento;
    private List<Cuenta> cuentas;

    public Cliente(){
        this.cuentas = new ArrayList<>();
    }

    public Cliente(String nombre, String direccion, String telefono, String email, String dni, Date fechaNacimiento){
        if (nombre == null || direccion == null || telefono == null || dni == null || fechaNacimiento == null){
            throw new IllegalArgumentException("Los parametros no pueden ser nulos");
        }
        else if (nombre.length() > 50){
            throw new IllegalArgumentException("El nombre no puede tener mas de 50 caracteres");
        }
        else if (direccion.length() > 200){
            throw new IllegalArgumentException("La direccion no puede tener mas de 200 caracteres");
        }
        else if (telefono.length() > 16){
            throw new IllegalArgumentException("El telefono no puede tener mas de 16 caracteres");
        }
        else if (email != null && email.length() > 250){
            throw new IllegalArgumentException("El email no puede tener mas de 250 caracteres");
        }
        else if (dni.length() > 20){
            throw new IllegalArgumentException("El DNI no puede tener mas de 20 caracteres");
        }
        else if (fechaNacimiento.after(new Date())){
            throw new IllegalArgumentException("La fecha de nacimiento no puede ser en el futuro");
        }

        this.nombre = nombre;
        this.direccion = direccion;
        this.telefono = telefono;
        this.email = email;
        this.dni = dni;
        this.fechaNacimiento = fechaNacimiento;
        this.cuentas = new ArrayList<>();
    }

    public String getNombre(){
        return this.nombre;
    }

    public void setNombre(String nombre){
        if (nombre == null){
            throw new IllegalArgumentException("El nombre no puede ser nulo");
        }
        else if (nombre.length() > 50){
            throw new IllegalArgumentException("El nombre no puede tener mas de 50 caracteres");
        }
        this.nombre = nombre;
    }

    public String getDireccion(){
        return this.direccion;
    }

    public void setDireccion(String direccion){
        if (direccion == null){
            throw new IllegalArgumentException("La direccion no puede ser nula");
        }
        else if (direccion.length() > 200){
            throw new IllegalArgumentException("La direccion no puede tener mas de 200 caracteres");
        }
        this.direccion = direccion;
    }

    public String getTelefono(){
        return this.telefono;
    }

    public void setTelefono(String telefono){
        if (telefono == null){
            throw new IllegalArgumentException("El telefono no puede ser nulo");
        }
        else if (telefono.length() > 16){
            throw new IllegalArgumentException("El telefono no puede tener mas de 16 caracteres");
        }
        this.telefono = telefono;
    }

    public String getEmail(){
        return this.email;
    }

    public void setEmail(String email){
        if (email.length() > 250){
            throw new IllegalArgumentException("El email no puede tener mas de 250 caracteres");
        }
        this.email = email;
    }

    public String getDni(){
        return this.dni;
    }

    public void setDni(String dni){
        if (dni == null){
            throw new IllegalArgumentException("El DNI no puede ser nulo");
        }
        else if (dni.length() > 20){
            throw new IllegalArgumentException("El DNI no puede tener mas de 20 caracteres");
        }
        this.dni = dni;
    }

    public Date getFechaNacimiento(){
        return this.fechaNacimiento;
    }

    public void setFechaNacimiento(Date fechaNacimiento){
        if (fechaNacimiento == null){
            throw new IllegalArgumentException("La fecha de nacimiento no puede ser nula");
        }
        else if (fechaNacimiento.after(new Date())){
            throw new IllegalArgumentException("La fecha de nacimiento no puede ser en el futuro");
        }
        this.fechaNacimiento = fechaNacimiento;
    }
    
    public List<Cuenta> getCuentas(){
        return this.cuentas;
    }

    public void addCuenta(Cuenta cuenta){
        if(cuenta != null && !this.cuentas.contains(cuenta)){
            System.out.println("Añadiendo cuenta");
            this.cuentas.add(cuenta);
            cuenta.addTitular(this);
        }
    }

    public void removeCuenta(Cuenta cuenta){
        if(cuenta != null && this.cuentas.contains(cuenta)){
            this.cuentas.remove(cuenta);
            cuenta.removeTitular(this);
        }
    }

    public void destruirCliente(){
        // Verifica si la lista de cuentas no está vacía
        if (cuentas.isEmpty()) {
            return; // Si la lista está vacía, no hacer nada
        }

        // Hacemos una copia de la lista de cuentas para evitar ConcurrentModificationException
        List<Cuenta> cuentasCopy = new ArrayList<>(cuentas);

        for (Cuenta cuenta : cuentasCopy) {
            cuenta.removeTitular(this);  // Elimina al titular de la cuenta
            cuentas.remove(cuenta);  // Elimina la cuenta de la lista original
        }
    }

    @Override
    public String toString(){
        // Evitar imprimir la lista de cuentas de manera recursiva
        String cuentasString = cuentas != null ? cuentas.size() + " cuentas" : "Sin cuentas";
        return "Cliente [Nombre=" + nombre + ", DNI=" + dni + ", Cuentas=" + cuentasString + "]";
    }

}

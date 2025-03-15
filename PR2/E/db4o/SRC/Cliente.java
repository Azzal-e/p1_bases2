import java.util.List;
import java.util.Date;
import java.util.ArrayList;

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
        this.nombre = nombre;
    }

    public String getDireccion(){
        return this.direccion;
    }

    public void setDireccion(String direccion){
        this.direccion = direccion;
    }

    public String getTelefono(){
        return this.telefono;
    }

    public void setTelefono(String telefono){
        this.telefono = telefono;
    }

    public String getEmail(){
        return this.email;
    }

    public void setEmail(String email){
        this.email = email;
    }

    public String getDni(){
        return this.dni;
    }

    public void setDni(String dni){
        this.dni = dni;
    }

    public Date getFechaNacimiento(){
        return this.fechaNacimiento;
    }

    public void setFechaNacimiento(Date fechaNacimiento){
        this.fechaNacimiento = fechaNacimiento;
    }
    
    public List<Cuenta> getCuentas(){
        return this.cuentas;
    }

    public void addCuenta(Cuenta cuenta){
        if(cuenta != null && !this.cuentas.contains(cuenta)){
            this.cuentas.add(cuenta);
            cuenta.addTitular(this);
        }
    }

    public void removeCuenta(Cuenta cuenta){
        this.cuentas.remove(cuenta);
    }

    public String toString(){
        return "Cliente: " + this.nombre + " " + this.dni 
        + " " + this.fechaNacimiento + " " + this.direccion + " " + this.telefono + " " + this.email + " " + this.cuentas;
    }

}

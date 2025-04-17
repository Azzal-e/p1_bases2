// ===========================
// 4. Cliente.java
// ===========================
package uni;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;

@Entity
@Table(name = "CLIENTES")
public class Cliente {

    @Id
    @Column(name = "DNI", length = 20)
    private String dni;

    @Column(name = "NOMBRE", length = 50, nullable = false)
    private String nombre;

    @Column(name = "APELLIDOS", length = 75, nullable = false)
    private String apellidos;

    @Column(name = "FECHANACIMIENTO", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date fechaDeNacimiento;

    @Column(name = "TELEFONO", length = 16, nullable = false)
    private String telefono;

    @Column(name = "DIRECCION", length = 200, nullable = false)
    private String direccion;

    @Column(name = "EMAIL", length = 100, nullable = false)
    private String email;

    @Transient
    private int edad;

    @ManyToMany
    @JoinTable(
        name = "TITULAR",
        joinColumns = @JoinColumn(name = "DNI_TITULAR"),
        inverseJoinColumns = {
            @JoinColumn(name = "PREFIJOIBAN", referencedColumnName = "PREFIJOIBAN"),
            @JoinColumn(name = "NUMEROCUENTA", referencedColumnName = "NUMEROCUENTA")
        }
    )
    private Set<Cuenta> cuentas;

    public String getDni() { return dni; }
    public void setDni(String dni) { this.dni = dni; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }
    public Date getFechaDeNacimiento() { return fechaDeNacimiento; }
    public void setFechaDeNacimiento(Date fechaDeNacimiento) { this.fechaDeNacimiento = fechaDeNacimiento; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public int getEdad() { return edad; }
    public void setEdad(int edad) { this.edad = edad; }
    public Set<Cuenta> getCuentas() { return cuentas; }
    public void setCuentas(Set<Cuenta> cuentas) { this.cuentas = cuentas; }
}
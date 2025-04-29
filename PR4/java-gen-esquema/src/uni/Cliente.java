package uni;
import java.sql.Date;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.Period;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.OneToOne;

import org.hibernate.annotations.Check;

@Entity(name = "CLIENTE")
public class Cliente {
	// Atributos de la clase
	
	@Id
	@Column(name = "DNI", length = 20)
	private String DNI;
	
	@Column(name = "NOMBRE", nullable = false)
	private String nombre;
	
	@Column(name = "APELLIDOS",  nullable = false)
	private String apellidos;
	
	@Column(name = "EMAIL")
	@Check(constraints = "EMAIL LIKE '%@%'")
	private String email;
	
	@Column(name = "FECHA_DE_NACIMIENTO",  nullable = false)
	private Date fechaDeNacimiento;
	
	@Column(name = "EDAD",  nullable = false)
	private int edad;
	
	@Column(name = "TELEFONO",  nullable = false)
	@Check(constraints = "TELEFONO NOT LIKE '%[^0-9]%'")
	private String telefono;
	
	@OneToOne(cascade = CascadeType.PERSIST)
	@JoinColumn(nullable = false)
	private Direccion direccion;
	
	@ManyToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
	private Set<Cuenta> cuentas = new HashSet<Cuenta>();
	
	
	// Métodos de clases
	
	public Cliente() {}
	
	public Cliente(String DNI, String nombre, String apellidos, String email,
					Date fechaDeNacimiento, String telefono, Direccion direccion) {
		this.DNI = DNI;
		this.nombre = nombre;
		this.apellidos = apellidos;
		this.email = email;
		this.fechaDeNacimiento = fechaDeNacimiento;
		this.telefono = telefono;
		this.direccion = direccion;
		
		// Generar edad a partir de fecha de nacimiento
		if(fechaDeNacimiento != null){
		    LocalDate fechaDeNacimientoLocal = fechaDeNacimiento.toLocalDate();
		    LocalDate hoy = LocalDate.now();
		    this.edad = Period.between(fechaDeNacimientoLocal, hoy).getYears();
		}
		
	}


	public String getDNI() {
		return DNI;
	}


	public void setDNI(String dNI) {
		DNI = dNI;
	}


	public String getNombre() {
		return nombre;
	}


	public void setNombre(String nombre) {
		this.nombre = nombre;
	}


	public String getApellidos() {
		return apellidos;
	}


	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}


	public String getEmail() {
		return email;
	}


	public void setEmail(String email) {
		this.email = email;
	}


	public Date getFechaDeNacimiento() {
		return fechaDeNacimiento;
	}


	public void setFechaDeNacimiento(Date fechaDeNacimiento) {
		this.fechaDeNacimiento = fechaDeNacimiento;
		
		if(fechaDeNacimiento != null){
			LocalDate fechaDeNacimientoLocal = fechaDeNacimiento.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
			
			LocalDate hoy = LocalDate.now();
			
			this.edad = Period.between(fechaDeNacimientoLocal, hoy).getYears();
		}
	}


	public int getEdad() {
		return edad;
	}
	
	public String getTelefono() {
		return telefono;
	}


	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}


	public Direccion getDireccion() {
		return direccion;
	}


	public void setDireccion(Direccion direccion) {
		this.direccion = direccion;
	}
	
	public void addCuenta (Cuenta cuenta) {
		cuentas.add(cuenta);
		if(!cuenta.hasCliente(this)){
			cuenta.addCliente(this);
		}
	}
	
	public void removeCuenta(Cuenta cuenta) {
		cuentas.remove(cuenta);
		if(cuenta.hasCliente(this)){
			cuenta.removeCliente(this);
		}
	}

	public boolean hasCuenta(Cuenta cuenta){
		return cuentas.contains(cuenta);
	}
	
	@Override
	public String toString() {
		return "Cliente {dni:" + DNI + ", nombre:" + nombre + ", apellidos:" + apellidos 
				+ ", email:" + email + ", telefono:" + telefono + ", fecha  deNacimiento:" + fechaDeNacimiento 
				+ ", direccion=" + direccion.toString() + ", edad=" + edad +"]";
	} 
	
	@Override
	public int hashCode() {
	    final int prime = 31;
	    int result = 1;
	    result = prime * result + ((DNI == null) ? 0 : DNI.hashCode());
	    return result;
	}

	@Override
	public boolean equals(Object obj) {
	    if (this == obj)
	        return true;
	    if (obj == null)
	        return false;
	    if (getClass() != obj.getClass())
	        return false;
	    Cliente other = (Cliente) obj;
	    if (DNI == null) {
	        if (other.DNI != null)
	            return false;
	    } else if (!DNI.equals(other.DNI))
	        return false;
	    return true;
	}
	
}




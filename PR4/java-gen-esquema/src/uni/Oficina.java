package uni;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.validation.constraints.Max;

import org.hibernate.annotations.Check;

@Entity(name= "OFICINA")
public class Oficina {
	
	// Atributos de clase
	
	@Id
	@Column(name = "CODIGO")
	@Max(9999) // El código de oficina es de 4 dígitos [EXTRA HIBERNATE]
	private int codigo;
	
	@OneToOne
	@JoinColumn(unique = true, nullable = false)
	private Direccion direccion;
	
	@Column(name = "TELEFONO")
	@Check(constraints = "TELEFONO NOT LIKE '%[^0-9]%'")
	private String telefono;
	
	@OneToMany(mappedBy = "sucursalDeOperacion", cascade = CascadeType.ALL)
	private Set<OperacionEfectiva> operacionesEfectivas  = new HashSet<OperacionEfectiva>();
	
	// Métodos de clase
	
	public Oficina() {}
	public Oficina(int codigo, Direccion direccion, String telefono) {
		
		this.codigo = codigo;
		
		this.direccion = direccion;
		
		this.telefono = telefono;
		
	}

	public int getCodigo() {
		return codigo;
	}

	public void setCodigo(int codigo) {
		this.codigo = codigo;
	}

	public Direccion getDireccion() {
		return direccion;
	}

	public void setDireccion(Direccion direccion) {
		this.direccion = direccion;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	
	public void addOperacionEfectiva(OperacionEfectiva op) {
		operacionesEfectivas.add(op);
		if(!op.getSucursalDeOperacion().equals(this)){
			op.setSucursalDeOperacion(this);
		}
	}
	
	public void removeOperacionEfectiva(OperacionEfectiva op) {
		operacionesEfectivas.remove(op);
		if(op.getSucursalDeOperacion().equals(this)){
			op.setSucursalDeOperacion(null);
		}
	}

	public boolean hasOperacionEfectiva(OperacionEfectiva op){
		return operacionesEfectivas.contains(op);
	}
	
	@Override
	public int hashCode() {
	    final int prime = 31;
	    int result = 1;
	    result = prime * result + codigo;
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
	    Oficina other = (Oficina) obj;
	    if (codigo != other.codigo)
	        return false;
	    return true;
	}
	
	@Override
	public String toString() {
	    return "Oficina [codigo=" + codigo + 
	           ", direccion=" + (direccion != null ? direccion.toString() : "null") + 
	           ", telefono=" + telefono + "]";
	}
	
}

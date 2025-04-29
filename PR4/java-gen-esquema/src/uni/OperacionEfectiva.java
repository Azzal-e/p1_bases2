package uni;

import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Entity(name= "OPERACION_EFECTIVA")
public abstract class OperacionEfectiva extends Operacion {

	// Atributos de clase
	
	@ManyToOne
	@JoinColumn(nullable = false)
	private Oficina sucursalDeOperacion;
	
	
	// Métodos de clase
	
	public OperacionEfectiva() {}
	public OperacionEfectiva(int codigo, Cuenta cuentaEmisora, Timestamp FyH, String descripcion, double cuantia) {
		super(codigo, cuentaEmisora, FyH, descripcion, cuantia);
	}
	
	public void setSucursalDeOperacion(Oficina sOp) {
		this.sucursalDeOperacion = sOp;
		if(sOp.equals(null)){
			sOp.removeOperacionEfectiva(this);
		}
		else if(!sOp.hasOperacionEfectiva(this)){
			sOp.addOperacionEfectiva(this);
		}
	}
	
	public Oficina getSucursalDeOperacion() {
		return this.sucursalDeOperacion;
	}

	@Override
	public int hashCode() {
	    return super.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
	    if (this == obj)
	        return true;
	    if (!super.equals(obj))
	        return false;
	    if (!(obj instanceof OperacionEfectiva))
	        return false;
	    return true;
	}

	@Override
	public String toString() {
	    return "OperacionEfectiva [" + super.toString() + 
	           ", sucursalDeOperacion=" + (sucursalDeOperacion != null ? sucursalDeOperacion.getCodigo() : "null") + 
	           "]";
	}
}

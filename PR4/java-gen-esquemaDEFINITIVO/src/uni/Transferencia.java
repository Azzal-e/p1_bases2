package uni;

import java.sql.Timestamp;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;

@Entity(name= "TRANSFERENCIA")
public class Transferencia extends Operacion {

	// Atributos de clase
	
	@ManyToOne( cascade = CascadeType.PERSIST)
    @JoinColumns({
        @JoinColumn(name = "prefijo_cuenta", referencedColumnName = "prefijo", nullable = false),
        @JoinColumn(name = "numeroDeCuenta_cuenta", referencedColumnName = "numeroDeCuenta", nullable = false)
    })
	private Cuenta cuentaReceptora;
	
	// Métodos de clase
	
	public Transferencia() {}
	
	public Transferencia(int codigo, Cuenta cuentaEmisora, Timestamp FyH, String descripcion, double cuantia) {
		super(codigo,cuentaEmisora, FyH, descripcion, cuantia);
	}
	
	public void setCuentaReceptora(Cuenta cR) {
		if(cR == null && this.cuentaReceptora != null) {
			this.cuentaReceptora.setSaldo(this.cuentaReceptora.getSaldo() - this.getCuantia());
		}
		this.cuentaReceptora = cR;
		if(cR != null) {
			cR.setSaldo(getCuantia() + cR.getSaldo());
		}
	}
	
	public Cuenta getCuentaReceptora() {
		return this.cuentaReceptora;
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
	    if (!(obj instanceof Transferencia))
	        return false;
	    return true;
	}
	
	@Override
	public String toString() {
	    return "Transferencia [" + super.toString() + 
	           ", cuentaReceptora=" + (cuentaReceptora != null ? cuentaReceptora.getIban() : "null") + 
	           "]";
	}

}

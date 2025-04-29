package uni;
import java.sql.Date;

import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.JoinColumn;

import java.lang.String;

@Entity(name= "CUENTA_CORRIENTE")
public class CuentaCorriente extends Cuenta {
	
	// Atributos de clase
	
	@ManyToOne(optional = false)
	@JoinColumn(nullable = false)
	private Oficina oficinaAdscrita;
	
	// Métodos de clase
	
	public CuentaCorriente() {}
	
	public CuentaCorriente (String prefijoIBAN, String numeroDeCuenta, Date fechaDeCreacion) {
		super(prefijoIBAN, numeroDeCuenta, fechaDeCreacion);
	}
	
	
	public Oficina getOficina() {
		return this.oficinaAdscrita;
	}
	
	public void setOficina(Oficina oficina) {
		this.oficinaAdscrita = oficina;
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
	    if (!(obj instanceof CuentaCorriente))
	        return false;
	    return true;
	}

	@Override
	public String toString() {
	    return "CuentaCorriente [" + super.toString() + ", oficinaAdscrita=" + 
	           oficinaAdscrita.getCodigo() + "]";
	}
}

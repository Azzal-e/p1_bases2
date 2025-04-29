package uni;
import java.sql.Date;

import javax.persistence.Entity;
import javax.persistence.Column;

import java.lang.String;

@Entity(name= "CUENTA_AHORRO")
public class CuentaAhorro extends Cuenta {

	// Atributos de clase
	
	@Column(name = "INTERES", nullable = false, precision = 5, scale = 2)
	private double interes;
	
	// Métodos de clase
	
	public CuentaAhorro() {}
	
	public CuentaAhorro(String prefijoIBAN, String numeroDeCuenta, Date fechaDeCreacion,
						double interes) {
		super(prefijoIBAN, numeroDeCuenta, fechaDeCreacion);
		
		this.interes = interes;
	}

	public void setInteres(double interes ){
		this.interes = interes;
	}
	
	public double getInteres() {
		return this.interes;
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
	    if (!(obj instanceof CuentaAhorro))
	        return false;
	    return true;
	}

	@Override
	public String toString() {
	    return "CuentaAhorro [" + super.toString() + ", interes=" + interes + "]";
	}
}
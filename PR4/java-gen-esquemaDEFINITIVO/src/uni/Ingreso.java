package uni;

import java.sql.Timestamp;

import javax.persistence.Entity;

@Entity(name= "INGRESO")
public class Ingreso extends OperacionEfectiva {

	// Atributos de clase
	
	
	
	// Métodos de clase
	
	public Ingreso() {}
	
	public Ingreso(int codigo, Cuenta cuentaEmisora, Timestamp FyH, String descripcion, double cuantia) {
		super(codigo, cuentaEmisora, FyH, descripcion, cuantia);
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
	    if (!(obj instanceof Ingreso))
	        return false;
	    return true;
	}

	@Override
    public String toString() {
        return "Ingreso [" + super.toString() + "]";
    }
}

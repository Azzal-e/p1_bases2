package uni;
import java.sql.Timestamp;

import javax.persistence.Entity;

@Entity(name= "RETIRADA")
public class Retirada extends OperacionEfectiva {

	// Atributos de clase
	
	
	
	// Métodos de clase
	
	public Retirada(int codigo, Cuenta cuentaEmisora, Timestamp FyH, String descripcion, double cuantia) {
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
	    if (!(obj instanceof Retirada))
	        return false;
	    return true;
	}

	@Override
	public String toString() {
	    return "Retirada [" + super.toString() + "]";
	}
}

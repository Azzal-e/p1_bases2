package uni;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Persistence;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;

import org.hibernate.annotations.Check;

@Entity(name= "OPERACION")
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Operacion {
	
	// Atributos de clase
	
	@EmbeddedId
	private OperacionId opId;
	
	@Column(name = "FECHAYHORAREALIZACION", nullable = false)
	private Timestamp fechaYHoraRealizacion;
	
	@Column(name = "DESCRIPCION")
	private String  descripcion;
	
	@Column(name = "CUANTIA", nullable = false, precision = 15, scale = 2)
	@Check(constraints = "CUANTIA > 0") // Anotación extra [HIBERNATE] 
	private double cuantia;
	
	
	// Métodos de clase
	
	public Operacion() {}
	
	public Operacion(int codigo, Cuenta cuentaEmisora, Timestamp FyH, String descripcion, double cuantia) {
		this.opId = new OperacionId(codigo, cuentaEmisora);
		
		this.fechaYHoraRealizacion =FyH;
		
		this.descripcion = descripcion;
		
		this.cuantia = cuantia;
		
		// Actualizar saldo de cuenta emisora
		if(this instanceof Transferencia || this instanceof Retirada) {
			cuentaEmisora.setSaldo(cuentaEmisora.getSaldo() - cuantia);
		}
		else {
			cuentaEmisora.setSaldo(cuentaEmisora.getSaldo() + cuantia);
		}
	}

	public OperacionId getOpId() {
		return opId;
	}

	public void setOpId(OperacionId opId) {
		if(opId.getCuentaEmisora() == null && this.opId.getCuentaEmisora() != null) {
			if(this instanceof Transferencia || this instanceof Retirada) {
				this.opId.getCuentaEmisora().setSaldo(this.opId.getCuentaEmisora().getSaldo() + cuantia);
			}
			else {
				this.opId.getCuentaEmisora().setSaldo(this.opId.getCuentaEmisora().getSaldo() - cuantia);
			}
		}
		this.opId = opId;
		if(!opId.getCuentaEmisora().hasOperacion(this)){
			opId.getCuentaEmisora().addOperacion(this);
			if(this instanceof Transferencia || this instanceof Retirada) {
				this.opId.getCuentaEmisora().setSaldo(this.opId.getCuentaEmisora().getSaldo() - cuantia);
			}
			else {
				this.opId.getCuentaEmisora().setSaldo(this.opId.getCuentaEmisora().getSaldo() + cuantia);
			}
			
		}
	}

	public Timestamp getFechaYHoraRealizacion() {
		return fechaYHoraRealizacion;
	}

	public void setFechaYHoraRealizacion(Timestamp fechaYHoraRealizacion) {
		this.fechaYHoraRealizacion = fechaYHoraRealizacion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public double getCuantia() {
		return cuantia;
	}

	public void setCuantia(double cuantia) {
		this.cuantia = cuantia;
	}
	
	
	@PrePersist
	@PreUpdate
	private void validacionesAdicionales() throws Exception {
		EntityManager em = Persistence.createEntityManagerFactory("UnidadPersistenciaBanquito").createEntityManager();
		// Validar el no solapamiento de clases derivadas de operacion
        if (this instanceof Transferencia) {
            if (em.find(Ingreso.class, this.getOpId()) != null || em.find(Retirada.class, this.getOpId()) != null) {
                throw new IllegalStateException("No puede haber operaciones de distinto tipo con mismo identificador");
            }
        } else if (this instanceof Ingreso) {
            if (em.find(Transferencia.class, this.getOpId()) != null || em.find(Retirada.class, this.getOpId()) != null) {
                throw new IllegalStateException("No puede haber operaciones de distinto tipo con mismo identificador");
            }
        } else if (this instanceof Retirada) {
            if (em.find(Transferencia.class, this.getOpId()) != null || em.find(Ingreso.class, this.getOpId()) != null) {
                throw new IllegalStateException("No puede haber operaciones de distinto tipo con mismo identificador");
            }
        }
	}
	

	
	@Override
	public int hashCode() {
	    final int prime = 31;
	    int result = 1;
	    result = prime * result + ((opId == null) ? 0 : opId.hashCode());
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
	    Operacion other = (Operacion) obj;
	    if (opId == null) {
	        if (other.opId != null)
	            return false;
	    } else if (!opId.equals(other.opId))
	        return false;
	    return true;
	}
	
	@Override
	public String toString() {
	    return "Operacion [opId=" + opId + 
	           ", fechaYHoraRealizacion=" + fechaYHoraRealizacion + 
	           ", descripcion=" + descripcion + 
	           ", cuantia=" + cuantia + "]";
	}
	
}

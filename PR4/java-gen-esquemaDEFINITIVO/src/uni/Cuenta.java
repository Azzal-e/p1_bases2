package uni;
import java.sql.Date;

import java.util.HashSet;
import java.util.Set;
import java.util.ArrayList;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.PrePersist;
import javax.persistence.Column;
import javax.persistence.PreUpdate;

import org.hibernate.annotations.Check;

import javax.persistence.ManyToMany;
import javax.persistence.MappedSuperclass;
import javax.persistence.OneToMany;
import javax.persistence.Persistence;

@Entity(name= "CUENTA")
@Inheritance(strategy = InheritanceType.JOINED) // Joined evita solapamiento
public abstract class Cuenta {
	
	
	// Atributos de clase
	
	@EmbeddedId
	private IBAN iban;
	
	@Column(name = "FECHA_DE_CREACION", nullable = false)
	private Date fechaDeCreacion;
	
	@Column(name = "SALDO", nullable = false, precision = 15, scale = 2)
	@Check(constraints = "SALDO >= 0") // Anotación extra [HIBERNATE]
	private double saldo;
	
	@ManyToMany(mappedBy = "cuentas")
	private Set<Cliente> clientes = new HashSet<Cliente>();
	
	@OneToMany(mappedBy = "opId.cuentaEmisora")
	private Set<Operacion> operacionesComoEmisora = new HashSet<Operacion>();
	
	
	// Métodos de clase
	
	public Cuenta(){}
	
	public Cuenta(String prefijoIBAN, String numeroDeCuenta, Date fechaDeCreacion) {
		
		this.iban = new IBAN(prefijoIBAN, numeroDeCuenta);
		
		this.fechaDeCreacion = fechaDeCreacion;
		
		this.saldo = 0;
		
	}

	public IBAN getIban() {
		return iban;
	}

	public void setIban(IBAN iban) {
		this.iban = iban;
	}

	public Date getFechaDeCreacion() {
		return fechaDeCreacion;
	}

	public void setFechaDeCreacion(Date fechaDeCreacion) {
		this.fechaDeCreacion = fechaDeCreacion;
	}

	public double getSaldo() {
		return saldo;
	}
	
	public void setSaldo(double saldo) {
		this.saldo = saldo;
	}
	
	public void addCliente(Cliente cliente) {
		clientes.add(cliente);
		if(!cliente.hasCuenta(this)){
			cliente.addCuenta(this);
		}
	}
	
	public void removeCliente(Cliente cliente){
		clientes.remove(cliente);
		if(cliente.hasCuenta(this)){
			cliente.removeCuenta(this);
		}
	}

	public boolean hasCliente(Cliente cliente){
		return clientes.contains(cliente);
	}
	
	public void addOperacion(Operacion o) {
		operacionesComoEmisora.add(o);
		if(!o.getOpId().getCuentaEmisora().equals(this)){
			o.setOpId(new OperacionId(o.getOpId().getCodigo(), this));
		}
	}
	
	public void removeOperacion(Operacion o) {
		operacionesComoEmisora.remove(o);
	}

	public boolean hasOperacion(Operacion o){
		return operacionesComoEmisora.contains(o);
	}
	
	@Override
	public String toString() {
		return "Cuenta {iban :" + iban.toString() + ", fechaDeCreación: " + fechaDeCreacion + ", saldo: "+  saldo + ", operaciones: "+ operacionesComoEmisora + "}";
	}
	
	@PrePersist
	@PreUpdate
	private void validacionesAdicionales() throws Exception {
		EntityManager em = Persistence.createEntityManagerFactory("UnidadPersistenciaBanquito").createEntityManager();
		if(clientes == null || clientes.isEmpty()) { // Validar que no pueda haber cuentas sin cliente
			throw new Exception("Una cuenta debe estar al menos asociada a un cliente");
		}
		// Validar el no solapamiento de clases derivadas de cuenta (una cuenta no puede ser de ahorro y corriente a la vez)
        if (this instanceof CuentaAhorro) {
            if (em.find(CuentaCorriente.class, this.getIban()) != null) {
                throw new IllegalStateException("Ya existe una cuenta corriente con mismo IBAN que ahorro.");
            }
        } else if (this instanceof CuentaCorriente) {
            if (em.find(CuentaAhorro.class, this.getIban()) != null) {
                throw new IllegalStateException("Ya existe una cuenta ahorro con mismo IBAN que corriente.");
            }
        }
        

	}
	


	@Override
	public int hashCode() {
	    final int prime = 31;
	    int result = 1;
	    result = prime * result + ((iban == null) ? 0 : iban.hashCode());
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
	    Cuenta other = (Cuenta) obj;
	    if (iban == null) {
	        if (other.iban != null)
	            return false;
	    } else if (!iban.equals(other.iban))
	        return false;
	    return true;
	}
}

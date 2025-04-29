package uni;

import javax.persistence.Embeddable;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;

import java.io.Serializable;

@Embeddable
public class OperacionId implements Serializable {
	
	private int codigo;
	
	@ManyToOne
	@JoinColumns({
	    @JoinColumn(name = "iban_prefijo", referencedColumnName = "prefijo", nullable = false),
	    @JoinColumn(name = "iban_numeroDeCuenta", referencedColumnName = "numeroDeCuenta", nullable = false)
	})
	private Cuenta cuentaEmisora;
	
	// Métodos de clase
	
	public OperacionId() {}
	
	public OperacionId(int codigo, Cuenta cuentaEmisora){
		this.codigo = codigo;
		this.cuentaEmisora = cuentaEmisora;
	
	}

	public int getCodigo() {
		return codigo;
	}

	public void setCodigo(int codigo) {
		this.codigo = codigo;
	}

	public Cuenta getCuentaEmisora() {
		return cuentaEmisora;
	}

	public void setCuentaEmisora(Cuenta cuentaEmisora) {
		this.cuentaEmisora = cuentaEmisora;
	}
	
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        OperacionId that = (OperacionId) o;

        if (codigo != that.codigo) return false;
        return cuentaEmisora != null ? cuentaEmisora.equals(that.cuentaEmisora) : that.cuentaEmisora == null;
    }
    
    @Override
    public int hashCode() {
        int result = codigo;
        result = 31 * result + (cuentaEmisora != null ? cuentaEmisora.hashCode() : 0);
        return result;
    }
	
	@Override
	public String toString() {
	    return "OperacionId [codigo=" + codigo + 
	           ", cuentaEmisora=" + (cuentaEmisora != null ? cuentaEmisora.getIban() : "null") + 
	           "]";
	}
	
}

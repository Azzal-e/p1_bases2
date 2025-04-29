package uni;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class IBAN implements Serializable {
	
	@Column(length = 4)
	private String prefijo;
	
	@Column(length = 20)
	private String numeroDeCuenta;

	public IBAN() {
		
	}
	
	public IBAN(String prefijo, String numeroDeCuenta) {
		this.prefijo = prefijo;
		this.numeroDeCuenta = numeroDeCuenta;
	}

	public String getPrefijo() {
		return prefijo;
	}

	public void setPrefijo(String prefijo) {
		this.prefijo = prefijo;
	}

	public String getNumeroDeCuenta() {
		return numeroDeCuenta;
	}

	public void setNumeroDeCuenta(String numeroDeCuenta) {
		this.numeroDeCuenta = numeroDeCuenta;
	}
	
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof IBAN)) return false;
        IBAN iban = (IBAN) o;
        return prefijo != null && prefijo.equals(iban.prefijo) &&
               numeroDeCuenta != null && numeroDeCuenta.equals(iban.numeroDeCuenta);
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((prefijo == null) ? 0 : prefijo.hashCode());
        result = prime * result + ((numeroDeCuenta == null) ? 0 : numeroDeCuenta.hashCode());
        return result;
    }

    @Override
    public String toString() {
        return "IBAN [prefijo=" + prefijo + ", numeroDeCuenta=" + numeroDeCuenta + "]";
    }
}

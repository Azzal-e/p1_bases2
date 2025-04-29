package uni;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;
import java.math.BigDecimal;

@Embeddable
public class IBAN implements Serializable {

    @Column(name = "PREFIJOIBAN", length = 4)
    private String prefijoIBAN;

    @Column(name = "NUMEROCUENTA", length = 30)
    private String numeroDeCuenta;

    public IBAN() {}
    public IBAN(String prefijo, String numeroCuenta) {
        this.prefijoIBAN = prefijo;
        this.numeroDeCuenta = numeroCuenta;
    }
    
    public String getPrefijoIBAN() { return prefijoIBAN; }
    public void setPrefijoIBAN(String prefijoIBAN) { this.prefijoIBAN = prefijoIBAN; }
    public String getNumeroDeCuenta() { return numeroDeCuenta; }
    public void setNumeroDeCuenta(String numeroDeCuenta) { this.numeroDeCuenta = numeroDeCuenta; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        IBAN iban = (IBAN) o;
        if (!prefijoIBAN.equals(iban.prefijoIBAN)) return false;
        return numeroDeCuenta.equals(iban.numeroDeCuenta);
    }
    @Override
    public int hashCode() {
        int result = prefijoIBAN.hashCode();
        result = 31 * result + numeroDeCuenta.hashCode();
        return result;
    }
}

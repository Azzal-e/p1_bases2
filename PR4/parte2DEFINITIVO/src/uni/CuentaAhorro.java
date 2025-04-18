package uni;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;
import java.math.BigDecimal;

@Entity
@DiscriminatorValue("0")
public class CuentaAhorro extends Cuenta {

    public CuentaAhorro() {}

    public CuentaAhorro(IBAN iban, java.sql.Date fecha, BigDecimal saldo, BigDecimal interes) {
        super();
        this.setIban(iban);
        this.setFechaDeCreacion(fecha);
        this.setSaldo(saldo);
        this.setEsCuentaCorriente(false);
        this.setInteres(interes);
        this.setOficina(null);
    }
}

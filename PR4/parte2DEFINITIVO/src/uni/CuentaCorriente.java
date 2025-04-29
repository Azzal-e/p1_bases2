package uni;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;
import java.math.BigDecimal;

@Entity
@DiscriminatorValue("1")
public class CuentaCorriente extends Cuenta {

    public CuentaCorriente() {}

    public CuentaCorriente(IBAN iban, java.sql.Date fecha, java.math.BigDecimal saldo, Oficina oficina) {
        super();
        this.setIban(iban);
        this.setFechaDeCreacion(fecha);
        this.setSaldo(saldo);
        this.setEsCuentaCorriente(true);
        this.setInteres(null);
        this.setOficina(oficina);
    }
}

package uni;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;

@Embeddable
public class OperacionId implements Serializable {

    @Column(name = "CODIGO")
    private Long codigo;

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "prefijoIBAN", column = @Column(name = "PREFIJOIBAN_CUENTAEMISORA")),
        @AttributeOverride(name = "numeroDeCuenta", column = @Column(name = "NUMEROCUENTA_CUENTAEMISORA"))
    })
    private IBAN cuentaEmisora;

    // Constructor vacío
    public OperacionId() {}

    // Constructor para inicializar cuentaEmisora
    public OperacionId(IBAN cuentaEmisora) {
        this.cuentaEmisora = cuentaEmisora;
    }

    // Getters y Setters
    public Long getCodigo() { return codigo; }
    public void setCodigo(Long codigo) { this.codigo = codigo; }
    public IBAN getCuentaEmisora() { return cuentaEmisora; }
    public void setCuentaEmisora(IBAN cuentaEmisora) { this.cuentaEmisora = cuentaEmisora; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OperacionId that = (OperacionId) o;
        if (!codigo.equals(that.codigo)) return false;
        return cuentaEmisora.equals(that.cuentaEmisora);
    }

    @Override
    public int hashCode() {
        int result = (codigo != null) ? codigo.hashCode() : 0;
        result = 31 * result + cuentaEmisora.hashCode();
        return result;
    }
}

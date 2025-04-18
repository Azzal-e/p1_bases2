package uni;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;
import java.math.BigDecimal;

@Entity
@DiscriminatorValue("TRANSFERENCIA")
public class Transferencia extends Operacion {

    // Constructor vacío requerido por JPA
    public Transferencia() {}

    public Transferencia(IBAN cuentaEmisora, IBAN cuentaReceptora, java.util.Date fecha, java.math.BigDecimal cuantia, String descripcion) {
        super();
        OperacionId id = new OperacionId();
        id.setCuentaEmisora(cuentaEmisora);
        this.setOperacionId(id);
        this.setCuentaReceptora(cuentaReceptora);
        this.setFechaYHora(fecha);
        this.setCuantia(cuantia);
        this.setDescripcion(descripcion);
        this.setTipoOperacion("TRANSFERENCIA");
        this.setOficina(null);
    }
}

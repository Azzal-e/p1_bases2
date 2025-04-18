package uni;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;
import java.math.BigDecimal;

@Entity
@DiscriminatorValue("INGRESO")
public class Efectivo extends Operacion {

    public Efectivo() {}

    public Efectivo(IBAN cuentaEmisora, java.util.Date fecha, java.math.BigDecimal cuantia, String descripcion, Oficina oficina) {
        super();
        OperacionId id = new OperacionId();
        id.setCuentaEmisora(cuentaEmisora);
        this.setOperacionId(id);
        this.setCuentaReceptora(null);
        this.setFechaYHora(fecha);
        this.setCuantia(cuantia);
        this.setDescripcion(descripcion);
        this.setTipoOperacion("INGRESO");
        this.setOficina(oficina);
    }
}

// ===========================
// 5. Operacion.java
// ===========================
package uni;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;
import java.math.BigDecimal;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "OPERACION")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "TIPOOPERACION", discriminatorType = DiscriminatorType.STRING)
public abstract class Operacion {

    @EmbeddedId
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "operacion_gen")
    @GenericGenerator(name = "operacion_gen", strategy = "uni.OperacionIdGenerator")
    private OperacionId operacionId; 
    
    @Column(name = "FECHAOPERACION", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date fechaYHora;

    @Column(name = "CUANTIA", nullable = false)
    private BigDecimal cuantia;

    @Column(name = "DESCRIPCION", length = 200)
    private String descripcion;

    @Column(name = "TIPOOPERACION", nullable = false, insertable = false, updatable = false)
    private String tipoOperacion;

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "prefijoIBAN", column = @Column(name = "PREFIJOIBAN_CUENTARECEPTORA")),
        @AttributeOverride(name = "numeroDeCuenta", column = @Column(name = "NUMEROCUENTA_CUENTARECEPTORA"))
    })
    private IBAN cuentaReceptora;

    @ManyToOne
    @JoinColumn(name = "CODIGO_SUCURSAL")
    private Oficina oficina;

    public OperacionId getOperacionId() { return operacionId; }
    public void setOperacionId(OperacionId operacionId) { this.operacionId = operacionId; }
    public Date getFechaYHora() { return fechaYHora; }
    public void setFechaYHora(Date fechaYHora) { this.fechaYHora = fechaYHora; }
    public BigDecimal getCuantia() { return cuantia; }
    public void setCuantia(BigDecimal cuantia) { this.cuantia = cuantia; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public String getTipoOperacion() { return tipoOperacion; }
    public void setTipoOperacion(String tipoOperacion) { this.tipoOperacion = tipoOperacion; }
    public IBAN getCuentaReceptora() { return cuentaReceptora; }
    public void setCuentaReceptora(IBAN cuentaReceptora) { this.cuentaReceptora = cuentaReceptora; }
    public Oficina getOficina() { return oficina; }
    public void setOficina(Oficina oficina) { this.oficina = oficina; }

}

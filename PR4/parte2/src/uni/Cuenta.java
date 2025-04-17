// ===========================
// 3. Cuenta.java
// ===========================
package uni;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;
import java.math.BigDecimal;


@Entity
@Table(name = "CUENTAS")
public class Cuenta {

    @EmbeddedId
    private IBAN iban;

    @Column(name = "FECHACREACION", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date fechaDeCreacion;

    @Column(name = "SALDO", nullable = false, precision = 15, scale = 2)
    private BigDecimal saldo;

    @Column(name = "ESCUENTACORRIENTE", nullable = false)
    private boolean esCuentaCorriente;

    @Column(name = "INTERES", precision = 5, scale = 2)
    private BigDecimal interes;


    @ManyToOne
    @JoinColumn(name = "CODIGOOFICINA_ADSCRITA")
    private Oficina oficina;

    public IBAN getIban() { return iban; }
    public void setIban(IBAN iban) { this.iban = iban; }
    public Date getFechaDeCreacion() { return fechaDeCreacion; }
    public void setFechaDeCreacion(Date fechaDeCreacion) { this.fechaDeCreacion = fechaDeCreacion; }
    public BigDecimal getSaldo() { return saldo; }
    public void setSaldo(BigDecimal saldo) { this.saldo = saldo; }
    public boolean isEsCuentaCorriente() { return esCuentaCorriente; }
    public void setEsCuentaCorriente(boolean esCuentaCorriente) { this.esCuentaCorriente = esCuentaCorriente; }
    public BigDecimal getInteres() { return interes; }
    public void setInteres(BigDecimal interes) { this.interes = interes; }
    public Oficina getOficina() { return oficina; }
    public void setOficina(Oficina oficina) { this.oficina = oficina; }
}
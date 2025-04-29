// ===========================
// 1. Oficina.java (Oficina = Sucursal)
// ===========================
package uni;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;


@Entity
@Table(name = "OFICINAS")
public class Oficina {

    @Id
    @Column(name = "CODIGOOFICINA")
    private int codigoOficina;

    @Column(name = "DIRECCION", length = 200, nullable = false)
    private String direccion;

    @Column(name = "TELEFONO", length = 16, nullable = false)
    private String telefono;

    @OneToMany(mappedBy = "oficina") 
    private Set<Cuenta> cuentasAdscritas = new HashSet<>();

    @OneToMany(mappedBy = "oficina")
    private Set<Operacion> operaciones = new HashSet<>();

    public int getCodigoOficina() { return codigoOficina; }
    public void setCodigoOficina(int codigoOficina) { this.codigoOficina = codigoOficina; }
    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }



    public Set<Cuenta> getCuentasAdscritas() {
        return cuentasAdscritas;
    }

    public void setCuentasAdscritas(Set<Cuenta> cuentasAdscritas) {
        this.cuentasAdscritas = cuentasAdscritas;
    }

    
    
    public Set<Operacion> getOperaciones() {
        return operaciones;
    }

    public void setOperaciones(Set<Operacion> operaciones) {
        this.operaciones = operaciones;
    }    
}

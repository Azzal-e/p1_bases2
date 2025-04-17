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

    public int getCodigoOficina() {
        return codigoOficina;
    }

    public void setCodigoOficina(int codigoOficina) {
        this.codigoOficina = codigoOficina;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }
}

import java.util.List;
import java.util.Date;
import java.util.ArrayList;

public class CuentaCorriente extends Cuenta {
    private Oficina oficina;

    public CuentaCorriente(IBAN iban, Date fechaCreacion, Cliente titular, Oficina oficina){
        super(iban, fechaCreacion, titular);
        if (oficina == null){
            throw new IllegalArgumentException("La oficina no puede ser nula");
        }
        this.oficina = oficina;
    }

    public Oficina getOficina(){
        return this.oficina;
    }

    public void setOficina(Oficina oficina){
        if (oficina == null){
            throw new IllegalArgumentException("La oficina no puede ser nula");
        }
        this.oficina = oficina;
    }

    public String toString(){
        return super.toString() + " " + this.oficina;
    }
}

import java.util.Date;
import java.util.List;
import java.util.ArrayList;
public class Cuenta {

    private String IBAN;
    private double saldo;
    private Date fechaCreacion;
    private List<Cliente> titulares;
    
    public Cuenta(String IBAN, String tipo, Date fechaCreacion){
        this.IBAN = IBAN;
        this.saldo = 0;
        this.fechaCreacion = fechaCreacion;
        this.titulares = new ArrayList<>();
    }

    public String getIBAN(){
        return this.IBAN;
    }

    public double getSaldo(){
        return this.saldo;
    }

    public Date getFechaCreacion(){
        return this.fechaCreacion;
    }

    public List<Cliente> getTitulares(){
        return this.titulares;
    }

    public void addTitular(Cliente titular){
        if(titular != null && !this.titulares.contains(titular)){
            this.titulares.add(titular);
            titular.addCuenta(this);
        }
    }

    public void removeTitular(Cliente titular){
        if(titular != null && this.titulares.contains(titular)){
            this.titulares.remove(titular);
            titular.removeCuenta(this);
        }
    }

    public String toString(){
        return this.IBAN + " " + this.saldo + " " + this.fechaCreacion + " " + this.titulares;
    }
    
    
}

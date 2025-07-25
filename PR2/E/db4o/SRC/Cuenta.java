import java.util.Date;
import java.util.List;
import java.util.ArrayList;
public abstract class Cuenta {

    private IBAN IBAN;
    private double saldo;
    private Date fechaCreacion;
    private List<Cliente> titulares;
    private int sigCodigoOperacion;

    public Cuenta(IBAN IBAN, Date fechaCreacion, Cliente titular){
        if (IBAN == null || fechaCreacion == null){
            throw new IllegalArgumentException("Los parametros no pueden ser nulos");
        }
        else if (titular == null){
            throw new IllegalArgumentException("Cada cuenta debe tener al menos un titular");
        }
        else if (IBAN.getIBAN().length() > 34){
            throw new IllegalArgumentException("El IBAN no puede tener mas de 34 caracteres");
        }
        else if (fechaCreacion.after(new Date())){
            throw new IllegalArgumentException("La fecha de creacion debe ser anterior a la fecha actual");
        }
        this.IBAN = IBAN;
        this.saldo = 0;
        this.fechaCreacion = fechaCreacion;
        this.titulares = new ArrayList<>();
        this.addTitular(titular);
        this.sigCodigoOperacion = 0;
        
    }

    public IBAN getIBAN(){
        return this.IBAN;
    }

    public void setIBAN(IBAN IBAN){
        if (IBAN == null){
            throw new IllegalArgumentException("El IBAN no puede ser nulo");
        }
        this.IBAN = IBAN;
    }

    public double getSaldo(){
        return this.saldo;
    }

    public Date getFechaCreacion(){
        return this.fechaCreacion;
    }

    public void setFechaCreacion(Date fechaCreacion){
        if (fechaCreacion == null){
            throw new IllegalArgumentException("La fecha de creacion no puede ser nula");
        }
        else if (fechaCreacion.after(new Date())){
            throw new IllegalArgumentException("La fecha de creacion debe ser anterior a la fecha actual");
        }
        this.fechaCreacion = fechaCreacion;
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

    public void actualizarSaldo(double cantidad){
        this.saldo += cantidad;
    }

    public int asignarCodigoOperacion(){
        this.sigCodigoOperacion++;
        return this.sigCodigoOperacion - 1;
    }

    @Override
    public String toString(){
        // Evitar imprimir la lista de titulares de manera recursiva
        String titularesString = titulares != null ? titulares.size() + " titulares" : "Sin titulares";
        return "Cuenta [IBAN=" + IBAN + ", Saldo=" + saldo + ", Titulares=" + titularesString + "]";
    }
}

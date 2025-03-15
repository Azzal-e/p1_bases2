import java.util.Date;

public class CuentaAhorro extends Cuenta {
    private double interes;

    public CuentaAhorro(IBAN iban, Date fechaCreacion, Cliente titular, double interes){
        super(iban, fechaCreacion, titular);
        if (interes < 0){
            throw new IllegalArgumentException("El interes no puede ser negativo");
        }
        else if(interes > 100000 || interes < 0){
            throw new IllegalArgumentException("El interes no puede ser mayor que 100000 o menor que 0");
        }
        this.interes = interes;
    }

    public double getInteres(){
        return this.interes;
    }

    public void setInteres(double interes){
        if (interes < 0){
            throw new IllegalArgumentException("El interes no puede ser negativo");
        }
        else if(interes > 100000 || interes < 0){
            throw new IllegalArgumentException("El interes no puede ser mayor que 100000 o menor que 0");
        }
        this.interes = interes;
    }

    public void actualizarSaldo(){
        this.actualizarSaldo(this.getSaldo() * this.getInteres() / 100);
    }

    public String toString(){
        return super.toString() + " " + this.interes;
    }

}

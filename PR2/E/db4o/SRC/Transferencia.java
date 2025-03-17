import java.util.Date;
public class Transferencia extends Operacion {
    private Cuenta cuentaReceptora;

    public Transferencia(IBAN IBAN_cuentaEmisora, Date fechaYHora, double cuantia, String descripcion, Cuenta cuentaEmisora, Cuenta cuentaReceptora){
        super(IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, cuentaEmisora);
        if (cuentaReceptora == null){
            throw new IllegalArgumentException("La cuenta receptora no puede ser nula");
        }
        else if (cuentaEmisora.getIBAN().equals(cuentaReceptora.getIBAN())){
            throw new IllegalArgumentException("La cuenta emisora y la cuenta receptora no pueden ser la misma");
        }
        this.cuentaReceptora = cuentaReceptora;
        this.cuantia = cuantia;
        this.getCuentaEmisora().actualizarSaldo(-cuantia);
        this.getCuentaReceptora().actualizarSaldo(cuantia);
    }

    public void setCuantia(double cuantia){
        if (cuantia < 0){
            throw new IllegalArgumentException("La cuantia no puede ser negativa");
        }
        this.cuantia = cuantia;
        double difCuantia = cuantia - this.getCuantia();
        this.getCuentaEmisora().actualizarSaldo(-difCuantia);
        this.getCuentaReceptora().actualizarSaldo(difCuantia);
    }

    public Cuenta getCuentaReceptora(){
        return this.cuentaReceptora;
    }


    public void destruirOperacion(){
        this.getCuentaEmisora().actualizarSaldo(this.getCuantia());
        this.getCuentaReceptora().actualizarSaldo(-this.getCuantia());
    }

    public String toString(){  
        return super.toString() + " " + this.cuentaReceptora;
    }
}

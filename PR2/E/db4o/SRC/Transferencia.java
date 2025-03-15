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
    }

    public Cuenta getCuentaReceptora(){
        return this.cuentaReceptora;
    }

    public void actualizarSaldo(){
        this.getCuentaEmisora().actualizarSaldo(-this.getCuantia());
        this.getCuentaReceptora().actualizarSaldo(this.getCuantia());
    }

    public void destruirOperacion(){
        this.getCuentaEmisora().actualizarSaldo(this.getCuantia());
        this.getCuentaReceptora().actualizarSaldo(-this.getCuantia());
    }

    public String toString(){  
        return super.toString() + " " + this.cuentaReceptora;
    }
}

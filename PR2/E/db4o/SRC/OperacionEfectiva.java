import java.util.Date;

enum TipoOperacion {
    INGRESO,
    RETIRADA,
}
public class OperacionEfectiva extends Operacion {
    private Oficina oficina;
    private TipoOperacion tipoOperacion;

    public OperacionEfectiva(IBAN IBAN_cuentaEmisora, Date fechaYHora, double cuantia, String descripcion, Cuenta cuentaEmisora, Oficina oficina, TipoOperacion tipoOperacion){
        super(IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, cuentaEmisora);
        if (oficina == null || tipoOperacion == null){
            throw new IllegalArgumentException("Los parametros no pueden ser nulos");
        }
        this.oficina = oficina;
        this.tipoOperacion = tipoOperacion;
        if (tipoOperacion == TipoOperacion.INGRESO){
            cuentaEmisora.actualizarSaldo(cuantia);
        }
        else if (tipoOperacion == TipoOperacion.RETIRADA){
            if (cuentaEmisora.getSaldo() < cuantia){
                throw new IllegalArgumentException("No hay suficiente saldo en la cuenta");
            }
            cuentaEmisora.actualizarSaldo(-cuantia);
        }
    }

    public Oficina getOficina(){
        return this.oficina;
    }

    public TipoOperacion getTipoOperacion(){
        return this.tipoOperacion;
    }

    public void setOficina(Oficina oficina){
        if (oficina == null){
            throw new IllegalArgumentException("La oficina no puede ser nula");
        }
        this.oficina = oficina;
    }

    public void setTipoOperacion(TipoOperacion tipoOperacion){
        if (tipoOperacion == null){
            throw new IllegalArgumentException("El tipo de operacion no puede ser nulo");
        }
        this.tipoOperacion = tipoOperacion;
        if (tipoOperacion == TipoOperacion.INGRESO){
            this.getCuentaEmisora().actualizarSaldo(2*this.getCuantia());
        }
        else if (tipoOperacion == TipoOperacion.RETIRADA){
            this.getCuentaEmisora().actualizarSaldo(-2*this.getCuantia());
        }
    }

    public void destruirOperacion(){
        if(this.tipoOperacion == TipoOperacion.INGRESO){
            this.getCuentaEmisora().actualizarSaldo(-this.getCuantia());
        }
        else if (this.tipoOperacion == TipoOperacion.RETIRADA){
            this.getCuentaEmisora().actualizarSaldo(this.getCuantia());
        }
    }
    public String toString(){
        return super.toString() + " " + this.oficina + " " + this.tipoOperacion;
    }
}

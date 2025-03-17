import java.util.Date;
public abstract class Operacion {
    private int codigoOperacion;
    private IBAN IBAN_cuentaEmisora;
    private Date fechaYHora;
    protected double cuantia;
    private String descripcion;
    private Cuenta cuentaEmisora;

    public Operacion(IBAN IBAN_cuentaEmisora, Date fechaYHora, double cuantia, String descripcion, Cuenta cuentaEmisora){
        if (IBAN_cuentaEmisora == null || fechaYHora == null || cuentaEmisora == null){
            throw new IllegalArgumentException("Los parametros no pueden ser nulos");
        }
        else if (cuantia < 0){
            throw new IllegalArgumentException("La cuantia no puede ser negativa");
        }
        else if ( descripcion != null && descripcion.length() > 200){
            throw new IllegalArgumentException("La descripcion no puede tener mas de 200 caracteres");
        }
        else if (fechaYHora.after(new Date())){
            throw new IllegalArgumentException("La fecha y hora no puede ser posterior a la fecha actual");
        }
        else if (fechaYHora.before(cuentaEmisora.getFechaCreacion())){
            throw new IllegalArgumentException("La fecha y hora no puede ser anterior a la fecha de creacion de la cuenta");
        }
        else if (IBAN_cuentaEmisora != cuentaEmisora.getIBAN()){
            throw new IllegalArgumentException("El IBAN de la cuenta emisora no es consistente.");
        }
        this.codigoOperacion = cuentaEmisora.asignarCodigoOperacion();
        this.IBAN_cuentaEmisora = IBAN_cuentaEmisora;
        this.fechaYHora = fechaYHora;
        this.cuantia = cuantia;
        this.descripcion = descripcion;
        this.cuentaEmisora = cuentaEmisora;
        cuentaEmisora.addOperacion(this);
    }

    public int getCodigoOperacion(){
        return this.codigoOperacion;
    }

    public void setCodigoOperacion(int codigoOperacion){
        if (codigoOperacion < 0){
            throw new IllegalArgumentException("El codigo de operacion no puede ser negativo");
        }
        this.codigoOperacion = codigoOperacion;
    }

    public IBAN getIBAN_cuentaEmisora(){
        return this.IBAN_cuentaEmisora;
    }

    public void setIBAN_cuentaEmisora(IBAN IBAN_cuentaEmisora){
        if (IBAN_cuentaEmisora == null){
            throw new IllegalArgumentException("El IBAN de la cuenta emisora no puede ser nulo");
        }
        this.IBAN_cuentaEmisora = IBAN_cuentaEmisora;
    }

    public Date getFechaYHora(){
        return this.fechaYHora;
    }

    public void setFechaYHora(Date fechaYHora){
        if (fechaYHora == null){
            throw new IllegalArgumentException("La fecha y hora no puede ser nula");
        }
        else if (fechaYHora.after(new Date())){
            throw new IllegalArgumentException("La fecha y hora no puede ser posterior a la fecha actual");
        }
        else if (fechaYHora.before(cuentaEmisora.getFechaCreacion())){
            throw new IllegalArgumentException("La fecha y hora no puede ser anterior a la fecha de creacion de la cuenta");
        }
        this.fechaYHora = fechaYHora;
    }

    public double getCuantia(){
        return this.cuantia;
    }

    public String getDescripcion(){
        return this.descripcion;
    }

    public void setDescripcion(String descripcion){
        if (descripcion != null && descripcion.length() > 200){
            throw new IllegalArgumentException("La descripcion no puede tener mas de 200 caracteres");
        }
        this.descripcion = descripcion;
    }

    public Cuenta getCuentaEmisora(){
        return this.cuentaEmisora;
    }

}

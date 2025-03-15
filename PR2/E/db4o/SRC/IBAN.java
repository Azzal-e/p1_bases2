public class IBAN {
    private String prefijo;
    private String numeroCuenta;

    public IBAN(String prefijo, String numeroCuenta){
        this.prefijo = prefijo;
        this.numeroCuenta = numeroCuenta;
    }

    public String getPrefijo(){
        return this.prefijo;
    }

    public void setPrefijo(String prefijo){
        this.prefijo = prefijo;
    }

    public String getNumeroCuenta(){
        return this.numeroCuenta;
    }

    public void setNumeroCuenta(String numeroCuenta){
        this.numeroCuenta = numeroCuenta;
    }

    public String toIBAN(){
        return this.prefijo + this.numeroCuenta;
    }

    public boolean equals(Object obj){
        if(obj == null || !(obj instanceof IBAN)){
            return false;
        }
        IBAN iban = (IBAN) obj;
        return this.prefijo.equals(iban.getPrefijo()) && this.numeroCuenta.equals(iban.getNumeroCuenta());
    }

}

public class IBAN {
    private String prefijo;
    private String numeroCuenta;

    public IBAN(String prefijo, String numeroCuenta){
        if (prefijo == null || numeroCuenta == null){
            throw new IllegalArgumentException("Los parametros no pueden ser nulos");
        }
        else if (prefijo.length() != 4){
            throw new IllegalArgumentException("El prefijo debe tener 4 caracteres");
        }
        else if (numeroCuenta.length() > 30){
            throw new IllegalArgumentException("El numero de cuenta debe tener menos de 30 caracteres");
        }
        this.prefijo = prefijo;
        this.numeroCuenta = numeroCuenta;
    }

    public String getPrefijo(){
        return this.prefijo;
    }

    public void setPrefijo(String prefijo){
        if (prefijo == null){
            throw new IllegalArgumentException("El prefijo no puede ser nulo");
        }
        else if (prefijo.length() != 4){
            throw new IllegalArgumentException("El prefijo debe tener 4 caracteres");
        }
        this.prefijo = prefijo;
    }

    public String getNumeroCuenta(){
        return this.numeroCuenta;
    }

    public void setNumeroCuenta(String numeroCuenta){
        if (numeroCuenta == null){
            throw new IllegalArgumentException("El numero de cuenta no puede ser nulo");
        }
        else if (numeroCuenta.length() > 30){
            throw new IllegalArgumentException("El numero de cuenta debe tener menos de 30 caracteres");
        }
        this.numeroCuenta = numeroCuenta;
    }

    public String getIBAN(){
        return this.toString();
    }

    public void setIBAN(String prefijo, String numeroCuenta){
        if (prefijo == null || numeroCuenta == null){
            throw new IllegalArgumentException("Los parametros no pueden ser nulos");
        }
        else if (prefijo.length() != 4){
            throw new IllegalArgumentException("El prefijo debe tener 4 caracteres");
        }
        else if (numeroCuenta.length() > 30){
            throw new IllegalArgumentException("El numero de cuenta debe tener menos de 30 caracteres");
        }
        this.prefijo = prefijo;
        this.numeroCuenta = numeroCuenta;
    }

    public String toString(){
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

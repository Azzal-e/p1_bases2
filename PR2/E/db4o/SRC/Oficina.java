public class Oficina {
    private int codigoOficina;
    private String direccion;
    private String telefono;

    public Oficina(int codigoOficina, String direccion, String telefono){
        if (direccion == null || telefono == null){
            throw new IllegalArgumentException("Los parametros no pueden ser nulos");
        }
        else if (codigoOficina < 0 || codigoOficina > 9999){
            throw new IllegalArgumentException("El codigo de oficina debe estar entre 0 y 9999");
        }
        else if (direccion.length() > 100){
            throw new IllegalArgumentException("La direccion no puede tener mas de 100 caracteres");
        }
        else if (telefono.length() > 16){
            throw new IllegalArgumentException("El telefono no puede tener mas de 16 caracteres");
        }
        this.codigoOficina = codigoOficina;
        this.direccion = direccion;
        this.telefono = telefono;
    }

    public int getCodigoOficina(){
        return this.codigoOficina;
    }

    public void setCodigoOficina(int codigoOficina){
        if (codigoOficina < 0 || codigoOficina > 9999){
            throw new IllegalArgumentException("El codigo de oficina debe estar entre 0 y 9999");
        }
        this.codigoOficina = codigoOficina;
    }


    public String getDireccion(){
        return this.direccion;
    }

    public void setDireccion(String direccion){
        if (direccion == null){
            throw new IllegalArgumentException("La direccion no puede ser nula");
        }
        else if (direccion.length() > 100){
            throw new IllegalArgumentException("La direccion no puede tener mas de 100 caracteres");
        }
        this.direccion = direccion;
    }

    public String getTelefono(){
        return this.telefono;
    }
    
    public void setTelefono(String telefono){
        if (telefono == null){
            throw new IllegalArgumentException("El telefono no puede ser nulo");
        }
        else if (telefono.length() > 16){
            throw new IllegalArgumentException("El telefono no puede tener mas de 16 caracteres");
        }
        this.telefono = telefono;
    }

    public String toString(){
        return this.codigoOficina + " " + this.direccion + " " + this.telefono;
    }
}

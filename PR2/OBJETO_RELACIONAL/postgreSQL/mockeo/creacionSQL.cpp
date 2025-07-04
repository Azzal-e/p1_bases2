#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <filesystem>
#include <map>
#include <algorithm>
#include <algorithm>

using namespace std;
namespace fs = std::filesystem;

vector<string> split(const string& line, char delimiter) {
    vector<string> tokens;
    stringstream ss(line);
    string token;
    while (getline(ss, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

string trim(const string &str) {
    size_t first = str.find_first_not_of(" \t\n\r");
    if (first == string::npos) return "";
    size_t last = str.find_last_not_of(" \t\n\r");
    return str.substr(first, (last - first + 1));
}

string formatearDescripcion(const string& desc) {
    if (desc.front() == '"' && desc.back() == '"') {
        return desc; // ya tiene comillas dobles
    }
    return "\"" + desc + "\""; // añadir comillas si no las tiene
}

void generarOficina() {
    ifstream csv("OFICINA.csv");
    ofstream sql("oficina.sql");
    string linea;
    getline(csv, linea);
    while (getline(csv, linea)) {
        auto datos = split(linea, ',');
        if (datos.size() < 3) continue;

        // Eliminar los espacios del número de teléfono (datos[2])
        string telefono = datos[2];
        telefono.erase(std::remove(telefono.begin(), telefono.end(), ' '), telefono.end());

        // Modificación para PostgreSQL:
        sql << "INSERT INTO oficina (codigo, direccion, telefono) VALUES ("
            << datos[0] << ", '"
            << datos[1] << "', '"
            << telefono << "');" << endl;
    }
}

#include <algorithm>  // Para std::remove

#include <algorithm>  // Para std::remove

void generarCliente() {
    ifstream csv("CLIENTE.csv");
    ofstream sql("cliente.sql");
    string linea;
    getline(csv, linea);
    while (getline(csv, linea)) {
        auto datos = split(linea, ',');
        if (datos.size() < 7) continue;

        // Eliminar el prefijo "DNI('" y el sufijo "')" del DNI
        string dni = datos[0];
        if (dni.find("DNI('") == 0 && dni.find("')") == dni.size() - 2) {
            dni = dni.substr(5, dni.size() - 7);  // Eliminar "DNI('" al principio y "')" al final
        }

        // Eliminar los espacios del número de teléfono (datos[4])
        string telefono = datos[4];
        telefono.erase(std::remove(telefono.begin(), telefono.end(), ' '), telefono.end());

        // Modificación para PostgreSQL
        sql << "INSERT INTO cliente (dni, nombre, apellidos, fechaDeNacimiento, telefono, direccion, email) VALUES ('"
            << dni << "', '"
            << datos[1] << "', '"
            << datos[2] << "', "
            << "'1990-01-01', '"  // Sustituir por la fecha real si fuera necesario
            << telefono << "', '"
            << datos[5] << "', '"
            << datos[6] << "');" << endl;
    }
}
void generarCuentasEspecializadas() {
    ifstream cuenta_csv("CUENTA.csv");
    ifstream corriente_csv("CUENTACORRIENTE.csv");
    ifstream ahorro_csv("CUENTAAHORRO.csv");
    ofstream corriente_sql("cuentacorriente.sql");
    ofstream ahorro_sql("cuentaahorro.sql");

    map<string, vector<string>> cuentas;
    string linea;

    // Desactivar triggers antes de insertar
    corriente_sql << "-- Desactivar los triggers antes de las inserciones" << endl;
    corriente_sql << "ALTER TABLE cuenta DISABLE TRIGGER trigger_bloquear_insercion_cuenta;" << endl;
    corriente_sql << "ALTER TABLE Cuenta DISABLE TRIGGER trigger_cuenta_con_titular;" << endl;
    corriente_sql << "ALTER TABLE CuentaCorriente DISABLE TRIGGER trigger_cuenta_corriente_con_titular;" << endl;
    corriente_sql << "ALTER TABLE CuentaAhorro DISABLE TRIGGER trigger_cuenta_ahorro_con_titular;" << endl;

    ahorro_sql << "-- Desactivar los triggers antes de las inserciones" << endl;
    ahorro_sql << "ALTER TABLE cuenta DISABLE TRIGGER trigger_bloquear_insercion_cuenta;" << endl;
    ahorro_sql << "ALTER TABLE Cuenta DISABLE TRIGGER trigger_cuenta_con_titular;" << endl;
    ahorro_sql << "ALTER TABLE CuentaCorriente DISABLE TRIGGER trigger_cuenta_corriente_con_titular;" << endl;
    ahorro_sql << "ALTER TABLE CuentaAhorro DISABLE TRIGGER trigger_cuenta_ahorro_con_titular;" << endl;

    // Función para eliminar DNI('...') y dejar solo el valor del DNI
    auto quitarDNI = [](const string& dniCompleto) -> string {
        size_t inicio = dniCompleto.find('\'') + 1;
        size_t fin = dniCompleto.rfind('\'');
        return dniCompleto.substr(inicio, fin - inicio);
    };

    // Función para generar el IBAN como tipo compuesto
    auto generarIBAN = [](const string& prefijo, const string& numeroCuenta) -> string {
        return "ROW('" + prefijo + "', '" + numeroCuenta + "')";
    };

    // Función para comprobar si el codigoOficina existe, y si no, asignar un valor por defecto (por ejemplo, 9999)
    auto obtenerCodigoOficina = [](const string& codigoOficina) -> string {
        return "(SELECT CASE WHEN EXISTS (SELECT 1 FROM oficina WHERE codigo = " + codigoOficina + ") THEN " + codigoOficina + " ELSE 8999 END)";
    };

    // Leer CUENTA.csv y almacenar en un mapa
    getline(cuenta_csv, linea);
    while (getline(cuenta_csv, linea)) {
        auto datos = split(linea, ',');
        if (datos.size() < 5) continue;
        string clave = datos[0] + datos[1]; // Prefijo IBAN + Número cuenta
        cuentas[clave] = datos;
    }

    // Procesar CUENTACORRIENTE.csv
    getline(corriente_csv, linea);
    while (getline(corriente_csv, linea)) {
        auto datos = split(linea, ',');
        if (datos.size() < 3) continue;
        string clave = datos[0] + datos[1];

        if (cuentas.find(clave) == cuentas.end()) continue; // Evitar errores si no existe la cuenta

        auto cuenta = cuentas[clave];
        string dni = quitarDNI(cuenta[4]); // Aplicar la función para quitar DNI('...')

        // Modificación para PostgreSQL: Insertando el IBAN correctamente como tipo compuesto
        corriente_sql << "INSERT INTO cuentacorriente (iban, fechaDeCreacion, codigoOficina) VALUES ("
                      << generarIBAN(datos[0], datos[1]) << ", "  // IBAN como tipo compuesto
                      << "DATE '" << cuenta[2] << "', "  // Fecha
                      << obtenerCodigoOficina(datos[2]) << ");\n";  // Código de oficina con verificación
    }

    // Procesar CUENTAAHORRO.csv
    getline(ahorro_csv, linea);
    while (getline(ahorro_csv, linea)) {
        auto datos = split(linea, ',');
        if (datos.size() < 3) continue;
        string clave = datos[0] + datos[1];

        if (cuentas.find(clave) == cuentas.end()) continue; // Evitar errores si no existe la cuenta

        auto cuenta = cuentas[clave];
        string dni = quitarDNI(cuenta[4]); // Aplicar la función para quitar DNI('...')

        // Modificación para PostgreSQL: Insertando el IBAN correctamente como tipo compuesto
        ahorro_sql << "INSERT INTO cuentaahorro (iban, fechaDeCreacion, interes) VALUES ("
                   << generarIBAN(datos[0], datos[1]) << ", "  // IBAN como tipo compuesto
                   << "DATE '" << cuenta[2] << "', "  // Fecha
                   << datos[2] << ");\n";  // Tipo de interés
    }

    // Reactivar triggers después de insertar
    corriente_sql << "-- Reactivar los triggers después de las inserciones" << endl;
    corriente_sql << "ALTER TABLE cuenta ENABLE TRIGGER trigger_bloquear_insercion_cuenta;" << endl;
    corriente_sql << "ALTER TABLE Cuenta ENABLE TRIGGER trigger_cuenta_con_titular;" << endl;
    corriente_sql << "ALTER TABLE CuentaCorriente ENABLE TRIGGER trigger_cuenta_corriente_con_titular;" << endl;
    corriente_sql << "ALTER TABLE CuentaAhorro ENABLE TRIGGER trigger_cuenta_ahorro_con_titular;" << endl;

    ahorro_sql << "-- Reactivar los triggers después de las inserciones" << endl;
    ahorro_sql << "ALTER TABLE cuenta ENABLE TRIGGER trigger_bloquear_insercion_cuenta;" << endl;
    ahorro_sql << "ALTER TABLE Cuenta ENABLE TRIGGER trigger_cuenta_con_titular;" << endl;
    ahorro_sql << "ALTER TABLE CuentaCorriente ENABLE TRIGGER trigger_cuenta_corriente_con_titular;" << endl;
    ahorro_sql << "ALTER TABLE CuentaAhorro ENABLE TRIGGER trigger_cuenta_ahorro_con_titular;" << endl;
}



#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <filesystem>
#include <map>
#include <algorithm>

using namespace std;
namespace fs = std::filesystem;



void generarOperacion() {
    ifstream csv("OPERACION.csv");
    ofstream sqlOp("operacion.sql");
    ofstream sqlTrans("transferencia.sql");
    ofstream sqlEf("operacionefectiva.sql");
    string linea;
    getline(csv, linea);

    // Desactivar triggers
    sqlOp << "ALTER TABLE operacion DISABLE TRIGGER ALL;\n";
    sqlTrans << "ALTER TABLE transferencia DISABLE TRIGGER ALL;\n";
    sqlEf << "ALTER TABLE operacionefectiva DISABLE TRIGGER ALL;\n";

    while (getline(csv, linea)) {
        vector<string> datos;
        stringstream ss(linea);
        string token;
        bool dentroComillas = false;
        string campo;

        // Parsear CSV
        for (char c : linea) {
            if (c == '"') dentroComillas = !dentroComillas;
            if (c == ',' && !dentroComillas) {
                datos.push_back(campo);
                campo.clear();
            } else {
                campo += c;
            }
        }
        datos.push_back(campo);

        if (datos.size() < 10) continue;

        // 1. Ajustar descripción (200 caracteres máximo)
        string descripcion = datos[4];
        descripcion = descripcion.substr(0, 200); // Truncar a 200 caracteres
        replace(descripcion.begin(), descripcion.end(), '\'', ' ');
        descripcion = "'" + descripcion + "'";

        // 2. Validar código de oficina
        string codigoOficina = "8999";
        if (!datos[9].empty() && datos[9].find(';') != string::npos) {
            size_t pos = datos[9].find(';');
            codigoOficina = datos[9].substr(0, pos);
        }

        // 3. Convertir tipoOperacion a MAYÚSCULAS
        string tipoOperacion = datos[3];
        transform(tipoOperacion.begin(), tipoOperacion.end(), tipoOperacion.begin(), ::toupper);
        if (tipoOperacion != "INGRESO" && tipoOperacion != "RETIRADA") {
            tipoOperacion = "INGRESO"; // Valor por defecto si no es válido
        }
        tipoOperacion = "'" + tipoOperacion + "'";

        // Insertar en Transferencia u OperacionEfectiva
        if (datos[7] != "NULL" && datos[8] != "NULL") {
            sqlTrans << "INSERT INTO transferencia (codigo, IBAN_cuentaEmisora, IBAN_cuentaReceptora, fechaYHora, cuantia, descripcion) VALUES (\n"
                     << "  " << datos[0] << ",\n"
                     << "  ROW('" << datos[5] << "', '" << datos[6] << "')::IBAN,\n"
                     << "  ROW('" << datos[7] << "', '" << datos[8] << "')::IBAN,\n"
                     << "  TO_TIMESTAMP('" << datos[1] << "', 'YYYY-MM-DD HH24:MI:SS'),\n"
                     << "  " << datos[2] << ",\n"
                     << "  " << descripcion << "\n"
                     << ");\n";
        } else {
            sqlEf << "INSERT INTO operacionefectiva (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion, tipoOperacion, codigo_Sucursal) VALUES (\n"
                  << "  " << datos[0] << ",\n"
                  << "  ROW('" << datos[5] << "', '" << datos[6] << "')::IBAN,\n"
                  << "  TO_TIMESTAMP('" << datos[1] << "', 'YYYY-MM-DD HH24:MI:SS'),\n"
                  << "  " << datos[2] << ",\n"
                  << "  " << descripcion << ",\n"
                  << "  " << tipoOperacion << ",\n"
                  << "  " << codigoOficina << "\n"
                  << ");\n";
        }
    }

    // Reactivar triggers
    sqlOp << "ALTER TABLE operacion ENABLE TRIGGER ALL;\n";
    sqlTrans << "ALTER TABLE transferencia ENABLE TRIGGER ALL;\n";
    sqlEf << "ALTER TABLE operacionefectiva ENABLE TRIGGER ALL;\n";
}

// trigger_bloquear_insercion_operacion
int main() {

    generarOficina();
    generarCliente();
    generarCuentasEspecializadas();
    generarOperacion();

    /*
    system("docker cp types.sql postgres-db:/tmp/");
    system("docker cp tables.sql postgres-db:/tmp/");
    system("docker cp triggers.sql postgres-db:/tmp/");
    system("docker cp borrarDatos.sql postgres-db:/tmp/");
    system("docker cp ejecucion.sql postgres-db:/tmp/");
    system("docker cp consultas.sql postgres-db:/tmp/");

    system("docker cp oficina.sql postgres-db:/tmp/");
    system("docker cp cliente.sql postgres-db:/tmp/");
    system("docker cp cuenta.sql postgres-db:/tmp/");
    system("docker cp cuentacorriente.sql postgres-db:/tmp/");
    system("docker cp cuentaahorro.sql postgres-db:/tmp/");
    system("docker cp operacion.sql postgres-db:/tmp/");
    system("docker cp transferencia.sql postgres-db:/tmp/");
    system("docker cp operacionefectiva.sql postgres-db:/tmp/");
    */

    cout << "¡Todos los archivos .sql han sido generados correctamente!" << endl;
    return 0;
}

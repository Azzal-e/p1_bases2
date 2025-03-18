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




#include <fstream>
#include <vector>
#include <sstream>
#include <map>
#include <algorithm>
using namespace std;

// Función para parsear CSV
vector<string> parseCSV(const string& linea) {
    vector<string> datos;
    string campo;
    bool dentroComillas = false;

    for (char c : linea) {
        if (c == '"') {
            dentroComillas = !dentroComillas;
        } else if (c == ',' && !dentroComillas) {
            datos.push_back(campo);
            campo.clear();
        } else {
            campo += c;
        }
    }
    datos.push_back(campo);
    return datos;
}

// Cargar IBANs y fechas de creación desde CUENTA.csv
map<string, pair<string, string>> cargarDatosCuentas() { // IBAN -> (fechaCreacion, tipoCuenta)
    ifstream csv("CUENTA.csv");
    map<string, pair<string, string>> datosCuentas;
    string linea;

    getline(csv, linea); // Saltar cabecera

    while (getline(csv, linea)) {
        vector<string> datos = parseCSV(linea);
        if (datos.size() >= 5) { // Asumiendo formato: prefijoIBAN, numeroCuenta, fechaCreacion, tipoCuenta, ...
            string iban = "ROW('" + datos[0] + "','" + datos[1] + "')::IBAN";
            datosCuentas[iban] = make_pair(datos[2], datos[3]); // fechaCreacion y tipoCuenta
        }
    }
    return datosCuentas;
}

void generarOperacion() {
    auto datosCuentas = cargarDatosCuentas();
    map<string, bool> codigosInsertados;

    ifstream csv("OPERACION.csv");
    ofstream sqlTrans("transferencia.sql");
    ofstream sqlEf("operacionefectiva.sql");
    ofstream log("errores.log");

    // Desactivar TODOS los triggers temporalmente
    sqlTrans << "ALTER TABLE Operacion DISABLE TRIGGER tr
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
        sql << "INSERT INTO oficina VALUES (OFICINAUDT("
            << datos[0] << ", '"
            << datos[1] << "', "
            << "TELEFONO('" << datos[2] << "')));" << endl;
    }
}

void generarCliente() {
    ifstream csv("CLIENTE.csv");
    ofstream sql("cliente.sql");
    string linea;
    getline(csv, linea);
    while (getline(csv, linea)) {
        auto datos = split(linea, ',');
        if (datos.size() < 7) continue;
        sql << "INSERT INTO cliente VALUES (CLIENTEUDT("
            << datos[0] << ", '"  // Ya viene con DNI('...')
            << datos[1] << "', '"
            << datos[2] << "', "
            << "TO_DATE('1990-01-01', 'YYYY-MM-DD'), " // Sustituir por una fecha real si fuera necesario
            << "TELEFONO('" << datos[4] << "'), '"
            << datos[5] << "', '"
            << datos[6] << "'));" << endl;
    }
}

void generarCuenta() {
    ifstream csv("CUENTA.csv");
    ofstream sql("cuenta.sql");
    string linea;
    getline(csv, linea);

    auto quitarDNI = [](const string& dniCompleto) -> string {
        size_t inicio = dniCompleto.find('\'') + 1;
        size_t fin = dniCompleto.rfind('\'');
        return dniCompleto.substr(inicio, fin - inicio);
    };

    while (getline(csv, linea)) {
        auto datos = split(linea, ',');
        if (datos.size() < 5) continue;
        string dni = quitarDNI(datos[4]);
        sql << "INSERT INTO cuenta VALUES (CUENTAUDT(IBAN('" << datos[0] << "', '" << datos[1]
            << "'), TO_DATE('" << datos[2] << "', 'YYYY-MM-DD'), "
            << datos[3] << ", (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '" << dni << "')));" << endl;
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

    // Función para eliminar DNI('...') y dejar solo el valor del DNI
    auto quitarDNI = [](const string& dniCompleto) -> string {
        size_t inicio = dniCompleto.find('\'') + 1;
        size_t fin = dniCompleto.rfind('\'');
        return dniCompleto.substr(inicio, fin - inicio);
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

        corriente_sql << "INSERT INTO cuentacorriente VALUES (\n"
                      << "  CUENTACORRIENTEUDT(\n"
                      << "    IBAN('" << datos[0] << "', '" << datos[1] << "'),\n"
                      << "    DATE '" << cuenta[2] << "',\n"
                      << "    " << cuenta[3] << ",\n"
                      << "    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '" << dni << "'),\n"
                      << "    (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = " << datos[2] << ")\n"
                      << "  )\n"
                      << ");\n";
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

        ahorro_sql << "INSERT INTO cuentaahorro VALUES (\n"
                   << "  CUENTAAHORROUDT(\n"
                   << "    IBAN('" << datos[0] << "', '" << datos[1] << "'),\n"
                   << "    DATE '" << cuenta[2] << "',\n"
                   << "    " << cuenta[3] << ",\n"
                   << "    (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '" << dni << "'),\n"
                   << "    " << datos[2] << "\n"
                   << "  )\n"
                   << ");\n";
    }
}

void generarOperacion() {
    ifstream csv("OPERACION.csv");
    ofstream sqlOp("operacion.sql");
    ofstream sqlTrans("transferencia.sql");
    ofstream sqlEf("operacionefectiva.sql");
    string linea;
    getline(csv, linea);

    while (getline(csv, linea)) {
        vector<string> datos;
        stringstream ss(linea);
        string token;
        bool dentroComillas = false;
        string campo;

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

        // Limpiar y truncar descripción si es necesario
        string descripcion = datos[4];
        if (descripcion.front() == '"' && descripcion.back() == '"') {
            descripcion = descripcion.substr(1, descripcion.size() - 2);
        }

        if (descripcion.length() > 4000) {
            descripcion = descripcion.substr(0, 4000);
        }

        // Reemplazar comillas simples por backticks para evitar errores en SQL
        replace(descripcion.begin(), descripcion.end(), '\'', '`');
        descripcion = "'" + descripcion + "'";

        if (!datos[9].empty() && datos[9].rfind(";", datos[9].size() - 1) == datos[9].size() - 1) {
            datos[9].erase(datos[9].size() - 1);  // Elimina el último carácter (el punto y coma)
        }
        
        string refOficina = "NULL";

        if (datos[9] != "NULL" && !datos[9].empty()) {
            size_t pos = datos[9].find(';');

            string oficinaCod = datos[9].substr(0, pos);
        
            if (oficinaCod.find_first_not_of("0123456789") == string::npos) {
                refOficina = "(SELECT REF(o) FROM oficina o WHERE o.codigoOficina = " + oficinaCod + ")";
            } else {
                refOficina = "NULL";
            }
        }
        
        string tipoOperacion = (datos[3] == "NULL") ? "NULL" : "'" + datos[3] + "'";

        sqlOp << "INSERT INTO operacion VALUES (\n"
              << "  OPERACIONUDT(\n"
              << "    " << datos[0] << ",\n"
              << "    TO_TIMESTAMP('" << datos[1] << "', 'YYYY-MM-DD'),\n"
              << "    " << datos[2] << ",\n"
              << "    " << descripcion << ",\n"
              << "    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = '" << datos[5] << "' "
              << "AND c.cuenta_iban.NUMEROCUENTA = '" << datos[6] << "')\n"
              << "  )\n"
              << ");\n";

        if (datos[7] != "NULL" && datos[8] != "NULL") {
            sqlTrans << "INSERT INTO transferencia VALUES (\n"
                     << "  TRANSFERENCIAUDT(\n"
                     << "    " << datos[0] << ",\n"
                     << "    TO_TIMESTAMP('" << datos[1] << "', 'YYYY-MM-DD'),\n"
                     << "    " << datos[2] << ",\n"
                     << "    " << descripcion << ",\n"
                     << "    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = '" << datos[5] << "' "
                     << "AND c.cuenta_iban.NUMEROCUENTA = '" << datos[6] << "'),\n"
                     << "    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = '" << datos[7] << "' "
                     << "AND c.cuenta_iban.NUMEROCUENTA = '" << datos[8] << "')\n"
                     << "  )\n"
                     << ");\n";
        } else if (datos[9] != "NULL") {
                sqlEf << "INSERT INTO operacionefectiva VALUES (\n"
                      << "  OPERACIONEFECTIVAUDT(\n"
                      << "    " << datos[0] << ",\n"
                      << "    TO_TIMESTAMP('" << datos[1] << "', 'YYYY-MM-DD'),\n"
                      << "    " << datos[2] << ",\n"
                      << "    " << descripcion << ",\n"
                      << "    (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = '" << datos[5] << "'\n"
                      << "     AND c.cuenta_iban.NUMEROCUENTA = '" << datos[6] << "'),\n"
                      << "    " << tipoOperacion << ",\n"
                      << "    " << refOficina << "\n" 
                      << "  )\n"
                      << ");\n";        
        }
    }
}


int main() {

    generarOficina();
    generarCliente();
    generarCuenta();
    generarCuentasEspecializadas();
    generarOperacion();


    system("docker cp types.sql oracle-xe:/opt/oracle");
    system("docker cp tables.sql oracle-xe:/opt/oracle");
    system("docker cp triggers.sql oracle-xe:/opt/oracle");
    system("docker cp borrarDatos.sql oracle-xe:/opt/oracle");
    system("docker cp ejecucion.sql oracle-xe:/opt/oracle");
    system("docker cp consultas.sql oracle-xe:/opt/oracle");


    system("docker cp oficina.sql oracle-xe:/opt/oracle");
    system("docker cp cliente.sql oracle-xe:/opt/oracle");
    system("docker cp cuenta.sql oracle-xe:/opt/oracle");
    system("docker cp cuentacorriente.sql oracle-xe:/opt/oracle");
    system("docker cp cuentaahorro.sql oracle-xe:/opt/oracle");
    system("docker cp operacion.sql oracle-xe:/opt/oracle");
    system("docker cp transferencia.sql oracle-xe:/opt/oracle");
    system("docker cp operacionefectiva.sql oracle-xe:/opt/oracle");

    cout << "¡Todos los archivos .sql han sido generados correctamente!" << endl;
    return 0;
}

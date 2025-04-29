package uni;

import org.hibernate.engine.spi.SessionImplementor;
import org.hibernate.id.IdentifierGenerator;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class OperacionIdGenerator implements IdentifierGenerator {

    @Override
    public Serializable generate(SessionImplementor session, Object object) {
        Operacion operacion = (Operacion) object;
        Long codigo = obtenerSiguienteCodigo(session, operacion.getOperacionId().getCuentaEmisora());
        operacion.getOperacionId().setCodigo(codigo);
        return operacion.getOperacionId();
    }

    private Long obtenerSiguienteCodigo(SessionImplementor session, IBAN cuentaEmisora) {
        Connection connection = session.connection();
        try (Statement statement = connection.createStatement();
             ResultSet rs = statement.executeQuery("SELECT hibernate_sequence.NEXTVAL FROM DUAL")) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al generar código", e);
        }
        return 1L;
    }
}
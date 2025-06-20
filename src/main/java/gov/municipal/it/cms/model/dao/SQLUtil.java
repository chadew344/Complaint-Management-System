package gov.municipal.it.cms.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SQLUtil {

    public static <T>T execute(String query, Connection connection, Object... obj ) throws SQLException {
        PreparedStatement preparedStatement = connection.prepareStatement(query);

        for (int i = 0; i < obj.length; i++) {
            preparedStatement.setObject(i + 1, obj[i]);
        }

        if(query.startsWith("SELECT")) {
            ResultSet resultSet = preparedStatement.executeQuery();
            return (T)resultSet;
        }else{
            boolean rowsAffected = preparedStatement.executeUpdate()>0;
            return (T)((Boolean)rowsAffected);
        }

    }
}

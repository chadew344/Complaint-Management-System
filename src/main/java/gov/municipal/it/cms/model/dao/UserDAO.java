package gov.municipal.it.cms.model.dao;

import gov.municipal.it.cms.model.pojo.Complaint;
import gov.municipal.it.cms.model.pojo.User;
import gov.municipal.it.cms.model.pojo.UserRole;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UserDAO implements CrudDAO<User, String>{
    BasicDataSource dataSource;

    public UserDAO(BasicDataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public boolean save(User user) throws SQLException, ClassNotFoundException {
        String query =  "INSERT INTO complaints VALUE(?,?,?,?,?,?,?,?)";

        try(Connection connection = dataSource.getConnection();){
            return SQLUtil.execute(
                    query,
                    connection,
                    user.getName(),
                    user.getEmail(),
                    user.getUsername(),
                    user.getPassword(),
                    user.getRole().getDbValue(),
                    Timestamp.valueOf(user.getCreatedAt())
            );
        }

    }

    @Override
    public boolean update(User user) throws SQLException, ClassNotFoundException {
        String query = "UPDATE users\n" +
                "SET\n" +
                "    name = ?,\n" +
                "    email = ?,\n" +
                "    username = ?,\n" +
                "    password = ?,\n" +
                "    role = ?\n" +
                "WHERE id = ?";

        Connection connection = dataSource.getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.setString(1, user.getName());
        preparedStatement.setString(2, user.getEmail());
        preparedStatement.setString(3, user.getUsername());
        preparedStatement.setString(4, user.getPassword());
        preparedStatement.setString(5, user.getRole().getDbValue());
        preparedStatement.setInt(6, user.getId());


        return  preparedStatement.executeUpdate() > 0;
    }

    @Override
    public boolean delete(String pk) throws SQLException, ClassNotFoundException {
        String query = "DELETE FROM users WHERE id = ?";

        Connection connection = dataSource.getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.setString(1, pk);

        return  preparedStatement.executeUpdate() > 0;

    }

    @Override
    public List<User> getAll() throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM users";

        Connection connection = dataSource.getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        ResultSet rst = preparedStatement.executeQuery();
        List<User> users = new ArrayList<>();

        while(rst.next()) {
            users.add(getUserObject(rst));
        }

        return users;
    }

    @Override
    public Optional<User> searchById(String pk) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM users WHERE id = ?";

        try(Connection connection = dataSource.getConnection()){
            ResultSet rst = SQLUtil.execute(query, connection, pk);

            if(rst.next()) {
                return Optional.of(getUserObject(rst));
            }
        }
        return Optional.empty();
    }

    public Optional<User> search(String value, boolean isEmail) throws SQLException, ClassNotFoundException {
        String column = isEmail ? "email" : "username";
        String sql = "SELECT * FROM users WHERE " + column + " = ?";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, value);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return Optional.of(getUserObject(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Database error: " + e.getMessage(), e);
        }

        return Optional.empty();
    }

    @Override
    public Optional<String> getLastPK() throws SQLException, ClassNotFoundException {
        return Optional.empty();
    }

    @Override
    public List<String> getAllIds() throws SQLException, ClassNotFoundException {
        return List.of();
    }

    private User getUserObject(ResultSet rst) throws SQLException {
        return new User(
                rst.getInt("id"),
                rst.getString("name"),
                rst.getString("email"),
                rst.getString("username"),
                rst.getString("password"),
                UserRole.fromDbValue(rst.getString("role")),
                rst.getTimestamp("created_at").toLocalDateTime()
        );
    }

    public boolean changePassword(int id, String newHashedPassword) throws SQLException, ClassNotFoundException {
        String query = "UPDATE users SET password = ? WHERE id = ?";

        try(Connection connection = dataSource.getConnection()){
            return  SQLUtil.execute(query, connection, newHashedPassword, id);
        }
    }


}

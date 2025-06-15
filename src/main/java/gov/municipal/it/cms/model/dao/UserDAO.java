package gov.municipal.it.cms.model.dao;

import gov.municipal.it.cms.model.pojo.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class UserDAO implements CrudDAO<User, String>{
    @Override
    public boolean save(User entity) throws SQLException, ClassNotFoundException {
        return false;
    }

    @Override
    public boolean update(User entity) throws SQLException, ClassNotFoundException {
        return false;
    }

    @Override
    public boolean delete(String pk) throws SQLException, ClassNotFoundException {
        return false;
    }

    @Override
    public List<User> getAll() throws SQLException, ClassNotFoundException, IOException {
        return List.of();
    }

    @Override
    public Optional<User> searchById(String pk) throws SQLException, ClassNotFoundException, IOException {
        return Optional.empty();
    }

    @Override
    public Optional<String> getLastPK() throws SQLException, ClassNotFoundException {
        return Optional.empty();
    }

    @Override
    public List<String> getAllIds() throws SQLException, ClassNotFoundException, IOException {
        return List.of();
    }
}

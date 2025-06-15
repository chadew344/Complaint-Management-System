package gov.municipal.it.cms.model.dao;

import gov.municipal.it.cms.model.pojo.Complaint;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class ComplaintDAO implements CrudDAO<Complaint, String>{
    @Override
    public boolean save(Complaint entity) throws SQLException, ClassNotFoundException {
        return false;
    }

    @Override
    public boolean update(Complaint entity) throws SQLException, ClassNotFoundException {
        return false;
    }

    @Override
    public boolean delete(String pk) throws SQLException, ClassNotFoundException {
        return false;
    }

    @Override
    public List<Complaint> getAll() throws SQLException, ClassNotFoundException, IOException {
        return List.of();
    }

    @Override
    public Optional<Complaint> searchById(String pk) throws SQLException, ClassNotFoundException, IOException {
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

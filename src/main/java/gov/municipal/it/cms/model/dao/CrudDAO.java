package gov.municipal.it.cms.model.dao;

import gov.municipal.it.cms.model.pojo.SuperEntity;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface CrudDAO<T extends SuperEntity, ID> {
    public boolean save(T entity)throws SQLException, ClassNotFoundException;

    public boolean update(T entity) throws SQLException, ClassNotFoundException;

    public boolean delete(ID pk) throws SQLException, ClassNotFoundException;

    public List<T> getAll() throws SQLException, ClassNotFoundException;

    public Optional<T> searchById(ID pk) throws SQLException, ClassNotFoundException;

    public Optional<String>  getLastPK() throws SQLException, ClassNotFoundException;

    public List<String> getAllIds() throws SQLException, ClassNotFoundException;

}
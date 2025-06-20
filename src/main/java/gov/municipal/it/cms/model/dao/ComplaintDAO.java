package gov.municipal.it.cms.model.dao;

import gov.municipal.it.cms.model.pojo.Complaint;
import gov.municipal.it.cms.model.pojo.ComplaintStatus;
import gov.municipal.it.cms.model.pojo.PriorityType;
import gov.municipal.it.cms.model.pojo.UserRole;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.*;
import java.util.*;

public class ComplaintDAO implements CrudDAO<Complaint, String>{
    BasicDataSource dataSource;

    public ComplaintDAO(BasicDataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public boolean save(Complaint complaint) throws SQLException, ClassNotFoundException {
        String query =  "INSERT INTO complaints VALUE(?,?,?,?,?,?,?,?,?)";

        try(Connection connection = dataSource.getConnection();){
            return  SQLUtil.execute(
                        query,
                        connection,
                        complaint.getComplaintId(),
                        complaint.getSubject(),
                        complaint.getDescription(),
                        complaint.getComplaintStatus().getDbValue(),
                        complaint.getPriority().getDbValue(),
                        Timestamp.valueOf(complaint.getSubmittedAt()),
                        complaint.getAdminRemark(),
                        null,
                        complaint.getEmployeeId()
                    );
        }

    }

    @Override
    public boolean update(Complaint complaint) throws SQLException, ClassNotFoundException {
        String query = "UPDATE complaints\n" +
                "SET\n" +
                "    subject = ?,\n" +
                "    description = ?,\n" +
                "    status = ?,\n" +
                "    priority_level = ?,\n" +
                "    admin_remark = ?,\n" +
                "    admin_remarked_at = ?\n" +
                "WHERE complaint_id = ?";

        try(Connection connection = dataSource.getConnection();){
            return  SQLUtil.execute(
                    query,
                    connection,
                    complaint.getSubject(),
                    complaint.getDescription(),
                    complaint.getComplaintStatus().getDbValue(),
                    complaint.getPriority().getDbValue(),
                    complaint.getAdminRemark(),
                    Timestamp.valueOf(complaint.getAdminRemarkedAt()),
                    complaint.getComplaintId()
            );
        }

    }

    public boolean updateComplaintByUserRole(Complaint complaint, UserRole role) throws SQLException {
        String query;

        try (Connection connection = dataSource.getConnection()) {
            return switch (role) {
                case ADMIN -> {
                    query = "UPDATE complaints SET status = ?, priority_level = ?, admin_remark = ?, admin_remarked_at = ? WHERE complaint_id = ?";
                    yield SQLUtil.execute(
                            query,
                            connection,
                            complaint.getComplaintStatus().getDbValue(),
                            complaint.getPriority().getDbValue(),
                            complaint.getAdminRemark(),
                            Timestamp.valueOf(complaint.getAdminRemarkedAt()),
                            complaint.getComplaintId()
                    );
                }
                case EMPLOYEE -> {
                    query = "UPDATE complaints SET subject = ?, description = ?, priority_level = ? WHERE complaint_id = ?";
                    yield SQLUtil.execute(
                            query,
                            connection,
                            complaint.getSubject(),
                            complaint.getDescription(),
                            complaint.getPriority().getDbValue(),
                            complaint.getComplaintId()
                    );
                }
            };
        }
    }


    @Override
    public boolean delete(String pk) throws SQLException, ClassNotFoundException {
        String  query = "DELETE FROM complaints WHERE complaint_id = ?";

        try(Connection connection = dataSource.getConnection()){
            return  SQLUtil.execute(query, connection, pk);
        }

//        Connection connection = dataSource.getConnection();
//        PreparedStatement preparedStatement = connection.prepareStatement(query);
//        preparedStatement.setString(1, pk);
//
//        return  preparedStatement.executeUpdate() > 0;
    }

    @Override
    public List<Complaint> getAll() throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM complaints";

        Connection connection = dataSource.getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        ResultSet rst = preparedStatement.executeQuery();
        List<Complaint> complaints = new ArrayList<>();

        while(rst.next()) {
            complaints.add(getComplaintObject(rst));
        }

        return complaints;
    }

    public List<Complaint> getAllRoleWise(UserRole role, int employeeId) throws SQLException, ClassNotFoundException {
        StringBuilder query = new StringBuilder("SELECT * FROM complaints");

        if (role == UserRole.EMPLOYEE) {
            query.append(" WHERE employee_id = ?");
        }

        try (Connection connection = dataSource.getConnection()) {
            ResultSet rst;

            if (role == UserRole.ADMIN) {
                rst = SQLUtil.execute(query.toString(), connection);
            } else {
                rst = SQLUtil.execute(query.toString(), connection, employeeId);
            }

            List<Complaint> complaints = new ArrayList<>();

            while (rst.next()) {
                Complaint complaint = getComplaintObject(rst);
                complaints.add(complaint);
            }

            return complaints;
        }
    }

    @Override
    public Optional<Complaint> searchById(String pk) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM complaints WHERE complaint_id = ?";

        try(Connection connection = dataSource.getConnection()){
            ResultSet rst = SQLUtil.execute(query, connection, pk);
            if(rst.next()) {
                return Optional.of(getComplaintObject(rst));
            }
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

    private Complaint getComplaintObject(ResultSet rst) throws SQLException {
        Timestamp submittedAtTs = rst.getTimestamp("submitted_at");
        Timestamp adminRemarkedAtTs = rst.getTimestamp("admin_remarked_at");

        return new Complaint(
                rst.getString("complaint_id"),
                rst.getString("subject"),
                rst.getString("description"),
                ComplaintStatus.fromDbValue(rst.getString("status")),
                PriorityType.fromDbValue(rst.getString("priority_level")),
                submittedAtTs != null ? submittedAtTs.toLocalDateTime() : null,
                rst.getString("admin_remark"),
                adminRemarkedAtTs != null ? adminRemarkedAtTs.toLocalDateTime() : null,
                rst.getInt("employee_id")
        );
    }

    public List<Complaint> getRecentComplaints(UserRole role, int employeeId) throws SQLException, ClassNotFoundException {
        StringBuilder query = new StringBuilder("SELECT * FROM complaints");

        if (role == UserRole.EMPLOYEE) {
            query.append(" WHERE employee_id = ?");
        }

        query.append(" ORDER BY submitted_at DESC LIMIT 5");

        try (Connection connection = dataSource.getConnection()) {
            ResultSet rst;

            if (role == UserRole.ADMIN) {
                rst = SQLUtil.execute(query.toString(), connection);
            } else {
                rst = SQLUtil.execute(query.toString(), connection, employeeId);
            }

            List<Complaint> complaints = new ArrayList<>();

            while (rst.next()) {
                Complaint complaint = getComplaintObject(rst);
                if (complaint != null) {
                    complaints.add(complaint);
                }
            }

            return complaints;
        }
    }

    public Map<String, Integer> getComplaintCounts(UserRole role, int employeeId) throws SQLException, ClassNotFoundException {
        String query = "SELECT " +
                "COUNT(*) AS total, " +
                "SUM(IF(status = 'pending', 1, 0)) AS pending, " +
                "SUM(IF(status = 'in_progress', 1, 0)) AS in_progress, " +
                "SUM(IF(status = 'resolved', 1, 0)) AS resolved, " +
                "SUM(IF(status = 'closed', 1, 0)) AS closed " +
                "FROM complaints";

        try (Connection connection = dataSource.getConnection()) {
            ResultSet rst;

            if (role == UserRole.ADMIN) {
                rst = SQLUtil.execute(query, connection);
            } else {
                query += " WHERE employee_id = ?";
                rst = SQLUtil.execute(query, connection, employeeId);
            }

            Map<String, Integer> stats = new HashMap<>();

            if (rst.next()) {
                stats.put("total", rst.getInt("total"));
                stats.put("pending", rst.getInt("pending"));
                stats.put("in_progress", rst.getInt("in_progress"));
                stats.put("resolved", rst.getInt("resolved"));
                stats.put("closed", rst.getInt("closed"));
            }

            return stats;
        }
    }

}

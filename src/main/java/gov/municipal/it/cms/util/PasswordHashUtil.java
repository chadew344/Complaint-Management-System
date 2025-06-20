package gov.municipal.it.cms.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordHashUtil {

    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    public static boolean checkPassword(String password, String hashedPassword) {
        return BCrypt.checkpw(password, hashedPassword);
    }
}

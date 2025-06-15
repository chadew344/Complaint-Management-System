package gov.municipal.it.cms.util;

import java.util.regex.Pattern;

public class ValidationUtil {
    private static ValidationUtil validateUtil;
    private final Pattern namePattern;
    private final Pattern nicPattern;
    private final Pattern telephoneNumberPattern;
    private final Pattern emailPattern;

    private ValidationUtil() {
        namePattern = Pattern.compile("^[a-zA-Z.+=@\\-_\\s]{3,50}$");
        nicPattern = Pattern.compile("^[0-9]{9}[vVxX]||[0-9]{12}$");
        telephoneNumberPattern = Pattern.compile("^(?:0|94|\\+94|0094)?(?:(11|21|23|24|25|26|27|31|32|33|34|35|36|37|38|41|45|47|51|52|54|55|57|63|65|66|67|81|91)(0|2|3|4|5|7|9)|7(0|1|2|4|5|6|7|8)\\d)\\d{6}$");
        emailPattern = Pattern.compile("^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$");;
    }

    public static ValidationUtil getInstance() {
        return validateUtil == null ? new ValidationUtil() : validateUtil;
    }

    public enum RegexType {
        NAME, NIC, TELEPHONE, EMAIL
    }

    public boolean isValid(RegexType regexType, String input) {

        return switch (regexType) {
            case NAME-> namePattern.matcher(input).matches();
            case NIC -> nicPattern.matcher(input).matches();
            case TELEPHONE -> telephoneNumberPattern.matcher(input).matches();
            case EMAIL -> emailPattern.matcher(input).matches();
        };
    }

}

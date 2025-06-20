package gov.municipal.it.cms.exception;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginException extends Exception {
  private final String errorCode;

  public LoginException(String errorCode, String message) {
    super(message);
    this.errorCode = errorCode;
  }

  public String getErrorCode() {
    return errorCode;
  }
}

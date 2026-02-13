package tw.gov.ntak.ddqs.model;

public class User {
    private String rowguid;
    private String userId;
    private String userName;
    private String userRoleId;
    private String userEnabled;

    public String getRowguid() { return rowguid; }
    public void setRowguid(String rowguid) { this.rowguid = rowguid; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getUserRoleId() { return userRoleId; }
    public void setUserRoleId(String userRoleId) { this.userRoleId = userRoleId; }
    public String getUserEnabled() { return userEnabled; }
    public void setUserEnabled(String userEnabled) { this.userEnabled = userEnabled; }
}

package tw.gov.ntak.ddqs.model;

public class Document {
    private String rowguid;
    private String docType;
    private String docNo;
    private String idNo;
    private String sendDate;
    private String index1Name;
    private String index2List;
    private String keyList;

    public String getRowguid() { return rowguid; }
    public void setRowguid(String rowguid) { this.rowguid = rowguid; }
    public String getDocType() { return docType; }
    public void setDocType(String docType) { this.docType = docType; }
    public String getDocNo() { return docNo; }
    public void setDocNo(String docNo) { this.docNo = docNo; }
    public String getIdNo() { return idNo; }
    public void setIdNo(String idNo) { this.idNo = idNo; }
    public String getSendDate() { return sendDate; }
    public void setSendDate(String sendDate) { this.sendDate = sendDate; }
    public String getIndex1Name() { return index1Name; }
    public void setIndex1Name(String index1Name) { this.index1Name = index1Name; }
    public String getIndex2List() { return index2List; }
    public void setIndex2List(String index2List) { this.index2List = index2List; }
    public String getKeyList() { return keyList; }
    public void setKeyList(String keyList) { this.keyList = keyList; }
}

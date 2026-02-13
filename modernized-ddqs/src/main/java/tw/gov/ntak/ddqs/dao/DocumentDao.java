package tw.gov.ntak.ddqs.dao;

import tw.gov.ntak.ddqs.model.Document;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DocumentDao {
    private final DataSource dataSource;

    public DocumentDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<Document> search(String docType, String docNo, String idNo, String keyword) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("select d.rowguid, d.doc_type, d.docno, d.idno, d.send_date, i1.index1, d.index2_list, d.key_list ")
           .append("from DDQS_DOC d left join DDQS_INDEX1 i1 on d.INDEX1_idx = i1.rowguid where 1=1 ");

        List<String> params = new ArrayList<String>();
        if (notBlank(docType)) {
            sql.append(" and d.doc_type = ?");
            params.add(docType);
        }
        if (notBlank(docNo)) {
            sql.append(" and d.docno like ?");
            params.add("%" + docNo + "%");
        }
        if (notBlank(idNo)) {
            sql.append(" and d.idno like ?");
            params.add("%" + idNo + "%");
        }
        if (notBlank(keyword)) {
            sql.append(" and (d.key_list like ? or d.doc like ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        sql.append(" order by d.send_date desc");

        List<Document> result = new ArrayList<Document>();
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Document d = new Document();
                    d.setRowguid(rs.getString("rowguid"));
                    d.setDocType(rs.getString("doc_type"));
                    d.setDocNo(rs.getString("docno"));
                    d.setIdNo(rs.getString("idno"));
                    d.setSendDate(rs.getString("send_date"));
                    d.setIndex1Name(rs.getString("index1"));
                    d.setIndex2List(rs.getString("index2_list"));
                    d.setKeyList(rs.getString("key_list"));
                    result.add(d);
                }
            }
        }
        return result;
    }

    private boolean notBlank(String s) {
        return s != null && s.trim().length() > 0;
    }
}

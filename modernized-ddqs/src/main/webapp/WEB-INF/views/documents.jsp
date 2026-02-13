<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="tw.gov.ntak.ddqs.model.Document" %>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>DDQS 文件查詢</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">DDQS (Java 1.8 / MariaDB)</a>
        <a class="btn btn-outline-light" href="${pageContext.request.contextPath}/logout">登出</a>
    </div>
</nav>

<div class="container py-4">
    <form class="row g-2 mb-3" method="get" action="${pageContext.request.contextPath}/documents">
        <div class="col-md-2">
            <select class="form-select" name="docType">
                <option value="">全部類型</option>
                <option value="1">類型1</option>
                <option value="2">類型2</option>
                <option value="3">類型3</option>
            </select>
        </div>
        <div class="col-md-2"><input class="form-control" name="docNo" placeholder="文號"></div>
        <div class="col-md-2"><input class="form-control" name="idNo" placeholder="統編/身分證"></div>
        <div class="col-md-4"><input class="form-control" name="keyword" placeholder="關鍵字"></div>
        <div class="col-md-2"><button class="btn btn-primary w-100">查詢</button></div>
    </form>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="table-responsive">
        <table class="table table-striped table-bordered align-middle">
            <thead>
            <tr>
                <th>類型</th>
                <th>文號</th>
                <th>統編/身分證</th>
                <th>發文日</th>
                <th>主分類</th>
                <th>次分類</th>
                <th>關鍵字</th>
            </tr>
            </thead>
            <tbody>
            <% List<Document> documents = (List<Document>) request.getAttribute("documents");
                if (documents != null) {
                    for (Document d : documents) { %>
            <tr>
                <td><%= d.getDocType() %></td>
                <td><%= d.getDocNo() %></td>
                <td><%= d.getIdNo() %></td>
                <td><%= d.getSendDate() %></td>
                <td><%= d.getIndex1Name() %></td>
                <td><%= d.getIndex2List() %></td>
                <td><%= d.getKeyList() %></td>
            </tr>
            <%      }
                } %>
            </tbody>
        </table>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
    $(function () {
        const params = new URLSearchParams(window.location.search);
        if (params.get('docType')) {
            $('select[name="docType"]').val(params.get('docType'));
        }
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

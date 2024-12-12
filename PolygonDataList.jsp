<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="kopo.poly.dto.PolygonDataDTO" %>
<%@ page import="kopo.poly.util.CmmUtil" %>
<%
    // NoticeController 함수에서 model 객체에 저장된 값 불러오기
    List<PolygonDataDTO> rList = (List<PolygonDataDTO>) request.getAttribute("rList");

    String ssUserId = (String) session.getAttribute("SS_USER_ID");
%>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>폴리곤 사용 내역</title>
    <link rel="stylesheet" href="/css/table.css"/>
    <!-- Custom fonts for this template-->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
            href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
            rel="stylesheet">
    <!-- Custom styles for this template-->
    <link rel="stylesheet" href="/css/sb-admin-2.min.css">
    <script type="text/javascript">

        //상세보기 이동
        function doDetail(seq) {
            location.href = "/map" + "/PolygonDataInfo?nSeq=" + seq;
        }

    </script>
    <style>
        body {
            background: url('/img/non-5.png') no-repeat bottom center/cover !important;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            margin-top: 70px;
        }

        .card {
            background-color: rgba(255, 255, 255, 0.8) !important;
            position: relative;
            z-index: 1;
        }

        .logo-container {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            width: 90px;
            height: 90px;
            border-radius: 50%;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            background-color: #28343f;
            z-index: 2;
            align-items: center;
            justify-content: center;
        }

        .logo-container img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
        }

        .card-body {
            padding-top: 60px;

        }

        .container {
            max-width: 1200px;
            width: 150%;
            padding: 20px;
        }

        .btn-user {
            width: calc(50%);
            height: calc(3.0em + .75rem + 2px);
            margin: 0 auto;
            display: flex;
            justify-content: center;
            align-items: center;

        }

        .form-container {
            width: 100%;

        }

    </style>
</head>
<body>
<div class="container">
    <div class="logo-container">
        <img src="/img/logo1roatate.png" alt="Logo">
    </div>

    <div class="row justify-content-center">

        <div class="col-xl-10 col-lg-12 col-md-9">

            <div class="card o-hidden border-0 shadow-lg my-5">
                <div class="card-body p-0">
                    <div class="row">
                        <div class="col-lg-12 d-flex justify-content-center align-items-center">
                            <div class="w-100 d-flex flex-column justify-content-center" style="max-width: 90%; padding: 5rem;">
                                <div class="p-5">
                                    <div class="text-center">
                                        <h1 class="h4 text-gray-900 mb-4">생성된 폴리곤 리스트</h1>
                                    </div>
                                    <br/>
                                    <div class="divTable minimalistBlack" style="align-items: center">
                                        <div class="divTableHeading">
                                            <div class="divTableRow">
                                                <div class="divTableHead">번호</div>
                                                <div class="divTableHead">지점별 좌표</div>
                                                <div class="divTableHead">ID</div>
                                                <div class="divTableHead">중심점 좌표</div>
                                                <div class="divTableHead">설정된 이름</div>
                                                <div class="divTableHead">생성일자</div>
                                            </div>
                                        </div>
                                        <div class="divTableBody">
                                            <%
                                                for (PolygonDataDTO dto : rList) {
                                                    // 세션 값과 Polygon Name 비교
                                                    if (ssUserId != null && ssUserId.equals(dto.getPolygonName())) {
                                            %>
                                            <div class="divTableRow">
                                                <div class="divTableCell"
                                                     onclick="doDetail('<%=CmmUtil.nvl(String.valueOf(dto.getId()))%>')"><%=CmmUtil.nvl(String.valueOf(dto.getId()))%>
                                                </div>
                                                <div class="divTableCell"><%= CmmUtil.nvl(dto.getCoordinates()) %></div>
                                                <div class="divTableCell"><%= CmmUtil.nvl(String.valueOf(dto.getId())) %></div>
                                                <div class="divTableCell"><%= CmmUtil.nvl(dto.getCentroid()) %></div>
                                                <div class="divTableCell"><%= CmmUtil.nvl(dto.getPolygonName()) %></div>
                                                <div class="divTableCell"><%= CmmUtil.nvl(dto.getCreatedAt()) %></div>
                                            </div>
                                            <%
                                                    } // for 끝
                                                } // else 끝
                                            %>
                                        </div>
                                    </div>
                                    <br/>
                                    <hr/>
                                    <div class="text-center">
                                        <a id="bthIndex" type="button" class="btn btn-primary btn-user btn-block" style="cursor: pointer">홈으로</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>

</div>


</body>
</html>

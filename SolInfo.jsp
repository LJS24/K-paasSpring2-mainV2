<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="kopo.poly.util.CmmUtil" %>
<%@ page import="kopo.poly.dto.SolDTO" %>
<%
    // NoticeController 함수에서 model 객체에 저장된 값 불러오기
    SolDTO rDTO = (SolDTO) request.getAttribute("rDTO");
%>
<%@ page import="kopo.poly.dto.UserDTO" %>
<%@ page import="kopo.poly.dto.SolDTO" %>
<%
    // 세션에서 SS_USER_ID 속성을 가져옴 (로그인 여부 확인)
    String userId = CmmUtil.nvl((String) session.getAttribute("SS_USER_ID"));
    String msg = "";

    // 비정상적인 접근 체크: SS_USER_ID가 세션에 없거나 빈 값인 경우
    if (userId == null || userId.length() == 0) {
        // 경고 메시지 설정
        msg = "비정상적인 접근입니다. 화면에 접근할 수 없습니다.";

        // 경고 메시지를 alert로 출력하고 로그인 페이지로 리다이렉트
%>
<script>
    alert("<%= msg %>");
    window.location.href = "/title/login";
</script>
<%
        return; // 이후 코드 실행 방지
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>추천 내용</title>
    <link rel="stylesheet" href="/css/table.css"/>
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <!-- Custom fonts for this template-->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
            href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
            rel="stylesheet">
    <!-- Custom styles for this template-->
    <link rel="stylesheet" href="/css/sb-admin-2.min.css">
    <script>
        // Controller에서 받은 세션에 저장된 값
        const session_user_id = "<%=CmmUtil.nvl((String)session.getAttribute("SS_USER_ID"))%>";


        // 현재 글번호, 자바에서 받을 변수들은 자바스크립트 변수로 저장하면 편함
        const nSeq = "<%=CmmUtil.nvl(String.valueOf(rDTO.getId()))%>";

        // HTML로딩이 완료되고, 실행됨
        $(document).ready(function () {

            // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
            $("#btnDelete").on("click", function () {
                doDelete(); //  삭제하기 실행
            })

            // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
            $("#btnList").on("click", function () {
                location.href = "/map/SolList"; //  리스트 이동
            })

            // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
            $("#btnIndex").on("click", function () {
                location.href = "/title/index"; //  리스트 이동
            })
        })


        //삭제하기
        function doDelete() {

            if (confirm("작성한 글을 삭제하시겠습니까?")) {

                // Ajax 호출해서 글 삭제하기
                $.ajax({
                        url: "/map/SolDelete",
                        type: "post", // 전송방식은 Post
                        dataType: "json", // 전송 결과는 JSON으로 받기
                        data: {"nSeq": nSeq}, // form 태그 내 input 등 객체를 자동으로 전송할 형태로 변경하기
                        success:
                            function (json) { // 호출이 성공했다면..
                                alert(json.msg); // 메시지 띄우기
                                location.href = "/map/SolList"; // 추천 기록 리스트 이동
                            }
                    }
                )
            }
            else if (session_user_id === "") {
                alert("로그인 하시길 바랍니다.");
            }

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
            width: calc(30%);
            height: calc(3.0em + .75rem + 2px);
            margin: 0 auto;
            display: flex;
            justify-content: center;
            align-items: center;

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
                                    <h1 class="h4 text-gray-900 mb-4">추천 내용</h1>
                                </div>

                    <br/>
                    <div class="divTable minimalistBlack">
                        <div class="divTableBody" style="padding: 10px">
                            <div class="divTableRow">
                                <div class="divTableCell">생성번호
                                </div>
                                <div class="divTableCell"><%=CmmUtil.nvl(String.valueOf(rDTO.getId()))%>
                                </div>
                            </div>
                            <div class="divTableRow">
                                <div class="divTableCell">작성일시
                                </div>
                                <div class="divTableCell"><%=CmmUtil.nvl(rDTO.getCreatedAt())%>
                                </div>
                            </div>
                            <div class="divTableRow">
                                <div class="divTableCell">추천 내용
                                </div>
                                <div class="divTableCell"><%=CmmUtil.nvl(rDTO.getSolution())%>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br>
                        <div class="text-center d-flex justify-content-between">
                            <a id="btnDelete" class="btn btn-primary btn-user" style="cursor: pointer; width: 38%;">삭제하기</a>
                            &nbsp;&nbsp;&nbsp;
                            <a id="btnList" class="btn btn-primary btn-user" style="cursor: pointer; width: 38%;">목록으로</a>
                        </div>


                        <hr>
                        <div class="text-center">
                            <a class="small" id="btnIndex" style="cursor: pointer">홈으로</a>
                        </div>
                    <br>
                </div>
            </div>
        </div>
    </div>
</div>


</body>
</html>


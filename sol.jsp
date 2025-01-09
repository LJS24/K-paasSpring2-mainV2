<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="kopo.poly.dto.UserDTO" %>
<%@ page import="kopo.poly.util.CmmUtil" %>
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
    <link href="/css/sb-admin-2.min.css" rel="stylesheet">
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <title>솔루션</title>
    <!-- Custom fonts for this template-->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
            href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
            rel="stylesheet">
    <!-- Custom styles for this template-->
    <link rel="stylesheet" href="/css/sb-admin-2.min.css">
    <script type="text/javascript">

        $(document).ready(function () {

            $("#bthPolygon").on("click",function () {  // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
                location.href = "/map/polygon";
            })

            $("#bthIndex").on("click",function () {  // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
                location.href = "/title/index";
            })


        })

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
        h3{
            font-weight: bold;
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
                                        <h1 class="h4 text-gray-900 mb-4">솔루션을 확인하세요!</h1>
                                        <div class="text-center">
                                            <h6>곧 하단에 솔루션이 생성됩니다.</h6>
                                        </div>
                                        <hr>
                                        <div>
                                            <%
                                                // 세션에서 resultMessage 값을 불러옴
                                                String resultMessage = (String) session.getAttribute("resultMessage");
                                            %>
                                            <p>토양 정보: <%= resultMessage %></p>
                                        </div>

                                        <div id="adviceResult" style="color:black">
                                            <!-- ChatGPT 응답 내용이 표시됩니다 -->
                                        </div>
                                        <br>
                                        <div class="text-center">
                                            <a id="bthSol" type="button" class="btn btn-primary btn-user btn-block" style="cursor: pointer">저장하기</a>
                                        </div>

                                        <hr>
                                        <div class="text-center">
                                            <a id="bthIndex" type="button" class="small" style="cursor: pointer">홈으로</a>
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

<script>
    $(document).ready(function () {
        let resultMessage = "<%= resultMessage %>";

        if (!resultMessage) {
            alert("결과 메시지가 없습니다.");
            return;
        }

        // ChatGPT API 호출
        $.ajax({
            url: "/map/getAgricultureAdvice",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({ input: resultMessage }),
            success: function (response) {
                console.log("ChatGPT 응답:", response);
                // API 응답을 전역 변수에 저장
                apiResponse = response;
                $("#adviceResult").html("<h3>추천 내용:</h3><p>" + response + "</p>");
            },
            error: function (xhr, status, error) {
                console.error("API 호출 실패:", error);
                $("#adviceResult").html("<p>API 호출 실패: " + xhr.responseText + "</p>");
            }
        });

        // 저장 버튼 클릭 이벤트
        $("#bthSol").on("click", function () {
            // 전역 변수에 저장된 API 응답 확인
            if (!apiResponse) {
                alert("저장할 내용이 없습니다. 먼저 API를 호출하세요.");
                return;
            }

            // AJAX 호출로 API 응답 저장
            $.ajax({
                url: "/map/insertSolData", // 컨트롤러 URL
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify({ solution: apiResponse }), // API 응답 내용 전송
                success: function (response) {
                    console.log("저장 성공:", response);
                    alert("솔루션이 성공적으로 저장되었습니다.");
                },
                error: function (xhr, status, error) {
                    console.error("저장 실패:", error);
                    alert("솔루션 저장에 실패했습니다.");
                }
            });
        });
    });
</script>
</div>
</body>
</html>
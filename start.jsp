<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>FARMCARE+</title>
    <link rel="stylesheet" href="/css/startstyle.css">

    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {  // DOM이 완전히 로드된 후 실행됨
            // Start 버튼 클릭 이벤트
            $("#bthStart").on("click", function () {
                location.href = "/title/login";  // 로그인 페이지로 이동
            });
        });
    </script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body, html {
            height: 100%;
            font-family: 'Arial', sans-serif;
        }

        /* 배경 이미지 전체 페이지 하단에 적용 */
        .hero {
            height: 100vh;
            background: url('/img/non-4.png') no-repeat bottom center/cover;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        /* 반투명 상자를 화면 전체에 맞춤 */
        .overlay {
            background-color: rgba(0, 0, 0, 0.28); /* 반투명 배경 */
            width: 100vw;
            height: 100vh;
            position: absolute;
            top: 0;
            left: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* 로고, 텍스트, 버튼을 감싸는 콘텐츠 영역 */
        .hero .content {
            position: relative;
            z-index: 2;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        /* 로고 스타일 */
        .logo {
            max-width: 200px;
            display: block;
            margin-bottom: 20px;
            vertical-align: middle;
        }

        /* 텍스트 스타일 */
        h1 {
            font-size: 3rem;
            font-weight: 700;
            letter-spacing: 8px;
            margin-bottom: 15px;
            text-transform: uppercase;
        }

        p {
            font-size: 1rem;
            margin-bottom: 20px;
            color: #ffffff
        }

        /* 버튼 스타일 */
        .btn {
            padding: 12px 30px; /* 버튼 크기를 10% 증가 */
            background-color: transparent;
            color: #68f6c4;
            border-radius: 10px; /* 둥근 모서리에서 직사각형 모양으로 변경 */
            text-decoration: none;
            font-size: 1rem;
            letter-spacing: 0.6px;
            font-weight: 500;
            transition: background-color 0.3s ease, transform 0.3s ease;
            position: relative;
            z-index: 2;
            border: 2px solid #68f6c4; /* 버튼 외곽에 테두리 추가 */
        }

        .btn:hover {
            background-color: #ffffff;
            transform: scale(1.2); /* hover 시 크기 20% 확대 */
            color: #68eabc;
        }

    </style>
</head>
<body>
<div class="hero">
    <div class="overlay">
        <div class="content">
            <img src="/img/logo1nobackground.png" alt="FARMCARE+ Logo" class="logo">
            <h1>FARMCARE⁺</h1>
            <p>간단하게 받아보는 농사 솔루션</p>
            <button id="bthStart" class="btn btn-primary btn-user btn-block" style="cursor: pointer">START</button>
        </div>
    </div>
</div>

</body>
</html>

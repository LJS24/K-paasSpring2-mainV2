<%@ page import="kopo.poly.util.CmmUtil" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
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
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>지도에 땅 표시하기</title>
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=sbrq0jtk84"></script>

    <style>
        body, html {
            height: 100%;
            font-family: 'Arial', sans-serif;
        }
    </style>
</head>
<body style="background: url('/img/non-4.png') no-repeat bottom center/cover;">
    <div class="container"
        <div id="map" style="width:100%; height:80%; align-items: center; justify-content: center"></div>
        <button id="completePolygon" style="vertical-align: middle;"> 완료</button>

    <script>
        var mapOptions = {
            center: new naver.maps.LatLng(37.3595704, 127.105399),
            zoom: 10
        };

        var map = new naver.maps.Map('map', mapOptions);
        var paths = [];
        var polygon = new naver.maps.Polygon({
            map: map,
            paths: paths,
            fillColor: '#00ff37',
            fillOpacity: 0.3,
            strokeColor: '#00ff37',
            strokeOpacity: 0.6,
            strokeWeight: 3
        });

        // 지도 클릭 이벤트 리스너
        naver.maps.Event.addListener(map, 'click', function(e) {
            var clickPosition = e.coord; // 클릭 위치 좌표
            paths.push(clickPosition);   // 경로 배열에 클릭한 위치 추가
            polygon.setPaths(paths);     // 폴리곤 경로 업데이트
        });

        // 폴리곤 완성 버튼 클릭 이벤트
        document.getElementById("completePolygon").addEventListener("click", function() {
            if (paths.length > 2) {
                polygon.setPaths(paths);

                // 경로 좌표를 JSON 문자열로 변환하여 전송
                var coordinates = JSON.stringify(paths.map(function(latlng) {
                    return { lat: latlng.lat(), lng: latlng.lng() };
                }));

                $.ajax({
                    url: "/test1/createPolygon",
                    type: "POST",
                    contentType: "application/json",
                data: JSON.stringify({ polygonName: "examplePolygon", coordinates: coordinates }),
                    success: function(response) {
                        alert("폴리곤이 성공적으로 저장되었습니다.");
                        paths = []; // 폴리곤을 완성한 후 경로 초기화
                        polygon.setPaths([]);
                    },
                    error: function(xhr, status, error) {
                        console.error("Error:", error);  // 에러 로깅
                        alert("폴리곤 저장 중 오류가 발생했습니다.");
                    }
                });
            } else {
                alert("폴리곤을 완성하려면 최소 3개의 지점이 필요합니다.");
            }
        });
    </script>
</body>
</html>
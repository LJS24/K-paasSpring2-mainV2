<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kopo.poly.util.CmmUtil" %>
<%@ page import="kopo.poly.dto.UserDTO" %>
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
    <title>주소 검색, PNU 저장 및 폴리곤 그리기</title>
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=sbrq0jtk84"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=sbrq0jtk84&submodules=geocoder"></script>
    <style>





        .logo-container img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
        }



        .btn-user {
            width: calc(50%); /* 버튼의 가로 길이를 입력 필드와 동일하게 조정 */
            height: calc(3.0em + .75rem + 2px); /* 세로 높이 조정 */
            margin: 0 auto; /* 가운데 정렬 */
            display: flex; /* flexbox 사용 */
            justify-content: center; /* 수평 중앙 정렬 */
            align-items: center; /* 수직 중앙 정렬 */
        }



    </style>
</head>
<body>
<div class="search">
    <input id="address" type="text" placeholder="검색할 주소">
    <input id="searchAddress" type="button" value="주소 검색">
</div>
<div id="map" style="width:100%; height:400px;"></div>
<div>
    <button id="completePolygon">폴리곤 저장</button>
    <button id="resetPolygon">초기화</button>
</div>
<div>
    <table>
        <thead>
        <tr>
            <th>주소</th>
            <th>위도</th>
            <th>경도</th>
        </tr>
        </thead>
        <tbody id="mapList"></tbody>
    </table>
</div>

<script>
    // 지도 설정
    let mapOptions = {
        center: new naver.maps.LatLng(37.3595704, 127.105399),
        zoom: 10,
        size: new naver.maps.Size(800, 800),

    };

    let map = new naver.maps.Map('map', mapOptions);
    let paths = [];
    let polygon = new naver.maps.Polygon({
        map: map,
        paths: paths,
        fillColor: '#00ff37',
        fillOpacity: 0.3,
        strokeColor: '#00ff37',
        strokeOpacity: 0.6,
        strokeWeight: 3
    });

    let currentMarker = null; // 현재 마커 변수

    // 지도 클릭 이벤트로 폴리곤 그리기
    naver.maps.Event.addListener(map, 'click', function(e) {
        paths.push(e.coord);
        polygon.setPaths(paths);
    });

    // 주소 검색 기능
    $("#searchAddress").on("click", function() {
        let address = $("#address").val();
        if (address == "") {
            alert("주소를 입력해주세요.");
            return;
        }

        // 네이버 지도 API의 Geocoding 서비스
        naver.maps.Service.geocode({
            query: address
        }, function(status, response) {
            if (status === naver.maps.Service.Status.ERROR) {
                alert("주소 검색 중 오류가 발생했습니다.");
                return;
            }

            if (response.v2.meta.totalCount === 0) {
                alert("검색 결과가 없습니다.");
                return;
            }

            let item = response.v2.addresses[0];
            let latitude = item.y;
            let longitude = item.x;

            // 지도 이동 및 마커 표시
            map.setCenter(new naver.maps.LatLng(latitude, longitude));

            if (currentMarker) {
                currentMarker.setMap(null);
            }

            currentMarker = new naver.maps.Marker({
                map: map,
                position: new naver.maps.LatLng(latitude, longitude)
            });

            // 테이블에 결과 추가
            $("#mapList").empty();
            var mapList = "<tr><td>" + address + "</td><td>" + latitude + "</td><td>" + longitude + "</td></tr>";
            $("#mapList").append(mapList);
        });
    });

    // 폴리곤 중심 계산
    function calculateCentroid(coords) {
        let totalLat = 0, totalLng = 0;
        coords.forEach(function(coord) {
            totalLat += coord.lat();
            totalLng += coord.lng();
        });
        return { lat: totalLat / coords.length, lng: totalLng / coords.length };
    }

    // 행정안전부 API를 호출하여 도로명 주소로 PNU 코드 가져오기
    function fetchPNUCode(roadAddress, callback) {
        let confmKey = 'devU01TX0FVVEgyMDI0MTIwOTE2NDcxNjExNTMxMDc='; // 행정안전부 승인키 입력
        $.ajax({
            url: "https://business.juso.go.kr/addrlink/addrLinkApiJsonp.do",
            type: "GET",
            dataType: "jsonp",
            crossDomain: true,
            data: {
                confmKey: confmKey,
                keyword: roadAddress,
                resultType: "json",
                countPerPage: "1",
                currentPage: "1"
            },
            success: function(response) {
                console.log("행안부 API 응답:", response);
                if (response.results.juso && response.results.juso.length > 0) {
                    let juso = response.results.juso[0];
                    let roadAddr = juso.roadAddr || '도로명 주소 없음';
                    let jibunAddr = juso.jibunAddr || '지번 주소 없음';
                    let pnuCode = juso.bdMgtSn || 'PNU 코드 없음';

                    // 도로명 주소와 지번 주소를 결합하여 상세 주소 반환
                    let detailedAddress = roadAddr + (jibunAddr ? ' (' + jibunAddr + ')' : '');

                    // 도로명 주소 + 지번 주소로 PNU 코드 반환
                    callback(pnuCode, detailedAddress);
                } else {
                    alert("도로명 주소에 대한 PNU 코드를 찾을 수 없습니다.");
                }
            },
            error: function() {
                alert("행정안전부 API 호출 실패!");
            }
        });
    }

    // 폴리곤 저장 버튼 클릭 이벤트
    $('#completePolygon').on('click', function() {
        if (paths.length < 3) {
            console.error("폴리곤 경로 배열이 올바르지 않습니다: ", paths);
            alert("폴리곤은 최소 3개의 지점이 필요합니다.");
            return;
        }

        let centroid = calculateCentroid(paths);
        let centroidLatLng = new naver.maps.LatLng(centroid.lat, centroid.lng);

        naver.maps.Service.reverseGeocode({
            coords: centroidLatLng,
            orders: 'legalcode'
        }, function(status, response) {
            if (status !== naver.maps.Service.Status.OK || !response.v2.results.length) {
                console.error("Reverse Geocoding 실패:", status, response);
                alert("주소 검색 오류 발생!");
                return;
            }

            let result = response.v2.results[0];
            let roadAddress = result.region.area1.name + " " +
                result.region.area2.name + " " +
                result.region.area3.name;

            fetchPNUCode(roadAddress, function(pnuCode, detailedAddress) {
                let fullPnuCode = pnuCode || '';
                if (!fullPnuCode || fullPnuCode.length < 19) {
                    console.error("PNU 코드 오류:", fullPnuCode);
                    alert("PNU 코드가 올바르지 않습니다.");
                    return;
                }
                let SPnuCode = fullPnuCode.substring(0, 19);

                let userId = localStorage.getItem("userId");
                let coordinates = paths.map(latlng => ({ lat: latlng.lat(), lng: latlng.lng() }));

                $.ajax({
                    url: "/map/createPolygon",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        polygonName: userId,
                        coordinates: JSON.stringify(coordinates),
                        centroid: JSON.stringify(centroid),
                        pnu: SPnuCode,
                        detailedAddress: detailedAddress
                    }),
                    success: function() {
                        console.log("폴리곤 저장 성공");
                        alert("폴리곤과 PNU 코드가 저장되었습니다.");
                        resetPolygon();
                        location.href = "/map/sol"; // 로그인 성공 페이지 이동
                    },
                    error: function(xhr, status, error) {
                        console.error("AJAX 요청 오류:", xhr, status, error);
                        alert("서버 저장 중 오류 발생!");
                    }
                });
            });
        });
    });

    // 초기화 버튼 기능
    $("#resetPolygon").on("click", function() {
        resetPolygon();
    });

    function resetPolygon() {
        paths = [];
        polygon.setPaths([]);
        if (currentMarker) {
            currentMarker.setMap(null);
        }
        $("#mapList").empty();
    }
</script>
<hr>
<div class="text-center">
    <a id="bthIndex" type="button" class="btn btn-primary btn-user btn-block" style="cursor: pointer">홈으로</a>
</div>
</body>
</html>
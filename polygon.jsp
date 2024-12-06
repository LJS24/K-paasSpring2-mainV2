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
    <meta name="description" content="">
    <meta name="author" content="">
    <title>주소 검색 및 폴리곤 그리기</title>
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=sbrq0jtk84"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=sbrq0jtk84&submodules=geocoder"></script>

    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
            href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
            rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="/css/sb-admin-2.min.css" rel="stylesheet">

</head>
<body style="align-items: center; ">
<div class="search">
    <input id="address" type="text" placeholder="검색할 주소">
    <input id="submit" type="button" value="주소검색">
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
<div id="map" style="justify-content: center; align-items: center;"></div>
<div>
    <button id="completePolygon">범위 지정 완료</button>
    <button id="resetPolygon">초기화</button>
</div>


<script>
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

    // 지도 클릭 이벤트 리스너
    naver.maps.Event.addListener(map, 'click', function(e) {
        let clickPosition = e.coord; // 클릭 위치 좌표
        paths.push(clickPosition);   // 경로 배열에 클릭한 위치 추가
        polygon.setPaths(paths);     // 폴리곤 경로 업데이트
    });

    // 주소 검색 및 지도에 마커 추가
    let currentMarker = null; // 현재 마커를 저장하는 변수

    function searchAddressToCoordinate(address) {
        naver.maps.Service.geocode({
            query: address
        }, function(status, response) {
            if (status === naver.maps.Service.Status.ERROR) {
                return alert('문제가 발생하였습니다.');
            }
            if (response.v2.meta.totalCount === 0) {
                return alert('올바른 주소를 입력해주세요.');
            }

            let item = response.v2.addresses[0];
            let latitude = item.y;
            let longitude = item.x;
            let roadAddress = item.roadAddress || 'N/A';

            // 지도 이동
            map.setCenter(new naver.maps.LatLng(latitude, longitude));

            // 기존 마커 제거
            if (currentMarker) {
                currentMarker.setMap(null); // 이전 마커 삭제
            }

            // 새로운 마커 생성
            currentMarker = new naver.maps.Marker({
                map: map,
                position: new naver.maps.LatLng(latitude, longitude)
            });

            // 이전 테이블 데이터 초기화
            $('#mapList').empty();

            // 테이블에 최근 정보 추가
            let mapList = "<tr><td>" + roadAddress + "</td><td>" + latitude + "</td><td>" + longitude + "</td></tr>";
            $('#mapList').append(mapList);
        });
    }

    // 폴리곤 중심 및 넓이 계산
    function calculateCentroid(coords) {
        let totalLat = 0, totalLng = 0;
        coords.forEach(function(coord) {
            totalLat += coord.lat();
            totalLng += coord.lng();
        });
        let centLat = totalLat / coords.length;
        let centLng = totalLng / coords.length;
        return { lat: centLat, lng: centLng };
    }

    function calculateArea(coords) {
        let area = 0;
        for (let i = 0; i < coords.length; i++) {
            let j = (i + 1) % coords.length; // 다음 좌표
            area += coords[i].lng() * coords[j].lat();
            area -= coords[j].lng() * coords[i].lat();
        }
        return Math.abs(area / 2);
    }

    // 폴리곤 완성 버튼 이벤트 수정
    $('#completePolygon').on('click', function() {
        if (paths.length > 2) {
            let centroid = calculateCentroid(paths); // 중심 좌표 계산
            let area = calculateArea(paths);

            let coordinates = paths.map(function(latlng) {
                return { lat: latlng.lat(), lng: latlng.lng() };
            });

            // Reverse Geocoding 요청
            naver.maps.Service.reverseGeocode({
                coords: new naver.maps.LatLng(centroid.lat, centroid.lng), // 중심 좌표 전달
            }, function(status, response) {
                if (status !== naver.maps.Service.Status.OK) {
                    return alert('역지오코딩 중 문제가 발생하였습니다.');
                }

                let result = response.v2;
                let address = result.results[0].region.area1.name + ' ' +
                    result.results[0].region.area2.name + ' ' +
                    result.results[0].region.area3.name;

                alert('중심 좌표 주소: ' + address); // 주소 알림 표시

                // AJAX 요청 (필요시 주소 포함)
                $.ajax({
                    url: "/map/createPolygon",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        polygonName: "examplePolygon",
                        coordinates: JSON.stringify(coordinates),
                        centroid: JSON.stringify(centroid),
                        area: area,
                        address: address // 주소 추가
                    }),
                    success: function() {
                        alert("폴리곤이 저장되었습니다.");
                        paths = [];
                        polygon.setPaths([]);
                        currentMarker.setMap(null); // 이전 마커 삭제
                    },
                    error: function() {
                        alert("서버 오류가 발생했습니다.");
                    }
                });
            });
        } else {
            alert("폴리곤을 완성하려면 최소 3개의 지점이 필요합니다.");
        }
    });


    // 초기화 버튼 이벤트
    $('#resetPolygon').on('click', function() {
        alert("폴리곤이 초기화되었습니다.");
        paths = [];
        polygon.setPaths([]);
        currentMarker.setMap(null); // 이전 마커 삭제

    });

    // 주소 검색 이벤트
    $('#address').on('keydown', function(e) {
        if (e.which === 13) {
            searchAddressToCoordinate($('#address').val());
        }
    });

    $('#submit').on('click', function() {
        searchAddressToCoordinate($('#address').val());
    });


</script>
</body>
</html>


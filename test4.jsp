<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>주소 검색 및 폴리곤 그리기</title>
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=sbrq0jtk84"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=sbrq0jtk84&submodules=geocoder"></script>
</head>
<body>
<div class="search">
    <input id="address" type="text" placeholder="검색할 주소">
    <input id="submit" type="button" value="주소검색">
</div>
<div id="map" style="width:100%; height:400px;"></div>
<div>
    <button id="completePolygon">폴리곤 완료</button>
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

    // 주소 검색 및 지도에 마커 추가
    var currentMarker = null; // 현재 마커를 저장하는 변수

    function searchAddressToCoordinate(address) {
        naver.maps.Service.geocode({
            query: address
        }, function(status, response) {
            if (status === naver.maps.Service.Status.ERROR) {
                return alert('Something went wrong!');
            }
            if (response.v2.meta.totalCount === 0) {
                return alert('올바른 주소를 입력해주세요.');
            }

            var item = response.v2.addresses[0];
            var latitude = item.y;
            var longitude = item.x;
            var roadAddress = item.roadAddress || 'N/A';

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
            var mapList = "<tr><td>" + roadAddress + "</td><td>" + latitude + "</td><td>" + longitude + "</td></tr>";
            $('#mapList').append(mapList);
        });
    }

    // 폴리곤 중심 및 넓이 계산
    function calculateCentroid(coords) {
        var totalLat = 0, totalLng = 0;
        coords.forEach(function(coord) {
            totalLat += coord.lat();
            totalLng += coord.lng();
        });
        return { lat: totalLat / coords.length, lng: totalLng / coords.length };
    }

    function calculateArea(coords) {
        var area = 0;
        for (var i = 0; i < coords.length; i++) {
            var j = (i + 1) % coords.length; // 다음 좌표
            area += coords[i].lng() * coords[j].lat();
            area -= coords[j].lng() * coords[i].lat();
        }
        return Math.abs(area / 2);
    }

    // 폴리곤 완성 버튼 이벤트
    $('#completePolygon').on('click', function() {
        if (paths.length > 2) {
            var centroid = calculateCentroid(paths);
            var area = calculateArea(paths);

            var coordinates = paths.map(function(latlng) {
                return { lat: latlng.lat(), lng: latlng.lng() };
            });

            // AJAX 요청
            $.ajax({
                url: "/test1/createPolygon",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify({
                    polygonName: "examplePolygon",
                    coordinates: JSON.stringify(coordinates),
                    centroid: JSON.stringify(centroid),
                    area: area
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
        } else {
            alert("폴리곤을 완성하려면 최소 3개의 지점이 필요합니다.");
        }
    });

    // 초기화 버튼 이벤트
    $('#resetPolygon').on('click', function() {
        paths = [];
        polygon.setPaths([]);
        currentMarker.setMap(null); // 이전 마커 삭제
        alert("폴리곤이 초기화되었습니다.");
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


package kopo.poly.service.impl;

import kopo.poly.dto.PolygonDataDTO;
import kopo.poly.dto.SolDTO;
import kopo.poly.mapper.IPolygonDataMapper;
import kopo.poly.service.IPolygonDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@Service
public class PolygonDataService implements IPolygonDataService {

    @Value("${openai.api.key}")
    private String apiKey;

    private final IPolygonDataMapper polygonDataMapper;
    private final RestTemplate restTemplate = new RestTemplate();
    private static final String API_URL = "https://api.openai.com/v1/chat/completions";

    @Override
    public int insertPolygonData(PolygonDataDTO pDTO) throws Exception {
        log.info("{}.insertPolygonData Start!", this.getClass().getName());

        // DTO에서 받은 데이터를 로그로 출력
        log.info("polygonName: {}", pDTO.getPolygonName());
        log.info("coordinates: {}", pDTO.getCoordinates());
        log.info("centroid: {}", pDTO.getCentroid());
        log.info("pnu: {}", pDTO.getPnu());

        // 데이터베이스에 삽입
        int result = polygonDataMapper.insertPolygonData(pDTO);

        if (result > 0) {
            log.info("Data inserted successfully");
        } else {
            log.warn("Data insertion failed");
            // 예외를 발생시키거나 다른 처리를 할 수 있음
        }

        log.info("{}.insertPolygonData End!", this.getClass().getName());
        return result;
    }

    @Override
    @Transactional
    public int insertSolData(SolDTO pDTO) throws Exception {
        log.info("{}.insertSolData Start!", this.getClass().getName());

        // DTO에서 받은 데이터를 로그로 출력
        log.info("created_at: {}", pDTO.getCreatedAt());

        // 데이터베이스에 삽입
        int result = polygonDataMapper.insertSolData(pDTO);

        if (result > 0) {
            log.info("Data inserted successfully");
        } else {
            log.warn("Data insertion failed");
            // 예외를 발생시키거나 다른 처리를 할 수 있음
        }

        log.info("{}.insertSolData End!", this.getClass().getName());
        return result;
    }


    @Override
    public List<SolDTO> getSolList() throws Exception {

        log.info("{}.getSolList start!", this.getClass().getName());

        return polygonDataMapper.getSolList();

    }

    @Override
    public SolDTO getSolInfo(SolDTO pDTO) throws Exception {
        log.info("{}.getSolInfo start!", this.getClass().getName());

        return polygonDataMapper.getSolInfo(pDTO);
    }

    @Override
    public void deleteSolInfo(SolDTO pDTO) throws Exception {

        log.info("{}.deleteSolInfo start!", this.getClass().getName());

        polygonDataMapper.deleteSolInfo(pDTO);
    }


    // api 이식
    @Override
    public String getPnuApi(PolygonDataDTO pDTO) throws Exception {
        log.info("pnu: {}", pDTO.getPnu());

        String a = pDTO.getPnu();   // PNU값 가져오기

        StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1390802/SoilEnviron/SoilCharac/V2/getSoilCharacter"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=ENtb1EPR4xCKHiJtXlh44k83JmljoeSxz4upsKOcWnM2%2Fcp27GupaecmI%2F89ycIa%2FXoPP84AJWWgshPTfAvmOA%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("PNU_Code", "UTF-8") + "=" + URLEncoder.encode(a, "UTF-8")); /*지번코드 * PNU코드 : 19자리 (법정동코드(10자리)+산/일반(1자리)+본번(4자리)+부번(4자리))*/
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");

        BufferedReader rd;
        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();

        // XML 파싱을 위한 응답 처리
        String responseXml = sb.toString();
        String resultMessage = parseXmlResponse(responseXml);

        return resultMessage;  // 파싱된 메시지 반환
    }

    // XML 응답에서 필요한 값을 파싱하는 메소드
    private String parseXmlResponse(String xml) throws Exception {
        // XML 파싱을 위한 DocumentBuilderFactory 및 DocumentBuilder 설정
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        InputSource is = new InputSource(new StringReader(xml));
        Document doc = builder.parse(is);

        Map<String, String> A = new HashMap<>();     // 분포지형 코드표
        A.put("01", "산악지");
        A.put("02", "구릉지");
        A.put("03", "산록경사지");
        A.put("04", "곡간지");
        A.put("05", "해성평탄지");
        A.put("06", "하성평탄지");
        A.put("07", "고원지");
        A.put("08", "홍적대지");
        A.put("09", "용암류대지");
        A.put("10", "용암류평탄");
        A.put("99", "기타");

        Map<String, String> B = new HashMap<>();     // 토지이용추천 코드표
        B.put("01", "논");
        B.put("02", "밭");
        B.put("03", "과수");
        B.put("04", "초지");
        B.put("05", "임지");
        B.put("99", "기타");

        Map<String, String> C = new HashMap<>();   // 토양유형 코드표
        C.put("01", "논_보통답");
        C.put("02", "논_사질답");
        C.put("03", "논_미숙답");
        C.put("04", "논_습답");
        C.put("05", "논_염해답");
        C.put("06", "논 특이산성답");
        C.put("07", "밭_보통전");
        C.put("08", "밭_사질전");
        C.put("09", "밭_미숙전");
        C.put("10", "밭_중점전");
        C.put("11", "밭_고원전");
        C.put("12", "밭_화산회전");
        C.put("13", "임지_적황색토");
        C.put("14", "임지_갈색토");
        C.put("15", "임지_갈색삼림토");
        C.put("16", "임지_암쇄토");
        C.put("17", "임지_화산회토");
        C.put("18", "임지_화산회성암쇄토");
        C.put("19", "임지_산성갈색삼림토");
        C.put("20", "임지_적갈색토");
        C.put("99", "기타");

        Map<String, String> D = new HashMap<>();  // 침식등급 코드표

        D.put("01", "없음");
        D.put("02", "있음");
        D.put("03", "심함");
        D.put("04", "매우심함");
        D.put("99", "기타");

        Map<String, String> E = new HashMap<>();  // 유효토심 코드표

        E.put("01", "매우얕음_0-25cm");
        E.put("02", "얕음_25-50cm");
        E.put("03", "보통_50-100cm");
        E.put("04", "깊음_100cm이상");
        E.put("99", "기타");

        Map<String, String> F = new HashMap<>();     // 배수등급 코드표
        F.put("01", "매우양호");
        F.put("02", "양호");
        F.put("03", "약간양호");
        F.put("04", "약간불량");
        F.put("05", "불량");
        F.put("06", "매우불량");
        F.put("99", "기타");


        // XML에서 필요한 값을 추출 (예: PNU_Code, Soil_Color_Code, Soil_Structure_Code)
        String SoilTypeGeoCode = doc.getElementsByTagName("Soil_Type_Geo_Code").item(0).getTextContent(); // 분포지형 코드 파싱
        String SoilUseRecCode = doc.getElementsByTagName("Soil_Use_Rec_Code").item(0).getTextContent(); // 토지이용추천 코드 파싱
        String SoilTypeCode = doc.getElementsByTagName("Soil_Type_Code").item(0).getTextContent(); // 토양유형 코드 파싱

        String ErosionCode = doc.getElementsByTagName("Erosion_Code").item(0).getTextContent(); // 침식등급 코드 파싱
        String VIdsoildepCode = doc.getElementsByTagName("Vldsoildep_Code").item(0).getTextContent(); // 유효토심  코드 파싱
        String SoildraCode = doc.getElementsByTagName("Soildra_Code").item(0).getTextContent(); // 배수등급 코드 파싱

        String A1 = A.get(SoilTypeGeoCode); // 분포지형 결과값 반환
        String B1 = B.get(SoilUseRecCode);  // 토지이용추천 결과값 반환
        String C1 = C.get(SoilTypeCode);    // 토양유형 결과값 반환
        String D1 = D.get(ErosionCode); // 침식등급 결과값 반환
        String E1 = E.get(VIdsoildepCode);
        String F1 = F.get(SoildraCode); // 배수등급 결과값 반환


        // 필요한 값을 하나의 문자열로 합침
        return "<br>" +
                "분포지형:" + A1 + "<br>" +
                "토지이용추천:" + B1 + "<br>" +
                "토양유형:" + C1 + "<br>" +
                "침식등급:" + D1 + "<br>" +
                "토양깊이:" + E1 + "<br>" +
                "배수등급:" + F1;


    }


    public String getAgricultureAdvice(String resultMessage) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);

        String prompt = "다음 정보는 지금부터 농사지을 땅의 정보입니다. 이것을 기반으로 '재배하기 좋은 식물 추천, 자세한 농사 계획 작성' 을 수햏해 주세요. 수행한 내용만 보여 주세요." + resultMessage;

        Map<String, Object> requestBody = Map.of(
                "model", "gpt-3.5-turbo",
                "messages", List.of(
                        Map.of("role", "system", "content", "You are an agricultural assistant."),
                        Map.of("role", "user", "content", prompt)
                ),
                "temperature", 0.7
        );

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

        try {
            Map<String, Object> response = restTemplate.postForObject(API_URL, request, Map.class);

            // 응답 데이터 확인 및 타입 캐스팅
            if (response == null || !response.containsKey("choices")) {
                throw new RuntimeException("응답이 비어 있거나 올바르지 않습니다: " + response);
            }

            List<Map<String, Object>> choices = (List<Map<String, Object>>) response.get("choices");
            if (choices == null || choices.isEmpty()) {
                throw new RuntimeException("choices 배열이 비어 있습니다.");
            }

            Map<String, Object> firstChoice = choices.get(0);
            Map<String, Object> message = (Map<String, Object>) firstChoice.get("message");
            if (message == null || !message.containsKey("content")) {
                throw new RuntimeException("message 내용이 없습니다.");
            }

            return (String) message.get("content");

        } catch (Exception e) {
            throw new RuntimeException("ChatGPT API 호출 실패: " + e.getMessage(), e);
        }
    }
}








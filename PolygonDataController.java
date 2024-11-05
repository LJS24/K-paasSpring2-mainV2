package kopo.poly.controller;

import kopo.poly.dto.PolygonDataDTO;
import kopo.poly.mapper.IPolygonDataMapper;
import kopo.poly.service.IPolygonDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RequestMapping(value = "/test1")
@RequiredArgsConstructor
@Controller
public class PolygonDataController {

    private final IPolygonDataService PolygonDataService;

    @GetMapping(value = "test")
    public String start() {
        log.info("{}.start Start!",this.getClass().getName());
        log.info("{}.start End!",this.getClass().getName());
        return "/test1/test";
    }

    @ResponseBody
    @PostMapping(value = "createPolygon")
    public ResponseEntity<String> createPolygon(@RequestBody PolygonDataDTO pDTO) {
        try {
            int res = PolygonDataService.insertPolygonData(pDTO); // 폴리곤 데이터 삽입
            return res > 0
                    ? ResponseEntity.status(HttpStatus.CREATED).body("폴리곤이 저장되었습니다.")
                    : ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("저장 실패");
        } catch (Exception e) {
            log.error("Error occurred while creating polygon: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("에러 발생");
        }
    }
}

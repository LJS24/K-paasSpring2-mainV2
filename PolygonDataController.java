package kopo.poly.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.MsgDTO;
import kopo.poly.dto.PolygonDataDTO;


import kopo.poly.dto.SolDTO;
import kopo.poly.service.IPolygonDataService;
import kopo.poly.util.CmmUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;



import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Slf4j
@RequestMapping(value = "/map")
@RequiredArgsConstructor
@Controller
public class PolygonDataController {

    private final IPolygonDataService PolygonDataService;


    @GetMapping(value = "polygon")
    public String start() {
        log.info("{}.start Start!", this.getClass().getName());
        log.info("{}.start End!", this.getClass().getName());
        return "/map/polygon";
    }

    @GetMapping(value = "sol")
    public String ttt() {
        log.info("{}.ttt Start!",this.getClass().getName());
        log.info("{}.ttt End!",this.getClass().getName());
        return "/map/sol";
    }



    @ResponseBody
    @PostMapping(value = "createPolygon")
    public ResponseEntity<String> createPolygon(@RequestBody PolygonDataDTO pDTO,HttpServletRequest request, HttpSession session) {
        log.info("{}.createPolygon Start!",getClass().getName());
        try {
            // PNU 코드로 API 호출 후 데이터 파싱
            String resultMessage = PolygonDataService.getPnuApi(pDTO);  // getPnuApi 호출하여 필요한 정보 가져오기


            session.setAttribute("resultMessage", resultMessage);  // 세션에 저장

            log.info("파싱결과(문자로자연스럽게 반환)} : {} ",resultMessage);
            // 폴리곤 데이터 삽입
            int res = PolygonDataService.insertPolygonData(pDTO);

            // 폴리곤 저장 성공 시, CREATED 상태 반환
            if (res > 0) {
                return ResponseEntity.status(HttpStatus.CREATED)
                        .body("폴리곤이 저장되었습니다.");
            } else {
                // 저장 실패 시, INTERNAL_SERVER_ERROR 상태 반환
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body("저장 실패");
            }


        } catch (Exception e) {
            // 예외 발생 시, 에러 메시지와 함께 INTERNAL_SERVER_ERROR 상태 반환
            log.error("Error occurred while creating polygon: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("에러 발생");
        }

    }

    @GetMapping(value = "SolList")
    public String SolList(HttpSession session, ModelMap model) throws Exception {

        // 로그 찍기(추후 찍은 로그를 통해 이 함수에 접근했는지 파악하기 용이하다.)
        log.info("{}.SolList Start!", this.getClass().getName());

        // 공지사항 리스트 조회하기
        // Java 8부터 제공되는 Optional 활용하여 NPE(Null Pointer Exception) 처리
        List<SolDTO> rList = Optional.ofNullable(PolygonDataService.getSolList())
                .orElseGet(ArrayList::new);


        // 조회된 리스트 결과값 넣어주기
        model.addAttribute("rList", rList);

        // 로그 찍기(추후 찍은 로그를 통해 이 함수 호출이 끝났는지 파악하기 용이하다.)
        log.info("{}.SolList End!", this.getClass().getName());

        // 함수 처리가 끝나고 보여줄 JSP 파일명
        return "/map/SolList";

    }

    /**
     * 기록 열람하기
     */
    @GetMapping(value = "SolInfo")
    public String SolInfo(HttpServletRequest request, ModelMap model) throws Exception {

        log.info("{}.solInfo Start!", this.getClass().getName());

        String nSeq = CmmUtil.nvl(request.getParameter("nSeq"));


        log.info("nSeq : {}", nSeq);
        /*
         * 값 전달은 반드시 DTO 객체를 이용해서 처리함 전달 받은 값을 DTO 객체에 넣는다.
         */
        SolDTO pDTO = new SolDTO();
        pDTO.setId(Integer.parseInt(nSeq));

        // 상세정보 가져오기
        // Java 8부터 제공되는 Optional 활용하여 NPE(Null Pointer Exception) 처리
        SolDTO rDTO = Optional.ofNullable(PolygonDataService.getSolInfo(pDTO))
                .orElseGet(SolDTO::new);

        // 조회된 리스트 결과값 넣어주기
        model.addAttribute("rDTO", rDTO);

        log.info("{}.solInfo End!", this.getClass().getName());

        // 함수 처리가 끝나고 보여줄 JSP 파일명

        return "/map/SolInfo";
    }

    /**
     * 게시판 글 삭제
     */
    @ResponseBody
    @PostMapping(value = "SolDelete")
    public MsgDTO solDelete(HttpServletRequest request) {

        log.info("{}.SolDelete Start!", this.getClass().getName());

        String msg = ""; // 메시지 내용
        MsgDTO dto; // 결과 메시지 구조

        try {
            String nSeq = CmmUtil.nvl(request.getParameter("nSeq")); // 글번호(PK)



            log.info("nSeq : {}", nSeq);

            /*
             * 값 전달은 반드시 DTO 객체를 이용해서 처리함 전달 받은 값을 DTO 객체에 넣는다.
             */
            SolDTO pDTO = new SolDTO();
            pDTO.setId(Integer.parseInt(nSeq));

            // 게시글 삭제하기 DB
            PolygonDataService.deleteSolInfo(pDTO);

            msg = "삭제되었습니다.";

        } catch (Exception e) {
            msg = "실패하였습니다. : " + e.getMessage();
            log.info(e.toString());

        } finally {
            // 결과 메시지 전달하기
            dto = new MsgDTO();
            dto.setMsg(msg);

            log.info("{}.SolDelete End!", this.getClass().getName());

        }

        return dto;
    }

    @PostMapping("/getAgricultureAdvice")
    public ResponseEntity<String> getAgricultureAdvice(@RequestBody Map<String, String> input) {
        String resultMessage = input.get("input");
        if (resultMessage == null || resultMessage.isBlank()) {
            return ResponseEntity.badRequest().body("입력 값이 비어 있습니다.");
        }

        try {
            String advice = PolygonDataService.getAgricultureAdvice(resultMessage);
            return ResponseEntity.ok(advice);
        } catch (Exception e) {
            log.error("ChatGPT API 호출 실패: {}", e.getMessage());
            return ResponseEntity.status(500).body("API 호출 실패: " + e.getMessage());
        }
    }

    @PostMapping("/insertSolData")
    public ResponseEntity<String> insertSolData(@RequestBody SolDTO solDTO) {
        try {
            // 서비스 호출하여 데이터 저장
            PolygonDataService.insertSolData(solDTO);

            return ResponseEntity.ok("솔루션 저장 성공");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("솔루션 저장 실패: " + e.getMessage());
        }
    }




}

package kopo.poly.service;

import kopo.poly.dto.PolygonDataDTO;
import kopo.poly.dto.SolDTO;

import java.util.List;
import java.util.Map;

public interface IPolygonDataService {
    int insertPolygonData (PolygonDataDTO pDTO) throws Exception;

    int insertSolData (SolDTO pDTO) throws Exception;


    /*
    기록 리스트
 */
    List<SolDTO> getSolList() throws Exception;

    // 상세보기
    SolDTO getSolInfo(SolDTO pDTO) throws Exception;

    // 기록 삭제
    void deleteSolInfo(SolDTO pDTO) throws Exception;

    String getPnuApi(PolygonDataDTO pDTO) throws Exception;

    String getAgricultureAdvice(String input) throws Exception;

}

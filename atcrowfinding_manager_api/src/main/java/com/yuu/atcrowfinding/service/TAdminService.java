package com.yuu.atcrowfinding.service;

import com.github.pagehelper.PageInfo;
import com.yuu.atcrowfinding.bean.TAdmin;

import java.util.List;
import java.util.Map;

public interface TAdminService {


    TAdmin getAdminByLogin(Map<String, Object> param);

    PageInfo<TAdmin> listAdminPage(Map<String, Object> paramMap);

    void saveTAdmin(TAdmin admin);

    TAdmin getAdminById(Integer id);

    void updateTAdmin(TAdmin admin);

    void deleteTAdminById(Integer id);

    void deleteTAdminByBatch(List<Integer> idList);

    List<Integer> getRoleIdByAdminId(String id);

    void saveAdminAndRoleRelationship(Integer[] id, Integer adminId);

    void deleteAdminAndRoleRelationship(Integer[] id, Integer adminId);

}

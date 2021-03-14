package com.yuu.atcrowfinding.service;


import com.github.pagehelper.PageInfo;
import com.yuu.atcrowfinding.bean.TRole;

import java.util.List;
import java.util.Map;

public interface TRoleService {

    PageInfo<TRole> listRolePage(Map<String, Object> paramMap);

    void saveRole(TRole role);

    TRole getRoleById(Integer id);

    void updateRole(TRole role);

    void deleteRole(Integer id);

    List<TRole> listRoleAll();


    void saveAssignPermissionToRole(Integer roleId, List<Integer> permissionIdList);

    List<Integer> listPermissionIdByRoleId(Integer roleId);

}

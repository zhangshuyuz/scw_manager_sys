package com.yuu.atcrowfinding.service.impl;

import com.github.pagehelper.PageInfo;
import com.yuu.atcrowfinding.bean.TRole;
import com.yuu.atcrowfinding.bean.TRoleExample;
import com.yuu.atcrowfinding.bean.TRolePermissionExample;
import com.yuu.atcrowfinding.mapper.TRoleMapper;
import com.yuu.atcrowfinding.mapper.TRolePermissionMapper;
import com.yuu.atcrowfinding.service.TRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Map;

@Service
public class TRoleServiceImpl implements TRoleService {

    @Autowired
    TRoleMapper roleMapper;

    @Autowired
    TRolePermissionMapper rolePermissionMapper;

    @Override
    public PageInfo<TRole> listRolePage(Map<String, Object> paramMap) {

        String condition = (String)paramMap.get("condition");

        List<TRole> roleList = null;
        TRoleExample roleExample = new TRoleExample();
        if (StringUtils.isEmpty(condition)) {
            roleList = roleMapper.selectByExample(null);
        } else {
            roleExample.createCriteria().andNameLike("%"+ condition +"%");
            roleList = roleMapper.selectByExample(roleExample);
        }

        PageInfo<TRole> pageInfo = new PageInfo<>(roleList, 5);

        return pageInfo;

    }

    @Override
    public void saveRole(TRole role) {

        roleMapper.insertSelective(role);

    }

    @Override
    public TRole getRoleById(Integer id) {
        return roleMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateRole(TRole role) {
        roleMapper.updateByPrimaryKeySelective(role);
    }

    @Override
    public void deleteRole(Integer id) {
        roleMapper.deleteByPrimaryKey(id);
    }

    @Override
    public List<TRole> listRoleAll() {
        return roleMapper.selectByExample(null);
    }

    @Override
    public void saveAssignPermissionToRole(Integer roleId, List<Integer> permissionIdList) {
        // 先删除角色之前分配过的权限，然后重新赋予角色新的权限
        rolePermissionMapper.deleteAssignPermissionToRole(roleId);
        rolePermissionMapper.saveAssignPermissionToRole(roleId, permissionIdList);
    }

    @Override
    public List<Integer> listPermissionIdByRoleId(Integer roleId) {

        return rolePermissionMapper.listPermissionIdByRoleId(roleId);
    }


}

package com.yuu.atcrowfinding.service.impl;

import com.yuu.atcrowfinding.bean.TPermission;
import com.yuu.atcrowfinding.mapper.TPermissionMapper;
import com.yuu.atcrowfinding.service.TPermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TPermissionServiceImpl implements TPermissionService {

    @Autowired
    TPermissionMapper permissionMapper;

    @Override
    public List<TPermission> listPermissionAll() {

        return permissionMapper.selectByExample(null);

    }

    @Override
    public void savePermission(TPermission permission) {
        permissionMapper.insertSelective(permission);
    }

    @Override
    public TPermission getTPermissionById(Integer id) {
        return permissionMapper.selectByPrimaryKey(id);
    }

    @Override
    public void removeTPermissionById(Integer id) {
        permissionMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void updateTPermission(TPermission permission) {
        permissionMapper.updateByPrimaryKeySelective(permission);
    }

}

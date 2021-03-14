package com.yuu.atcrowfinding.service;

import com.yuu.atcrowfinding.bean.TPermission;

import java.util.List;

public interface TPermissionService {

    List<TPermission> listPermissionAll();

    void savePermission(TPermission permission);

    TPermission getTPermissionById(Integer id);

    void removeTPermissionById(Integer id);

    void updateTPermission(TPermission permission);

}

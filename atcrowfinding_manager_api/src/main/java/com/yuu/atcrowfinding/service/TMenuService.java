package com.yuu.atcrowfinding.service;

import com.yuu.atcrowfinding.bean.TMenu;

import java.util.List;

public interface TMenuService {

    List<TMenu> listMenuAll(); // 查询组合过父子关系后的父元素集合

    List<TMenu> listMenuAllSimple(); // 查询所有数据的集合

    void saveMenu(TMenu menu);

    TMenu getMenuById(Integer id);

    void updateMenu(TMenu menu);

    void deleteMenuById(Integer id);

}

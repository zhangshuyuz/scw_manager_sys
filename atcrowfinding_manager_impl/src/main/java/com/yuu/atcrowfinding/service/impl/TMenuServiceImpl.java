package com.yuu.atcrowfinding.service.impl;

import com.yuu.atcrowfinding.bean.TMenu;
import com.yuu.atcrowfinding.mapper.TMenuMapper;
import com.yuu.atcrowfinding.service.TMenuService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TMenuServiceImpl implements TMenuService {

    Logger log = LoggerFactory.getLogger(TMenuServiceImpl.class);

    @Autowired
    TMenuMapper menuMapper;

    @Override
    public List<TMenu> listMenuAll() {

        List<TMenu> menuList = new ArrayList<>();

        // 查询所有的菜单数据
        List<TMenu> allList = menuMapper.selectByExample(null);

        // 循环拼装
        Map<Integer, TMenu> cache = new HashMap<>();
        for (TMenu menu :
                allList) {
            if (menu.getPid() == 0) {
                menuList.add(menu);
                cache.put(menu.getId(), menu);
            }
        }
        for (TMenu menu :
                allList) {
            if (menu.getPid() != 0) {
                Integer pid = menu.getPid();
                TMenu parent = cache.get(pid);
                parent.getChildren().add(menu);
            }
        }

        log.debug("menu={}", menuList);

        return menuList;

    }

    @Override
    public List<TMenu> listMenuAllSimple() {
        return menuMapper.selectByExample(null);
    }

    @Override
    public void saveMenu(TMenu menu) {
        menuMapper.insertSelective(menu);
    }

    @Override
    public TMenu getMenuById(Integer id) {
        return menuMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateMenu(TMenu menu) {
        menuMapper.updateByPrimaryKeySelective(menu);
    }

    @Override
    public void deleteMenuById(Integer id) {
        menuMapper.deleteByPrimaryKey(id);
    }

}

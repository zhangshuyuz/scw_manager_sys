package com.yuu.atcrowfinding.controller;

import com.yuu.atcrowfinding.bean.TMenu;
import com.yuu.atcrowfinding.bean.TRole;
import com.yuu.atcrowfinding.service.TMenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class TMenuController {

    @Autowired
    TMenuService menuService;

    @RequestMapping("/menu/index")
    public String index() {

        return "/menu/index";

    }

    @ResponseBody
    @RequestMapping("/menu/loadTree")
    public List<TMenu> loadTree() {

        List<TMenu> menuList = menuService.listMenuAllSimple();

        return menuList;

    }

    @ResponseBody
    @RequestMapping("/menu/doAdd")
    public String doAdd(TMenu menu) {

        menuService.saveMenu(menu);

        return "OK";

    }

    @ResponseBody
    @RequestMapping("menu/getMenuById")
    public TMenu getMenuById(Integer id) {

        return menuService.getMenuById(id);

    }

    @ResponseBody
    @RequestMapping("/menu/doUpdate")
    public String doUpdate(TMenu menu) {

        menuService.updateMenu(menu);

        return "OK";

    }

    @ResponseBody
    @RequestMapping("/menu/doDelete")
    public String doDelete(Integer id) {

        menuService.deleteMenuById(id);

        return "OK";

    }

}

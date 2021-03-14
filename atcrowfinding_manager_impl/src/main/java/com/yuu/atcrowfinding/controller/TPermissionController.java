package com.yuu.atcrowfinding.controller;

import com.yuu.atcrowfinding.bean.TPermission;
import com.yuu.atcrowfinding.service.TPermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class TPermissionController {

    @Autowired
    TPermissionService permissionService;

    @RequestMapping("/permission/index")
    public String index() {

        return "/permission/index";
    }

    @ResponseBody
    @RequestMapping("/permission/loadTree")
    public List<TPermission> loadTree() {

        return permissionService.listPermissionAll();

    }

    @ResponseBody
    @RequestMapping("/permission/doAdd")
    public String doAdd(TPermission permission) {

        permissionService.savePermission(permission);

        return "OK";

    }

    @ResponseBody
    @RequestMapping("/permission/get")
    public TPermission get(Integer id) {
        return permissionService.getTPermissionById(id);
    }

    @ResponseBody
    @RequestMapping(value = "/permission/doDelete", method = RequestMethod.DELETE)
    public String doDelete(Integer id) {

        permissionService.removeTPermissionById(id);

        return "OK";

    }

    @ResponseBody
    @RequestMapping("/permission/doUpdate")
    public String doUpdate(TPermission permission) {

        permissionService.updateTPermission(permission);

        return "OK";

    }

}

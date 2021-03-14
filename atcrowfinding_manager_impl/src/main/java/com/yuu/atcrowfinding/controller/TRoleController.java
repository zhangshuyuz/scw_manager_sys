package com.yuu.atcrowfinding.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.yuu.atcrowfinding.bean.TRole;
import com.yuu.atcrowfinding.service.TRoleService;
import com.yuu.atcrowfinding.util.Datas;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TRoleController {

    @Autowired
    TRoleService roleService;

    Logger log = LoggerFactory.getLogger(TRoleController.class);

    @RequestMapping("/role/index")
    public String index() {

        return "/role/index";

    }

    @RequestMapping("/role/loadData")
    @ResponseBody
    public PageInfo<TRole> loadData(@RequestParam(value = "pageNum", required = false, defaultValue = "1") Integer pageNum,
                                    @RequestParam(value = "pageSize", required = false, defaultValue = "3") Integer pageSize,
                                    @RequestParam(value = "condition", required = false, defaultValue = "") String condition) {

        PageHelper.startPage(pageNum, pageSize);

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("condition", condition);

        PageInfo<TRole> pageInfo = roleService.listRolePage(paramMap);

        return pageInfo;

    }

    @PreAuthorize("hasRole('QA - 品质保证')")
    @ResponseBody
    @RequestMapping(value = "/role/doAdd")
    public String doAdd(TRole role) {

        roleService.saveRole(role);

        return "OK";

    }

    @ResponseBody
    @RequestMapping(value = "/role/getRoleById")
    public TRole getRoleById(Integer id) {

        TRole role = roleService.getRoleById(id);

        return role;

    }

    @ResponseBody
    @RequestMapping("/role/doUpdate")
    public String doUpdate(TRole role) {

        roleService.updateRole(role);

        return "OK";

    }

    @ResponseBody
    @RequestMapping("/role/doDelete")
    public String doDelete(Integer id) {

        roleService.deleteRole(id);

        return "OK";

    }

    @ResponseBody
    @RequestMapping("role/doAssignPermissionToRole")
    public String doAssignPermissionToRole(Integer roleId, Datas ds) {

        log.debug("the roleId is {}", roleId);
        log.debug("the permissionId is {}", ds.getIds().toString());

        List<Integer> permissionIdList = ds.getIds();
        roleService.saveAssignPermissionToRole(roleId, permissionIdList);

        return "OK";
    }

    @ResponseBody
    @RequestMapping("/permission/listPermissionIdByRoleId")
    public List<Integer> listPermissionIdByRoleId(Integer roleId) {

        log.debug("roleId is {}", roleId);

        return roleService.listPermissionIdByRoleId(roleId);

    }

}

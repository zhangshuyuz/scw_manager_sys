package com.yuu.atcrowfinding.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.yuu.atcrowfinding.bean.TAdmin;
import com.yuu.atcrowfinding.bean.TRole;
import com.yuu.atcrowfinding.service.TAdminService;
import com.yuu.atcrowfinding.service.TRoleService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

@Controller
public class TAdminController {

    Logger log = LoggerFactory.getLogger(TAdminController.class);

    @Autowired
    TAdminService adminService;

    @Autowired
    TRoleService roleService;

    /**
     * 进入用户主页面
     * @return
     */
    @RequestMapping("/admin/index")
    public String index(@RequestParam(value = "pageNum", required = false, defaultValue = "1") Integer pageNum,
                        @RequestParam(value = "pageSize", required = false, defaultValue = "2") Integer pageSize,
                        Model model,
                        @RequestParam(value = "condition", required = false, defaultValue = "") String condition) {

        log.debug("The pageNum is {}", pageNum);
        log.debug("The pageSize is {}", pageSize);
        log.debug("The query condition is {}", condition);

        PageHelper.startPage(pageNum, pageSize); // 线程绑定

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("queryCondition", condition);

        PageInfo<TAdmin> pageInfo = adminService.listAdminPage(paramMap);

        model.addAttribute("page", pageInfo);

        return "admin/index";

    }

    @RequestMapping("/admin/toAdd")
    public String toAdd() {

        return "/admin/add";

    }

    @PreAuthorize("hasRole('SA - 软件架构师c')")
    @RequestMapping("/admin/doAdd")
    public String doAdd(TAdmin admin) {

        adminService.saveTAdmin(admin);

        return "redirect:/admin/index";

    }

    @RequestMapping("/admin/toUpdate")
    public String toUpdate(Integer id, Model model) {

        TAdmin admin = adminService.getAdminById(id);
        model.addAttribute("admin", admin);

        return "admin/update";
    }

    @RequestMapping("/admin/doUpdate")
    public String doUpdate(TAdmin admin, Integer pageNum, String condition) {

        adminService.updateTAdmin(admin);

        return "redirect:/admin/index?pageNum=" + pageNum + "&condition=" + condition;

    }

    @RequestMapping("/admin/doDelete")
    public String doDelete(Integer id, Integer pageNum) {

        adminService.deleteTAdminById(id);

        return "redirect:/admin/index?pageNum=" + pageNum;
    }

    @RequestMapping("/admin/doDeleteBatch")
    public String doDeleteBatch(String ids, Integer pageNum) {

        String[] split = ids.split(",");

        List<Integer> idList = new ArrayList<>();

        for (String id :
                split) {
            idList.add(Integer.parseInt(id));
        }

        adminService.deleteTAdminByBatch(idList);

        return "redirect:/admin/index?pageNum=" + pageNum;
    }

    @RequestMapping("/admin/toAssign")
    public String toAssign(String id, Model model) {

        // 1. 查询所有角色

        List<TRole> roleList = roleService.listRoleAll();

        // 2. 根据用户id，查询已经拥有的角色id

        List<Integer> roleIdList = adminService.getRoleIdByAdminId(id);

        // 3. 将所有角色进行划分：
        List<TRole> assignList = new ArrayList<>(); // 已分配角色的集合
        List<TRole> unAssignList = new ArrayList<>(); // 未分配角色的集合

        model.addAttribute("assignList", assignList);
        model.addAttribute("unAssignList", unAssignList);

        for (TRole role :
                roleList) {

            if (roleIdList.contains(role.getId())) {
                // 4. 已经分配角色
                assignList.add(role);
            } else {
                // 5. 未分配角色
                unAssignList.add(role);
            }

        }

        return "/admin/assignRole";

    }

    @ResponseBody
    @RequestMapping("/admin/doAssign")
    public String doAssign(Integer[] id, Integer adminId) {

        log.debug("the roleId is {}", Arrays.toString(id));
        log.debug("the adminId is {}", adminId);

        adminService.saveAdminAndRoleRelationship(id, adminId);

        return "OK";

    }

    @ResponseBody
    @RequestMapping("/admin/doUnAssign")
    public String doUnAssign(Integer[] id, Integer adminId) {

        log.debug("the roleId is {}", Arrays.toString(id));
        log.debug("the adminId is {}", adminId);

        adminService.deleteAdminAndRoleRelationship(id, adminId);

        return "OK";

    }
}

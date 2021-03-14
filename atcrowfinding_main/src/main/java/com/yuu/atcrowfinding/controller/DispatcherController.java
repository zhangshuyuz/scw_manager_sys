package com.yuu.atcrowfinding.controller;

import com.yuu.atcrowfinding.bean.TAdmin;
import com.yuu.atcrowfinding.bean.TMenu;
import com.yuu.atcrowfinding.service.TAdminService;
import com.yuu.atcrowfinding.service.TMenuService;
import com.yuu.atcrowfinding.util.Const;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 专门用来做转发的类
 */
@Controller
public class DispatcherController {

    Logger log = LoggerFactory.getLogger(DispatcherController.class);

    @Autowired
    TAdminService adminService;

    @Autowired
    TMenuService menuService;

    /**
     * 访问主页面
     * @return
     */
    @RequestMapping("/index")
    public String index() {

        log.debug("jump to index");

        return "index";

    }

    /**
     * 跳转到登录界面
     * @return
     */
    @RequestMapping("/login")
    public String login() {

        log.debug("jump to login");

        return "login";

    }

//    /**
//     * 跳转到后台界面
//     * @param loginacct
//     * @param userpswd
//     * @return
//     */
//    @RequestMapping("/dologin")
//    public String dologin(String loginacct, String userpswd, HttpSession httpSession, Model model) {
//
//        log.debug("start login");
//        log.debug("loginacct={}", loginacct);
//        log.debug("userpswd={}", userpswd);
//
//        // 查询管理员
//        Map<String, Object> param = new HashMap<>();
//        param.put("loginacct", loginacct);
//        param.put("userpswd", userpswd);
//
//        try {
//            // 登录成功
//            TAdmin admin = adminService.getAdminByLogin(param);
//            httpSession.setAttribute(Const.LOGIN_ADMIN, admin);
//
//            log.debug("login success");
//            return "redirect:/main";
//        } catch (Exception e) {
//            // 登录失败
//            e.printStackTrace();
//            log.debug("login failed, cause: {}", e.getMessage());
//
//            model.addAttribute(Const.LOGIN_FAILED_MSG, e.getMessage());
//            return "login";
//        }
//
//    }
//
//    /**
//     * 注销登录
//     * @param httpSession
//     * @return
//     */
//    @RequestMapping("/logout")
//    public String logout(HttpSession httpSession) {
//
//        log.debug("exit!");
//
//        // 必须要有该判断，因为Session有持续时间，如果过了持续时间然后再注销，不判断会抛出空指针异常
//        if (httpSession != null) {
//            httpSession.removeAttribute(Const.LOGIN_ADMIN);
//            httpSession.invalidate();
//        }
//
//        return "redirect:/index";
//
//    }

    @RequestMapping("/main")
    public String toMain(HttpSession httpSession) {

        log.debug("go to main.jsp");


        List<TMenu> menuList = (List<TMenu>)httpSession.getAttribute("munuList");

        if (menuList == null) {
            // 查询所有父菜单信息对象，每个父菜单对象中包含其子菜单对象
            menuList = menuService.listMenuAll();
            httpSession.setAttribute("menuList", menuList);
        }

        return "main";

    }

}

package com.yuu.atcrowfinding.listner;

import com.yuu.atcrowfinding.util.Const;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import javax.servlet.http.HttpSessionBindingEvent;

/**
 * 该监听器，用来监听Application对象的创建和销毁
 */

public class SystemUpinitListener implements ServletContextListener {


    Logger log = LoggerFactory.getLogger(SystemUpinitListener.class);


    // Public constructor is required by servlet spec
    public SystemUpinitListener() {
    }

    /**
     * Application对象创建时初始化
     * @param sce
     */
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext servletContext = sce.getServletContext();
        // 获取当前项目的上下文路径
        String contextPath = servletContext.getContextPath();
        // 日志记录上下文路径
        log.debug("this application contextPath is : {}", contextPath);
        // 将上下文路径放入Application域中
        servletContext.setAttribute(Const.PATH, contextPath);

    }

    /**
     * Application对象销毁时执行销毁方法
     * @param sce
     */
    public void contextDestroyed(ServletContextEvent sce) {
      log.debug("this Application Object is destroyed");
    }
}

package com.yuu.atcrowfinding.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class AtcrowFindingSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    UserDetailsService securityUserDetailService;


    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {

        auth.userDetailsService(securityUserDetailService).passwordEncoder(new BCryptPasswordEncoder());
//        auth.inMemoryAuthentication().withUser("wangwu").password("123456");
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {

//        super.configure(http);
        http.authorizeRequests()
                .antMatchers("/static/**", "/index.jsp").permitAll()
                .anyRequest().authenticated();

        http.formLogin().loginPage("/login").usernameParameter("loginacct").passwordParameter("userpswd")
                .loginProcessingUrl("/dologin").defaultSuccessUrl("/main").permitAll();

        http.csrf().disable();

        http.logout().logoutUrl("/logout").logoutSuccessUrl("/login");

        // 异常处理器
        http.exceptionHandling().accessDeniedHandler(new AccessDeniedHandler() {
            @Override
            public void handle(HttpServletRequest httpServletRequest,
                               HttpServletResponse httpServletResponse, AccessDeniedException e) throws IOException, ServletException {

                // 获取X-Requested-With
                String type = httpServletRequest.getHeader("X-Requested-With");

                if ("XMLHttpRequest".equals(type)) {
                    // 是异步请求产生的异常
                    httpServletResponse.getWriter().print("403"); // 403, 权限级别不够，拒绝访问
                } else {
                    // 是同步请求产生的异常
                    httpServletRequest.getRequestDispatcher("/WEB-INF/jsp/error/error403.jsp").forward(httpServletRequest, httpServletResponse);
                }


            }
        });

        http.rememberMe();

    }

}

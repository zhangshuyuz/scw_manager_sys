package com.yuu.atcrowfinding.component;

import com.yuu.atcrowfinding.bean.TAdmin;
import com.yuu.atcrowfinding.bean.TAdminExample;
import com.yuu.atcrowfinding.bean.TPermission;
import com.yuu.atcrowfinding.bean.TRole;
import com.yuu.atcrowfinding.mapper.TAdminMapper;
import com.yuu.atcrowfinding.mapper.TPermissionMapper;
import com.yuu.atcrowfinding.mapper.TRoleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service("securityUserDetailService")
public class SecurityUserDetailServiceImpl implements UserDetailsService {

    @Autowired
    TAdminMapper adminMapper;

    @Autowired
    TRoleMapper roleMapper;

    @Autowired
    TPermissionMapper permissionMapper;

    @Override
    public UserDetails loadUserByUsername(String s) throws UsernameNotFoundException {

        // 查询用户
        TAdminExample adminExample = new TAdminExample();
        adminExample.createCriteria().andLoginacctEqualTo(s);

        List<TAdmin> adminList = adminMapper.selectByExample(adminExample);

        if (adminList != null && adminList.size() == 1) {

            TAdmin admin = adminList.get(0);
            Integer adminId = admin.getId();

            // 查询角色
            List<TRole> roleList = roleMapper.listRoleByAdminId(adminId);

            // 查询权限
            List<TPermission> permissionList = permissionMapper.listPermissionByAdminId(adminId);

            // 构建用户的所有权限集合
            Set<GrantedAuthority> authorities = new HashSet<>();

            for (TRole role:
                    roleList) {
                authorities.add(new SimpleGrantedAuthority("ROLE_" + role.getName()));
            }

            for (TPermission permission:
                    permissionList) {
                authorities.add(new SimpleGrantedAuthority(permission.getName()));
            }

            return new TAdminUser(admin, authorities);
        } else {
            return null;
        }

    }

}

package com.yuu.atcrowfinding.component;

import com.yuu.atcrowfinding.bean.TAdmin;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;

public class TAdminUser extends User {

    private TAdmin originalUser; // 保存用户信息

    public TAdmin getOriginalUser() {
        return originalUser;
    }

    public void setOriginalUser(TAdmin originalUser) {
        this.originalUser = originalUser;
    }

    public TAdminUser(TAdmin originalUser, Collection<? extends GrantedAuthority> authorities) {
        super(originalUser.getLoginacct(), originalUser.getUserpswd(), true, true, true, true, authorities);
        this.originalUser = originalUser;
        originalUser.setUserpswd(""); // 必须保证保存的用户信息中，擦除了密码
    }

    public TAdminUser(String username, String password, boolean enabled, boolean accountNonExpired,
                      boolean credentialsNonExpired, boolean accountNonLocked, Collection<? extends GrantedAuthority> authorities) {
        super(username, password, enabled, accountNonExpired, credentialsNonExpired, accountNonLocked, authorities);
    }
}

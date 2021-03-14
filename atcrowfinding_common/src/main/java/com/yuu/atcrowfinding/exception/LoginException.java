package com.yuu.atcrowfinding.exception;

// 继承RuntimeException的原因：
// spring声明式事务，只对RuntimeException进行回滚
/**
 * 登录异常类
 */
public class LoginException extends RuntimeException{

    public LoginException() {

    }

    public LoginException(String message) {
        super(message);
    }
}

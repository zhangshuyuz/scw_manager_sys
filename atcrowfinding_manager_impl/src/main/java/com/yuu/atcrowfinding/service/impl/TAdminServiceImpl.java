package com.yuu.atcrowfinding.service.impl;

import com.github.pagehelper.PageInfo;
import com.yuu.atcrowfinding.bean.TAdmin;
import com.yuu.atcrowfinding.bean.TAdminExample;
import com.yuu.atcrowfinding.exception.LoginException;
import com.yuu.atcrowfinding.mapper.TAdminMapper;
import com.yuu.atcrowfinding.mapper.TAdminRoleMapper;
import com.yuu.atcrowfinding.service.TAdminService;
import com.yuu.atcrowfinding.util.AppDateUtils;
import com.yuu.atcrowfinding.util.Const;
import com.yuu.atcrowfinding.util.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


@Service
public class TAdminServiceImpl implements TAdminService {

    @Autowired
    TAdminMapper adminMapper;

    @Autowired
    TAdminRoleMapper adminRoleMapper;

    @Override
    public TAdmin getAdminByLogin(Map<String, Object> param) {



        // 1. 查询用户
        String loginacct = (String)param.get("loginacct");
        // 密码加密
        String userpswd = MD5Util.digest((String) param.get("userpswd"));

        TAdminExample adminExample = new TAdminExample();
        TAdminExample.Criteria criteria = adminExample.createCriteria();
        criteria.andLoginacctEqualTo(loginacct);

        List<TAdmin> adminList = adminMapper.selectByExample(adminExample);

        // 3. 判断用户是否为null
        if (adminList == null || adminList.size() != 1) {
            throw new LoginException(Const.LOGIN_LOGINACCT_ERROR);
        }

        TAdmin admin = adminList.get(0);

        // 4. 判断密码是否一致
        if (!admin.getUserpswd().equals(userpswd)) {
            throw new LoginException(Const.LOGIN_USERPSWD_ERROR);
        }

        return admin;
    }

    @Override
    public PageInfo<TAdmin> listAdminPage(Map<String, Object> paramMap) {

        String queryCondition = (String)paramMap.get("queryCondition");

        TAdminExample adminExample = new TAdminExample();
        if (!"".equals(queryCondition)) {
            adminExample.createCriteria().andLoginacctLike("%" + queryCondition + "%");
            TAdminExample.Criteria criteria1 = adminExample.createCriteria().andUsernameLike("%" + queryCondition + "%");
            TAdminExample.Criteria criteria2 = adminExample.createCriteria().andEmailLike("%" + queryCondition + "%");

            adminExample.or(criteria1);
            adminExample.or(criteria2);
        }

        adminExample.setOrderByClause("createtime desc");

        List<TAdmin> adminList = adminMapper.selectByExample(adminExample);

        PageInfo<TAdmin> pageInfo = new PageInfo<>(adminList, 5);

        return pageInfo;
    }

    @Override
    public void saveTAdmin(TAdmin admin) {

        // 初始化密码
        admin.setUserpswd(MD5Util.digest(Const.DEFAULT_USERPSWD));

        // 初始化时间
        admin.setCreatetime(AppDateUtils.getFormatTime());

        // 动态SQL，有选择性的保存
        adminMapper.insertSelective(admin);

    }

    @Override
    public TAdmin getAdminById(Integer id) {
        return adminMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateTAdmin(TAdmin admin) {
        adminMapper.updateByPrimaryKeySelective(admin);
    }

    @Override
    public void deleteTAdminById(Integer id) {
        adminMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void deleteTAdminByBatch(List<Integer> idList) {
        adminMapper.deleteByAdminBatch(idList);
    }

    @Override
    public List<Integer> getRoleIdByAdminId(String id) {
        return adminRoleMapper.getRoleIdByAdminId(id);
    }

    @Override
    public void saveAdminAndRoleRelationship(Integer[] id, Integer adminId) {
        adminRoleMapper.saveAdminAndRoleRelationship(id, adminId);
    }

    @Override
    public void deleteAdminAndRoleRelationship(Integer[] id, Integer adminId) {
        adminRoleMapper.deleteAdminAndRoleRelationship(id, adminId);
    }

}

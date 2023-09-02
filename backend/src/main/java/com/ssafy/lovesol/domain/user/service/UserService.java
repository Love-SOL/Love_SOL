package com.ssafy.lovesol.domain.user.service;

import com.ssafy.lovesol.domain.user.entity.User;

import java.util.List;

public interface UserService {

    List<User> getAllUserByDepositAt(int day);
}

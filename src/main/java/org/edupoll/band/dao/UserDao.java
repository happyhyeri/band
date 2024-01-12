package org.edupoll.band.dao;


import java.util.List;

import org.edupoll.band.model.User;

public interface UserDao {
	public User findUserById (String id);
	public List<User> findUserByIdwithProfile(String id);
	public int save(User one);
	public int userUpdate(User one);
}

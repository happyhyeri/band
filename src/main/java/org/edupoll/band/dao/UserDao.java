package org.edupoll.band.dao;


import org.edupoll.band.model.User;

public interface UserDao {
	public User findUserById (String id);
	public User findUserByIdwithProfile(String id);
	public int save(User one);
	public int userUpdate(User one);
	
	
	
}

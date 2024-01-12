package org.edupoll.band.dao;

import java.util.List;

import org.edupoll.band.model.Profile;

public interface ProfileDao {

	public Profile profileSave(Profile one);

	public int profileUpdate(Profile one);

	public List<Profile> findProfileById(String id);

}

package org.edupoll.band.dao;

import org.edupoll.band.model.Profile;

public interface ProfileDao {
	
	//프로필 
		public Profile profileSave(Profile one);
		public int profileUpdate(Profile one);
		public Profile findProfileById (String id);

}

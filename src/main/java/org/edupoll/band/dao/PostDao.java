package org.edupoll.band.dao;

import java.util.List;
import java.util.Map;

import org.edupoll.band.model.Post;

public interface PostDao {
	public int savePost(Post post);

	public List<Post> findByRoomIdWithImage(String postBandRoomId);
	
	public Post findById(int postId);
	
	public int updateContent(Map<String, Object> criteria);
	
	public int deleteById(int postId);
}

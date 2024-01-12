package org.edupoll.band.dao;

import java.util.List;

import org.edupoll.band.model.Post;

public interface PostDao {
	public int savePost(Post post);

	public List<Post> findByRoomIdWithImage(String postBandRoomId);
}

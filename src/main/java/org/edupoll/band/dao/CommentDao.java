package org.edupoll.band.dao;

import java.util.List;

import org.edupoll.band.model.Comment;

public interface CommentDao {
	public int saveComment(Comment comment); 

	public List<Comment> findByPostId(int postId);
}

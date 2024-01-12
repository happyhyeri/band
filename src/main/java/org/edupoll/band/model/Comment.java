package org.edupoll.band.model;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Comment {
	private int commentId;
	private int commentPostId;
	private int commetMemberId;
	private String message;
	private Date commentWriteAt;
}

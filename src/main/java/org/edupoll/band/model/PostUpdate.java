package org.edupoll.band.model;

import org.springframework.web.multipart.MultipartFile;

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
public class PostUpdate {
	private String content;
	private int postId;
	private String[] imageUrls;
	private MultipartFile[] images;
}

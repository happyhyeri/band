package org.edupoll.band.model;

import java.sql.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Setter
@Getter
public class UpdateUserInfo {
	private String userPassword;
	private MultipartFile profileImage;
	private String phonenumber;
	private String gender;
	private Date birth;
	private String nickname;
}

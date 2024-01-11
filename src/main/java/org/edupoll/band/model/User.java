package org.edupoll.band.model;

import java.sql.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Setter
@Getter

public class User {
	private String userId;
	private String userPassword;
	private String platform;
	private String accessToken;
	private String phoneNumber;
	private Date birth;
	private String gender;

	private Profile profile;
}

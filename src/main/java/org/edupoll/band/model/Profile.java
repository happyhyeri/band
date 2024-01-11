package org.edupoll.band.model;

import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Service
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Profile {
	
	private int profileId;
	private String profileUserId;
	private String profileNickName;
	private String profileImageUrl;

}

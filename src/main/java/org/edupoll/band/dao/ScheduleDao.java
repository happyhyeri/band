package org.edupoll.band.dao;

import java.util.List;

import org.edupoll.band.model.Schedule;

public interface ScheduleDao {
	public int saveSchedule(Schedule schedule);

	public List<Schedule> findCurrentMonthSchedule(String currentDate);
	
	public Schedule findNextSchedule();
}

class Course < ApplicationRecord
  has_many :events, dependent: :destroy
  def self.create_all_courses
    Dir["/home/markus/Downloads/*.ics"].each do |name|
      ics_file = File.open(name)
      cals = Icalendar::Calendar.parse(ics_file)
      cal = cals.first
      events = cal.events


      c = Course.create(name: name.split("/").last.gsub(".ics", ""))
      events.each do |event|
        ap event
        puts ""
        puts ""
        puts ""
        puts "rrule"
        event.occurrences_between(1.year.ago, 2.years.from_now).each do |o|
          c.events << Event.create(start:o.start_time, end: o.end_time)
        end
      end
    end
  end

  def get_overlaps
    overlap_events = []
    self.events.each do |e|
      overlaps = Event.where("((start between ? and ?) OR (end between ? and ?)) AND id != ?",e.start, e.end, e.start, e.end, e.id)
      unless overlaps.empty?
        overlap_events << overlaps
        puts "Event #{e.inspect} overlaps with event #{overlap_events.inspect}"
      end
    end
    overlap_events.flatten!
    overlap_events.each do |overlap_event|
      o = Overlap.find_or_create_by(course1_id: self.id, course2_id: overlap_event.course.id )
    end
  end

  def self.create_all_overlaps
    Course.all.each do |c|
      c.get_overlaps
    end
  end
end

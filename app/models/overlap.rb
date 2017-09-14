class Overlap < ApplicationRecord

  def courses
    Course.where(id: [self.course1_id,self.course2_id])
  end

  def string(i=1)
    if i == 1
      "Kurs #{courses.first.name} überlappt mit #{courses.last.name}"
    else
      "Kurs #{courses.last.name} überlappt mit #{courses.first.name}"
    end
  end

  def self.print_all
    Overlap.all.map{|o|o.string}.join("\n")
  end
end

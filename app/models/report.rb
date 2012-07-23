class Report 
  def self.get_date(date)
    date = Date.new(date["year"].to_i, 
                    date["month"].to_i,
                    date["day"].to_i)
  end
end

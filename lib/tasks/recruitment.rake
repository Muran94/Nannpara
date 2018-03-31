namespace :recruitment do
  task close: :environment do
    Recruitment.all.each do |recruitment|
      closed = recruitment.event_date < Date.today
      recruitment.update_attribute(:closed, closed)
    end
  end
end

namespace :recruitment do
  task close: :environment do
    Recruitment.all.each do |recruitment|
      closed_at = recruitment.event_date < Time.zone.now.to_date ? Time.zone.now : nil
      recruitment.update_attribute(:closed_at, closed_at)
    end
  end
end

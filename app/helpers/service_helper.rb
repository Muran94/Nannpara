module ServiceHelper
    def copyright_year
        Time.zone.now.year == Settings.service.launched_year ? Settings.service.launched_year : %(#{Settings.service.launched_year} - #{Time.zone.now.year})
    end
end

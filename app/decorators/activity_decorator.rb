module ActivityDecorator
    def obtained_points_while_particular_ranking_is_in_session(start_at, end_at)
        from_particular_time_range(start_at, end_at).total_obtained_experience_point
    end
end

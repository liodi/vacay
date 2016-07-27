class MainController < ApplicationController
    def index
        @test = getAllUsers()
    end

    def when
        @userNights    = getUserDays('NIGHT')
        @userDinners   = getUserDays('DINNER')
        @globalDinners = getGlobalDinners()

        # Setup formatted hash
        days = getCalendarDays()
        @dayHash = {}
        days.each do |day|
            id = day['day_id'].to_int
            dayName = day['day']
            date = day['date'].to_s
            date = date.split('-')
            date = "#{date[1]}/#{date[2]}"
            @dayHash[id] = {:day => dayName, :date => date}
        end
    end

    def when_postback
        if params[:night_choices] != nil
            nightChoices = params[:night_choices]
        else
            nightChoices = []
        end

        if params[:dinner_choices] != nil
            dinnerChoices = params[:dinner_choices]
        else
            dinnerChoices = []
        end

        updateUserDayChoices(nightChoices, dinnerChoices)

        redirect_to when_path
    end
end
class MainController < ApplicationController
    def index
        @test = getAllUsers()
    end

    def who
        @allUserNights  = getAllUserNights()
        @allUserDinners = getAllUserDinners()
        @days           = getCalendarDays()
    end

    def when
        @userNights    = getUserDays('NIGHT')
        @userDinners   = getUserDays('DINNER')
        @globalDinners = getGlobalDinners()
        @days          = getCalendarDays()
    end

    def when_postback
        nightChoices = []
        if params[:night_choices] != nil
            nightChoices = params[:night_choices]
        end

        dinnerChoices = []
        if params[:dinner_choices] != nil
            dinnerChoices = params[:dinner_choices]
        end

        updateUserDayChoices(nightChoices, dinnerChoices)

        redirect_to when_path
    end

    def how
        @cost = userCost()
    end
end
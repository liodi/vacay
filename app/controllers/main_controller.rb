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

    def what
        @generalIdeas   = getIdeas('GENERAL').to_json.html_safe
        @breakfastIdeas = getIdeas('BREAKFAST').to_json.html_safe
        @lunchIdeas     = getIdeas('LUNCH').to_json.html_safe

        @userVotes = getUserIdeaVotes().to_json.html_safe
    end

    def what_postback
        ideaType = params[:idea_type]
        link = params[:link]
        description = params[:description]

        insertIdea(ideaType, link, description)

        redirect_to what_path
    end

    def what_idea_postback
        ideaId = params[:idea_id]
        voteAction = params[:vote_action]
        voteValue = params[:vote_value]

        if voteAction == 'neutral'
            deleteVote(ideaId);
        elsif voteAction == 'negate'
            updateVote(ideaId, voteValue);
        else
            insertVote(ideaId, voteValue)
        end

        @newVoteCount = getIdeaVoteCount(ideaId)

        respond_to do |format|
            format.json { render json: {:ideaVoteCount => @newVoteCount} }
        end
        # redirect_to what_path
    end

    def how
        @cost = userCost()
    end
end
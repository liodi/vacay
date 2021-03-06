class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    helper_method :current_user, :logged_in?
    # http_basic_authenticate_with name: "p", password: "p", except: :index

    def login(user)
        session[:user_id] = user.id
    end

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
    end

    def logged_in?
        !!current_user
    end

    def dbhDo(sql)
        results = ''

        dbh = Mysql2::Client.new(
            host: "192.168.0.25",
            username: "root",
            password: "!!Liodi92",
            database: "vacay_development",
            port: 3306
        )

        results = dbh.query sql

        dbh.close

        return results
    end

    def getAllUsers()
        sql = 'SELECT * FROM users'

        return dbhDo(sql)
    end

    def getCalendarDays()
        sql = 'SELECT * FROM calendar_days'

        days = dbhDo(sql)
        dayHash = {}
        days.each do |day|
            id = day['day_id'].to_int
            dayName = day['day']
            date = day['date'].to_s
            date = date.split('-')
            date = "#{date[1]}/#{date[2]}"
            dayHash[id] = {:day => dayName, :date => date}
        end

        return dayHash
    end

    def updateUserDayChoices(nightChoices, dinnerChoices)
        user = current_user()

        sql = "
            DELETE FROM user_day_choices
            WHERE user_id = #{user[:id]}"

        dbhDo(sql)

        if nightChoices.size > 0
            nightChoices.each do |dayId|
                sql = "
                    INSERT INTO user_day_choices
                    (user_id, day_id, type)
                    VALUES (#{user[:id]}, #{dayId}, 'NIGHT')"

                dbhDo(sql)
            end
        end

        if dinnerChoices.size > 0
            dinnerChoices.each do |dayId|
                sql = "
                    INSERT INTO user_day_choices
                    (user_id, day_id, type)
                    VALUES (#{user[:id]}, #{dayId}, 'DINNER')"

                dbhDo(sql)
            end
        end

        return
    end

    def getUserDays(type)
        user = current_user()

        sql = "
            SELECT day_id
            FROM user_day_choices
            WHERE user_id = #{user[:id]}
            AND type = '#{type}'"

        days = dbhDo(sql)

        retDays = []
        if days.size > 0
            days.each do |day|
                retDays.push(day['day_id'])
            end
        end

        return retDays
    end

    def getGlobalDinners()
        user = current_user()

        sql = "
            SELECT day_id
            FROM user_day_choices
            WHERE type = 'DINNER'
            AND user_id NOT LIKE #{user[:id]}"

        days = dbhDo(sql)

        retDays = []
        if days.size > 0
            days.each do |day|
                retDays.push(day['day_id'])
            end
        end

        return retDays
    end

    def getAllUserNights()
        sql = "
            SELECT user_id, name, udc.day_id
            FROM user_day_choices udc
            LEFT JOIN users u ON u.id = udc.user_id
            LEFT JOIN calendar_days cd ON cd.day_id = udc.day_id
            WHERE udc.type = 'NIGHT'"

        results = dbhDo(sql)

        userNightHash = {}
        if results.size > 0
            results.each do |entry|
                if userNightHash[entry['user_id']] == nil
                    userNightHash[entry['user_id']] = {
                        'name' => entry['name'],
                        'days' => [entry['day_id']],
                    }
                else
                    userNightHash[entry['user_id']]['days'].push(entry['day_id'])
                end
            end
        end

        return userNightHash
    end

    def getAllUserDinners()
        userDinners = []

        for i in 1..7
            name = ''
            results = getDinnerUser(i)
            if results.size > 0
                results.each do |entry|
                    name = entry['name']
                end
            end

            userDinners.push(name)
        end

        return userDinners
    end

    def getDinnerUser(dayId)
        sql = "
            SELECT name
            FROM user_day_choices udc
            LEFT JOIN users u ON u.id = udc.user_id
            WHERE day_id = #{dayId}
            AND type = 'DINNER'"

        return dbhDo(sql)
    end

    def userCost()
        user = current_user()
        userNights = getUserNightCount(user['id']).to_f
        totalNights = getTotalNightCount().to_f

        # TODO store this in global var table
        totalCost = 1058.87

        cost = ((totalCost / totalNights) * userNights).round(2)

        return cost
    end

    def getUserNightCount(userId)
        sql = "
            SELECT COUNT(*) AS count
            FROM user_day_choices
            WHERE user_id = #{userId}
            AND type = 'NIGHT'"

        count = 0
        results = dbhDo(sql)
        if results.size > 0
            results.each do |entry|
                count = entry['count']
            end
        end

        return count
    end

    def getTotalNightCount()
        sql = "
            SELECT COUNT(*) AS count
            FROM user_day_choices
            WHERE type = 'NIGHT'"

        count = 0
        results = dbhDo(sql)
        if results.size > 0
            results.each do |entry|
                count = entry['count']
            end
        end

        return count
    end

    def insertIdea(ideaType, link, description)
        user = current_user()

        sql = "
            INSERT INTO user_ideas
            (user_id, type, link, description)
            VALUES (#{user[:id]}, '#{ideaType}', '#{link}', '#{description}')"

        dbhDo(sql)
    end

    def getIdeas(ideaType)
        sql = "
            SELECT
                ui.*,
                u.name,
                IFNULL(SUM(uiv.vote), 0) AS votes
            FROM user_ideas ui
            LEFT JOIN users u ON u.id = ui.user_id
            LEFT JOIN user_idea_votes uiv ON uiv.idea_id = ui.id
            WHERE type = '#{ideaType}'
            GROUP BY ui.id"

        return dbhDo(sql)
    end

    def getUserIdeaVotes()
        user = current_user()

        sql = "
            SELECT *
            FROM user_idea_votes
            WHERE user_id = #{user[:id]}"

        return dbhDo(sql)
    end

    def insertVote(ideaId, vote)
        user = current_user()

        sql = "
            INSERT INTO user_idea_votes
            (idea_id, user_id, vote)
            VALUES (#{ideaId}, #{user[:id]}, '#{vote}')"

        dbhDo(sql)
    end

    def updateVote(ideaId, vote)
        user = current_user()

        sql = "
            UPDATE user_idea_votes
            SET vote = #{vote}
            WHERE idea_id = #{ideaId}
            AND user_id = #{user[:id]}"

        dbhDo(sql)
    end

    def deleteVote(ideaId)
        user = current_user()

        sql = "
            DELETE FROM user_idea_votes
            WHERE idea_id = #{ideaId}
            AND user_id = #{user[:id]}"

        dbhDo(sql)
    end

    def getIdeaVoteCount(ideaId)
        sql = "
            SELECT
            IFNULL(SUM(uiv.vote), 0) AS count
            FROM user_idea_votes uiv
            WHERE idea_id = '#{ideaId}'
            GROUP BY uiv.idea_id"

        count = 0
        results = dbhDo(sql)
        if results.size > 0
            results.each do |entry|
                count = entry['count']
            end
        end

        return count
    end
end
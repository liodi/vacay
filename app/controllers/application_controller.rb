class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    helper_method :current_user, :logged_in?

    def login(user)
        session[:user_id] = user.id
    end

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
    end

    def logged_in?
        !!current_user
    end



    def dbh(sql)
        results = ''

        dbh = Mysql2::Client.new(
            host: "127.0.0.1",
            username: "root",
            password: "joseph92",
            database: "vacay_development",
            port: 3306
        )

        results = dbh.query sql

        dbh.close

        return results
    end


    def users
        sql = '
            SELECT *
            FROM users'

        return dbh(sql)
    end
end
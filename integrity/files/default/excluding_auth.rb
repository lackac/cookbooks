class ExcludingAuth
  def initialize(app, excluding_re, user, pass, realm="")
    @app, @excluding_re, @user, @pass, @realm = app, excluding_re, user, pass, realm
  end

  def unauthorized!
    [ 401, {'WWW-Authenticate' => %{Basic realm="#{@realm}"}}, "Authorization Required" ]
  end

  def bad_request!
    [ 400, {}, "Bad Request" ]
  end

  def authorize(user, pass)
    @user == user and @pass == pass
  end

  def call(env)
    if (env['SCRIPT_NAME'].blank? ? env['PATH_INFO'] : env['SCRIPT_NAME']).match(@excluding_re)
      @app.call(env)
    else
      auth = Rack::Auth::Basic::Request.new(env)
      if env['REMOTE_USER']
        @app.call(env)
      elsif not auth.provided?
        unauthorized!
      elsif not auth.basic?
        bad_request!
      elsif not authorize(*auth.credentials)
        unauthorized!
      else
        env['REMOTE_USER'] = auth.username
        @app.call(env)
      end
    end
  end
end

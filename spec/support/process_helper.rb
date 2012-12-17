
module ProcessHelper

  def launch_test_processes(server_runner, client_runner)
    @server_pid = Process.fork do
      ENV.update(server_env_vars)
      Process.exec(server_runner)
    end
    @client_pid = Process.fork do
      ENV.update(client_env_vars)
      Process.exec(client_runner)
    end
  end

  def kill_test_processes
    return unless @server_pid
    return unless @client_pid
    puts "Telling server/client processes to die"
    Process.kill("KILL", @server_pid)
    Process.kill("KILL", @client_pid)
    @sstatus = @cstatus = nil
  end

  def client_env_vars
    {
      "APP_NAME" => test_app_name,
      "PORT" => client_port,
      "AUTH_URI" => server_uri,
      "SECRET" => secret
    }
  end

  def server_env_vars
    {
      "PORT" => server_port,
      "CLIENT_NAME" => test_app_name,
      "CLIENT_LOGIN_URI" => client_uri + '/login',
      "CLIENT_LOGIN_FORM_URI" => client_uri + '/loginform', # Maybe one day.
      "CLIENT_LOGOUT_URI" => client_uri + '/logout',
      "SECRET" => secret
    }
  end

  def test_app_name
    "Testing Client"
  end

  def client_port
    "11201"
  end

  def server_port
    "11202"
  end

  def secret
    'sekrit'
  end

  def client_uri
    "http://localhost:#{client_port}"
  end

  def server_uri
    "http://localhost:#{server_port}"
  end

end
require 'spec_helper'

feature "sciSSOrs" do

  # Spin up a client and a server using env vars, then get them to authorize for one another.

  Dir.glob('spec/runners/servers/*').each do |server_runner|

    Dir.glob('spec/runners/clients/*').each do |client_runner|
      server_desc = server_runner.split('/').last
      client_desc = client_runner.split('/').last
      describe "with server #{server_desc} and client #{client_desc}" do
        before(:all) do
          launch_test_processes(server_runner, client_runner)
        end

        after(:all) do
          kill_test_processes
        end

        it 'logs in' do
          visit client_uri
          fill_in('identity', :with => 'John')
          fill_in('password', :with => 'Smith')
          find_button('Log in').click
          page.should have_text('Welcome, logged in user {"ident"=>"John"')
        end

      end
    end

  end
end
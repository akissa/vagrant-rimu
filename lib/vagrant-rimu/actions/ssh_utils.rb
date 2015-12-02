require 'pathname'

module VagrantPlugins
  module Rimu
    module Actions
      module SshUtils
        def upload_key(env, user=nil)
          path = env[:machine].config.ssh.private_key_path
          path = path[0] if path.is_a?(Array)
          path = File.expand_path(path, env[:machine].env.root_path)
          pub_key = public_key(path)
          if user.nil?
            env[:machine].communicate.execute(<<-BASH)
              if [ ! -d /root/.ssh ]; then
                mkdir /root/.ssh;
                chmod 0700 /root/.ssh;
              fi
              if ! grep '#{pub_key}' /root/.ssh/authorized_keys; then
                echo '#{pub_key}' >> /root/.ssh/authorized_keys;
              fi
            BASH
          else
            env[:machine].communicate.execute(<<-BASH)
              if ! grep '#{pub_key}' /home/#{user}/.ssh/authorized_keys; then
                echo '#{pub_key}' >> /home/#{user}/.ssh/authorized_keys;
              fi

              chown -R #{user} /home/#{user}/.ssh;
            BASH
          end
        end
        
        def public_key(private_key_path)
          File.read("#{private_key_path}.pub")
        rescue
          raise Errors::PublicKeyError, :path => "#{private_key_path}.pub"
        end
      end
    end
  end
end

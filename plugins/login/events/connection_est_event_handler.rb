module AresMUSH
  module Login
    class ConnectionEstablishedEventHandler
      def on_event(event)
        client = event.client

        # Connect screen ansi
        filename = File.join(AresMUSH.game_path, 'text', "#{['connect1.txt', 'connect2.txt', 'connect3.txt', 'connect4.txt', 'connect5.txt'].sample}")

        if (File.exist?(filename))
          client.emit File.read(filename, :encoding => "UTF-8")
        else
          Global.logger.warn "Connect screen #{filename} missing!"
        end

        # Ares welcome text
        client.emit_ooc t('client.welcome', :version => AresMUSH.version ? AresMUSH.version.chomp : "")
      end
    end
  end
end

module AresMUSH
  module L5R
    class WoundsDisplayTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/wounds_display.erb"
      end

      def health
        status = L5R.calc_l5r_wound_status(char)
        if status == "Healthy"
          display = left("%xgWounds:%xn ", 8)
          display << format_health_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%xgHealthy: No TN Penalties -- Largely Undamaged%xn"
        elsif status == "Nicked"
          display = left("%x47Wounds:%xn ", 8)
          display << format_health_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x47Nicked: TNs +3 -- Mild but distracting injury%xn"
        elsif status == "Grazed"
          display = left("%x120Wounds:%xn ", 8)
          display << format_health_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x120Grazed: TN +5 -- Injured, but still able to function without tremendous difficulty%xn"
        elsif status == "Hurt"
          display = left("%x136Wounds:%xn ", 8)
          display << format_health_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x136Hurt: TN +10 -- Begun to suffer noticeably from injuries%xn"
        elsif status == "Injured"
          display = left("%x166Wounds:%xn ", 8)
          display << format_health_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x166Injured: TN +15 -- Difficulty focusing attention on the task at hand%xn"
        elsif status == "Crippled"
          display = left("%x203Wounds:%xn ", 8)
          display << format_health_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x203Crippled:TN +20 -- Can barely stand, much less move. Move actions increase in action step (Free becomes Simple, etc.)%xn"
        elsif status == "Down"
          display = left("%x197Wounds:%xn ", 8)
          display << format_health_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%x197Down: TN +40 -- Virtually incapacitated. May speak only in whisper, only take Free Actions (costs a Void point), and can't move.%xn"
        elsif status == "Out"
          display = left("%xrWounds:%xn ", 8)
          display << format_health_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%xrOut: Actions unavailable -- Immobile, unconscious, and likely dying. Any damage above this level means death%xn"
        elsif status == "Dead"
          display = left("%xh%xxWounds:%xn ", 8)
          display << format_health_bar(char.l5r_current_wounds, L5R.calc_l5r_max_wounds(char))
          display << "%r%xh%xxDead: Your character has likely died. You may be entitled to a final Dramatic Moment.%xn"
        end
        display
      end

      def format_health_bar(current, max)
        current = current || 0
        max = max || 10
        x = current.times.map { |i| '%xr*%xn' }.join
        o = (max - current).times.map { |i| '%xh*%xn' }.join
        "#{x}#{o} (#{current}/#{max})"
      end
    end
  end
end

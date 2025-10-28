# frozen_string_literal: true

namespace :interview do
  desc "Setup the complete interview application with deliberate bugs"
  task setup: :environment do
    puts "🚀 Setting up NotifyHub Interview Application..."

    # This task will guide you through the setup
    # Run: rails interview:setup

    puts "✅ Application structure is ready"
    puts "📝 Next steps:"
    puts "   1. rails db:create db:migrate"
    puts "   2. rails db:seed"
    puts "   3. rails server"
    puts ""
    puts "🐛 Remember: This app contains deliberate bugs for the interview!"
  end
end

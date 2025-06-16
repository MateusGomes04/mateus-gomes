namespace :app do
  desc "Setup completo para development e test: drop, create, migrate e seed (apenas development)"
  task setup: :environment do
    environments = {
      "development" => "💻",
      "test" => "🧪"
    }

    environments.each do |env, emoji|
      puts "\n#{emoji}  Preparando ambiente #{env}..."

      ENV['RAILS_ENV'] = env

      %w[drop create migrate].each do |task_name|
        puts "➡️  Executando db:#{task_name} para #{env}..."
        Rake::Task["db:#{task_name}"].reenable
        Rake::Task["db:#{task_name}"].invoke
      end

      if env == "development"
        puts "🌱 Rodando seeds para #{env}..."
        Rake::Task["db:seed"].reenable
        Rake::Task["db:seed"].invoke
      else
        puts "🚫 Pulando seeds no ambiente de teste."
      end
    end

    puts "\n✅ Setup completo para development e test!"
  end
end
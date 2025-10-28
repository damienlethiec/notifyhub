# Clean database
puts "🧹 Cleaning database..."
Notification.destroy_all
User.destroy_all
Organization.destroy_all

puts "🏢 Creating organizations..."
# 2 Organizations
org_a = Organization.create!(
  name: "Ministère de l'Intérieur",
  siret: "11000001500013"
)

org_b = Organization.create!(
  name: "Ministère de la Justice",
  siret: "11000015400014"
)

puts "👥 Creating users..."
# 4 Users (2 par org)
alice = User.create!(
  email: "alice@interieur.gouv.fr",
  password: "password",
  organization: org_a,
  role: :admin
)

bob = User.create!(
  email: "bob@interieur.gouv.fr",
  password: "password",
  organization: org_a,
  role: :user
)

charlie = User.create!(
  email: "charlie@justice.gouv.fr",
  password: "password",
  organization: org_b,
  role: :admin
)

diane = User.create!(
  email: "diane@justice.gouv.fr",
  password: "password",
  organization: org_b,
  role: :user
)

puts "📧 Creating notifications..."
# 10 Notifications (org_a → org_b)
10.times do |i|
  Notification.create!(
    from_organization: org_a,
    to_organization: org_b,
    title: "Notification #{i + 1}",
    body: "Ceci est le contenu de la notification #{i + 1}.\n\nVoici des informations importantes à traiter.",
    priority: ["low", "normal", "high", "urgent"].sample,
    status: "sent"
  )
end

puts "✅ Seeded database successfully!"
puts ""
puts "📊 Summary:"
puts "  - #{Organization.count} organizations"
puts "  - #{User.count} users"
puts "  - #{Notification.count} notifications"
puts ""
puts "🔑 Test credentials:"
puts "  Admin (org A): alice@interieur.gouv.fr / password"
puts "  User (org A):  bob@interieur.gouv.fr / password"
puts "  Admin (org B): charlie@justice.gouv.fr / password"
puts "  User (org B):  diane@justice.gouv.fr / password"
puts ""
puts "🚀 Ready to test! Run: rails server"

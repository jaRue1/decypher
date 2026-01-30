Domain.destroy_all

  domains = [
    {
      name: "Career",
      slug: "career",
      description: "Professional growth, work, income",
      icon: "briefcase",
      level_titles: { 1 => "Junior", 2 => "Mid", 3 => "Senior", 4 => "Lead", 5 => "Staff", 6 => "Principal" },
      position: 0,
    },
    {
      name: "Health & Fitness",
      slug: "health-fitness",
      description: "Physical body, exercise, nutrition",
      icon: "heart",
      level_titles: { 1 => "Rookie", 2 => "Beginner", 3 => "Intermediate", 4 => "Advanced", 5 => "Elite", 6 => "Apex" },
      position: 1
    },
    {
      name: "Mental Health",
      slug: "mental-health",
      description: "Psychological wellbeing, mindfulness, emotional intelligence",
      icon: "brain",
      level_titles: { 1 => "Awakening", 2 => "Aware", 3 => "Balanced", 4 => "Grounded", 5 => "Resilient", 6 => "Thriving" },
      position: 2,
    },
    {
      name: "Finance & Wealth",
      slug: "finance",
      description: "Money management, savings, investments",
      icon: "dollar",
      level_titles: { 1 => "Surviving", 2 => "Stable", 3 => "Building", 4 => "Growing", 5 => "Prospering", 6 => "Abundant" },
      position: 3
    },
    {
      name: "Relationships",
      slug: "relationships",
      description: "Family, friends, romantic, social connections",
      icon: "users",
      level_titles: { 1 => "Distant", 2 => "Reaching", 3 => "Connected", 4 => "Bonded", 5 => "Nurturing", 6 => "Pillar" },
      position: 4
    },
    {
      name: "Education & Learning",
      slug: "education",
      description: "Knowledge acquisition, formal and informal",
      icon: "book",
      level_titles: { 1 => "Novice", 2 => "Learner", 3 => "Studied", 4 => "Skilled", 5 => "Expert", 6 => "Master" },
      position: 5
    },
    {
      name: "Hobbies & Recreation",
      slug: "hobbies",
      description: "Fun, creative pursuits, leisure activities",
      icon: "palette",
      level_titles: { 1 => "Dabbler", 2 => "Casual", 3 => "Committed", 4 => "Enthusiast", 5 => "Devoted", 6 => "Virtuoso" },
      position: 6
    },
    {
      name: "Adventure & Experiences",
      slug: "adventure",
      description: "Travel, bucket list, new experiences",
      icon: "compass",
      level_titles: { 1 => "Homebody", 2 => "Curious", 3 => "Explorer", 4 => "Adventurer", 5 => "Voyager", 6 => "Legendary" },
      position: 7
    }
  ]

  domains.each do |domain_data|
    Domain.create!(domain_data)
  end

  puts "Created #{Domain.count} domains"
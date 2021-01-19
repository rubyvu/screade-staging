# Create Groups in DB
Group::DEFAULT_GROUPS.each do |group_title|
  Group.create_or_find_by(title: group_title)
end

desc "Archives any project that has not been updated in 3 months"
task :archive_projects => :environment do
  Project.where(["updated_at <= ?", 3.months.ago]).each do |p|
    p.update_attributes! :archived_at => Time.now
  end
end

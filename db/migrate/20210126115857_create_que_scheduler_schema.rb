class CreateQueSchedulerSchema < ActiveRecord::Migration[6.1]
  def up
    Que::Scheduler::Migrations.migrate!(version: 6)
  end
  
  def down
    Que::Scheduler::Migrations.migrate!(version: 0)
  end
end

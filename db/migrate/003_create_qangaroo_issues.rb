class CreateQangarooIssues < ActiveRecord::Migration
  def change
    create_table :qangaroo_issues do |t|
      t.integer   :issue_id
      t.integer   :project_id
      t.integer   :qangaroo_bug_id
      t.integer   :qangaroo_project_id
      t.boolean   :from_redmine, default: false, null: false
      t.timestamps null: false
    end
  end
end

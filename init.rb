require 'redmine'
require 'project_patch'
require 'issue_patch'

Redmine::Plugin.register :qangaroo_plugin do
  name 'Qangaroo Plugin'
  author 'Technomobile'
  description 'QangarooとRedmine連携するためのプラグインです。'
  version '1.0.2'
  url 'https://qangaroo.jp'
  author_url 'https://tcmobile.jp'

  requires_redmine version_or_higher: '3.2.8'

  settings partial: 'settings/qangaroo_data_setting', default: {}
end

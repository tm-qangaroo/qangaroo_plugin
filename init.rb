require 'redmine'
require_relative 'lib/qangaroo/project_patch'
require_relative 'lib/qangaroo/issue_patch'

Redmine::Plugin.register :qangaroo_plugin do
  name 'Qangaroo Plugin'
  author 'TECHNO DIGITAL'
  description 'QangarooとRedmine連携するためのプラグインです。'
  version '2.0.0'
  url 'https://qangaroo.jp'
  author_url 'https://www.tcdigital.jp/'

  requires_redmine version_or_higher: '5.0.5'

  settings partial: 'settings/qangaroo_data_setting', default: {}
end

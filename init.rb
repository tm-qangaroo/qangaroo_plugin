Redmine::Plugin.register :qangaroo_plugin do
  name 'Practice plugin'
  author 'Technomobile'
  description 'QangarooとRedmine連携の練習'
  version '0.0.1'
  url 'https://qangaroo.jp'
  author_url 'https://tcmobile.jp'


  menu :application_menu, :services, { controller: 'services', action: 'index' }, caption: "Qangaroo"
  settings partial: 'settings/qangaroo_data_setting', default: {}
end
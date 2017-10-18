class ServicesController < ApplicationController
  unloadable
  before_action :load_service, only: [:edit, :update, :destroy, :get_qangaroo_data]

  def index
    @services = Service.all
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    @service.user_id = User.current.id
    if @service.save
      redirect_to root_url
    end
  end

  def edit
  end

  def update
    if @service.update_attributes(service_params)
      redirect_to root_url
    else
      render :edit
    end
  end

  def destroy
    @service.destroy
    redirect_to root_url
  end

  def get_qangaroo_data
    get_url = @service.namespace
    token = @service.api_key
    headers = { "X-USER-TOKEN" => @service.api_key, "Content-Type" => "application/json"}
    response = HTTParty.get("http://#{get_url}/api/v1/issues/generate_issue_data", :headers => headers)
    if response.response.class == Net::HTTPOK
      @projects = Project.visible.sorted
      @data = response.parsed_response
    else
      flash[:error] = l(:error_failed_api_connection)
      redirect_to root_url
    end
  end

  def register_issue
    @issue = Issue.new(
      subject: params["タイトル"],
      description: params["内容"],
      start_date: params["報告日"].to_datetime,
      project_id: params["project"],
      priority_id: Service.get_priority(params["優先度"]),
      tracker_id: Service.get_tracker(params["分類"]),
      status_id: 1,
      author_id: User.current.id
    )
    if @issue.save
      flash[:notice] = l(:successful_bug_load)
      redirect_to get_qangaroo_data_path
    else
      flash[:error] = l(:failed_bug_load)
      redirect_to get_qangaroo_data_path
    end
  end

  private
  def load_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :api_key, :namespace)
  end

end

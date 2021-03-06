class RegistrationsController < ApplicationController
  before_filter :require_authentication, :except => [:index, :vip]

  def new
    attendee = Attendee.new
    attendee.user = User.find(params[:user_id] || current_user.id)
    attendee.year = @year.year
    @registration = Registration.new(current_user, attendee)
    expose_legacy_form_vars # TODO: don't!
  end

  def create
    attendee = Attendee.new
    attendee.user = User.find(params[:user_id] || current_user.id)
    attendee.year = @year.year
    authorize! :create, attendee
    @registration = Registration.new(current_user, attendee)
    expose_legacy_form_vars # TODO: don't!
    if @registration.submit(params)
      redirect_to_terminus 'Attendee added'
    else
      render :new
    end
  end

  def edit
    attendee = Attendee.find(params[:id])
    authorize! :edit, attendee
    @registration = Registration.new(current_user, attendee)
    expose_legacy_form_vars # TODO: don't!
  end

  def update
    attendee = Attendee.find(params[:id])
    authorize! :update, attendee
    @registration = Registration.new(current_user, attendee)
    expose_legacy_form_vars # TODO: don't!
    if @registration.submit(params)
      redirect_to_terminus 'Changes saved'
    else
      render :edit
    end
  end

  private

  def expose_legacy_form_vars
    @plan_calendar = PlanCalendar.range_to_matrix(AttendeePlanDate.valid_range(@year))
    @show_availability = @registration.show_availability
  end

  def redirect_to_terminus flash_notice
    flash[:notice] = flash_notice
    redirect_to user_terminus_path(:user_id => @registration.user_id)
  end
end

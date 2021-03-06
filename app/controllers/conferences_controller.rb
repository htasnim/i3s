class ConferencesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  # GET /conferences
  # GET /conferences.json
  def index
    if current_user.role? :"System Admin"
      @conferences = Conference.all
    else
      if current_user.role? :"Conference Manager"
        @conferences = Conference.where("user_id = ?", current_user.id)
      else
        @conferences = Conference.where("is_active = ?", true)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conferences }

      @search = Conference.search(params[:search])
      if current_user.role? :"System Admin"
        @conferences = @search.all
      else
        if current_user.role? :"Conference Manager"
          @conferences = @search.where("user_id = ?", current_user.id)
        else
          @conferences = @search.where("is_active = ?", true)
        end
      end
    end
  end

  # GET /conferences/1
  # GET /conferences/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conference }
    end
  end

  # GET /conferences/new
  # GET /conferences/new.json
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conference }
    end
  end

  # GET /conferences/1/edit
  def edit
  end

  # POST /conferences
  # POST /conferences.json
  def create

    respond_to do |format|
      if @conference.save
        format.html { redirect_to @conference, notice: 'Conference was successfully created.' }
        format.json { render json: @conference, status: :created, location: @conference }
        UserMailer.new_conference_msg(@conference).deliver
      else
        format.html { render action: "new" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conferences/1
  # PUT /conferences/1.json
  def update

    respond_to do |format|
      if @conference.update_attributes(params[:conference])
        format.html { redirect_to @conference, notice: 'Conference was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conferences/1
  # DELETE /conferences/1.json
  def destroy
    @conference.destroy

    respond_to do |format|
      format.html { redirect_to conferences_url }
      format.json { head :no_content }
    end
  end
end

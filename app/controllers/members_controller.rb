# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :set_member, only: %i[show edit update destroy]

  # GET /members
  def index
    @members = Member.all
    @member_headlines_count = @members.joins(:headlines).group('headlines.member_id').count
  end

  # GET /members/1
  def show; end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit; end

  # POST /members
  def create
    @member = Member.new(member_params)

    if @member.save
      CollectHeadlinesJob.perform_later(@member.id)
      redirect_to @member, notice: 'Member was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /members/1
  def update
    if @member.update(member_params)
      redirect_to @member, notice: 'Member was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /members/1
  def destroy
    @member.destroy!
    redirect_to members_url, notice: 'Member was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def member_params
    params.require(:member).permit(:name, :website_url)
  end
end

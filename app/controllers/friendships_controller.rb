# frozen_string_literal: true

class FriendshipsController < ApplicationController
  def new
    @friendship = Friendship.new(member_id: params[:member_id], friend_id: params[:friend_id])
    @members = Member.all
  end

  def create
    @friendship = Friendship.new(friendship_params)

    if @friendship.save
      redirect_to members_path
    else
      @members = Member.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @friendship = Friendship.find(params[:id])

    if @friendship.destroy
      flash[:notice] = 'Friendship removed.'
    else
      flash[:alert] = 'Unable to remove friendship.'
    end
    redirect_back(fallback_location: members_path)
  end

  private

  def friendship_params
    params.require(:friendship).permit(:member_id, :friend_id)
  end
end

class InvitationsController < ApplicationController
  # POST /invitations
  # POST /invitations.json
  def create
    @invitation = Invitation.
      find_or_create_by(:user_id=>invitation_params[:user_id],
                        :email=>invitation_params[:email])
    if @invitation && UserMailer.invitation(@invitation).deliver
      @invitation.update_attribute(:msg_count, @invitation.msg_count + 1)
    end
    respond_to do |format|
      format.js
    end
  end

  def invitation_params
    params.require(:invitation).permit(:email, :user_id)
  end
end

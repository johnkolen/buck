module Admin::EmailAddressesHelper
  def email_address_fields ea
    out = show_field ea, :email
  end
  def email_address_edit_fields form
    out = edit_field form, :email
  end
end

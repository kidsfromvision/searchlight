module UserHelper
  def get_readable_role(role)
    readable_roles = {
      "label_employee" => "Employee",
      "label_admin" => "Admin",
    }
    return readable_roles[role]
  end
end

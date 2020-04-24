module RolesHelper
  def get_icon category
    if category == 'animator'
      material_icon.movie
    elsif category == 'artist'
      material_icon.palette
    elsif category == 'mixer'
      material_icon.headset
    elsif category == 'vocalist'
      material_icon.mic
    else # unknown category
      material_icon.help_outline
    end
  end

  def roles_to_hash roles_arr
    roles_hash = {}
    roles_arr.each do |role|
      roles_hash[role.category] ||= []
      roles_hash[role.category].push(role)
    end
    roles_hash
  end
end
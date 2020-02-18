module ApplicationHelper

  def create_placeholder
    width = rand(3999) + 1
    height = rand(3999) + 1
    bg_color = "%06x" % (rand * 0xffffff)
    return  { url: "https://via.placeholder.com/#{width}x#{height}/#{bg_color}/000000",
              artist: "Artist_#{rand(4000)}",
              portfolio: "Portfolio_#{rand(4000)}",
              price: "$#{rand(4000)}",
              width: width,
              height: height,
              created_at: Time.at(Time.now.to_f * rand),
            }

  end

  def create_placeholder_array
    placeholders = []
    100.times do
      placeholders.push(create_placeholder)
    end
    puts placeholders[0]
    placeholders
  end
end

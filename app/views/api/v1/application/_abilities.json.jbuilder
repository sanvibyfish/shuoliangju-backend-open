json.abilities do
  json.destroy can?(:destroy, object)
  if object && object.is_a?(Post)
    %i[top untop excellent unexcellent ban unban report].each do |action|
      json.set! action, can?(action, object)
    end
  end
  if object && object.is_a?(App) 
    %i[join].each do |action|
      json.set! action, can?(action, object)
    end
  end
  if object && object.is_a?(User) 
    %i[ban report].each do |action|
      json.set! action, can?(action, object)
    end
  end
end